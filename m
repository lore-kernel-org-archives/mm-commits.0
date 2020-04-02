From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 106/155] mm/mremap: add MREMAP_DONTUNMAP to
 mremap()
Date: Wed, 01 Apr 2020 21:09:17 -0700
Message-ID: <20200402040917.hq6rsr5i3%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEJT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:19 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, bgeffon@google.com, fweimer@redhat.com, joel@joelfernandes.org, jsbarnes@google.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, lokeshgidra@google.com, luto@amacapital.net, minchan@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, natechancellor@gmail.com, sonnyrao@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, will@kernel.org, yuzhao@google.com

From: Brian Geffon <bgeffon@google.com>
Subject: mm/mremap: add MREMAP_DONTUNMAP to mremap()

When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is set,
the source mapping will not be removed.  The remap operation will be
performed as it would have been normally by moving over the page tables to
the new mapping.  The old vma will have any locked flags cleared, have no
pagetables, and any userfaultfds that were watching that range will
continue watching it.

For a mapping that is shared or not anonymous, MREMAP_DONTUNMAP will cause
the mremap() call to fail.  Because MREMAP_DONTUNMAP always results in
moving a VMA you MUST use the MREMAP_MAYMOVE flag, it's not possible to
resize a VMA while also moving with MREMAP_DONTUNMAP so old_len must
always be equal to the new_len otherwise it will return -EINVAL.

We hope to use this in Chrome OS where with userfaultfd we could write an
anonymous mapping to disk without having to STOP the process or worry
about VMA permission changes.

This feature also has a use case in Android, Lokesh Gidra has said that
"As part of using userfaultfd for GC, We'll have to move the physical
pages of the java heap to a separate location.  For this purpose mremap
will be used.  Without the MREMAP_DONTUNMAP flag, when I mremap the java
heap, its virtual mapping will be removed as well.  Therefore, we'll
require performing mmap immediately after.  This is not only time
consuming but also opens a time window where a native thread may call mmap
and reserve the java heap's address range for its own usage.  This flag
solves the problem."

[bgeffon@google.com: v6]
  Link: http://lkml.kernel.org/r/20200218173221.237674-1-bgeffon@google.com
[bgeffon@google.com: v7]
  Link: http://lkml.kernel.org/r/20200221174248.244748-1-bgeffon@google.com
Link: http://lkml.kernel.org/r/20200207201856.46070-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Tested-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Deacon <will@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Jesse Barnes <jsbarnes@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mman.h |    5 +-
 mm/mremap.c               |   90 +++++++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 23 deletions(-)

--- a/include/uapi/linux/mman.h~mm-add-mremap_dontunmap-to-mremap
+++ a/include/uapi/linux/mman.h
@@ -5,8 +5,9 @@
 #include <asm/mman.h>
 #include <asm-generic/hugetlb_encode.h>
 
-#define MREMAP_MAYMOVE	1
-#define MREMAP_FIXED	2
+#define MREMAP_MAYMOVE		1
+#define MREMAP_FIXED		2
+#define MREMAP_DONTUNMAP	4
 
 #define OVERCOMMIT_GUESS		0
 #define OVERCOMMIT_ALWAYS		1
--- a/mm/mremap.c~mm-add-mremap_dontunmap-to-mremap
+++ a/mm/mremap.c
@@ -318,8 +318,8 @@ unsigned long move_page_tables(struct vm
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
 		unsigned long new_len, unsigned long new_addr,
-		bool *locked, struct vm_userfaultfd_ctx *uf,
-		struct list_head *uf_unmap)
+		bool *locked, unsigned long flags,
+		struct vm_userfaultfd_ctx *uf, struct list_head *uf_unmap)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -408,11 +408,32 @@ static unsigned long move_vma(struct vm_
 	if (unlikely(vma->vm_flags & VM_PFNMAP))
 		untrack_pfn_moved(vma);
 
+	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
+		if (vm_flags & VM_ACCOUNT) {
+			/* Always put back VM_ACCOUNT since we won't unmap */
+			vma->vm_flags |= VM_ACCOUNT;
+
+			vm_acct_memory(vma_pages(new_vma));
+		}
+
+		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
+		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+
+		/* Because we won't unmap we don't need to touch locked_vm */
+		goto out;
+	}
+
 	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		vm_unacct_memory(excess >> PAGE_SHIFT);
 		excess = 0;
 	}
+
+	if (vm_flags & VM_LOCKED) {
+		mm->locked_vm += new_len >> PAGE_SHIFT;
+		*locked = true;
+	}
+out:
 	mm->hiwater_vm = hiwater_vm;
 
 	/* Restore VM_ACCOUNT if one or two pieces of vma left */
@@ -422,16 +443,12 @@ static unsigned long move_vma(struct vm_
 			vma->vm_next->vm_flags |= VM_ACCOUNT;
 	}
 
-	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm += new_len >> PAGE_SHIFT;
-		*locked = true;
-	}
-
 	return new_addr;
 }
 
 static struct vm_area_struct *vma_to_resize(unsigned long addr,
-	unsigned long old_len, unsigned long new_len, unsigned long *p)
+	unsigned long old_len, unsigned long new_len, unsigned long flags,
+	unsigned long *p)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = find_vma(mm, addr);
@@ -453,6 +470,10 @@ static struct vm_area_struct *vma_to_res
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (flags & MREMAP_DONTUNMAP && (!vma_is_anonymous(vma) ||
+			vma->vm_flags & VM_SHARED))
+		return ERR_PTR(-EINVAL);
+
 	if (is_vm_hugetlb_page(vma))
 		return ERR_PTR(-EINVAL);
 
@@ -497,7 +518,7 @@ static struct vm_area_struct *vma_to_res
 
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 		unsigned long new_addr, unsigned long new_len, bool *locked,
-		struct vm_userfaultfd_ctx *uf,
+		unsigned long flags, struct vm_userfaultfd_ctx *uf,
 		struct list_head *uf_unmap_early,
 		struct list_head *uf_unmap)
 {
@@ -505,7 +526,7 @@ static unsigned long mremap_to(unsigned
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
-	unsigned long map_flags;
+	unsigned long map_flags = 0;
 
 	if (offset_in_page(new_addr))
 		goto out;
@@ -534,9 +555,11 @@ static unsigned long mremap_to(unsigned
 	if ((mm->map_count + 2) >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
-	ret = do_munmap(mm, new_addr, new_len, uf_unmap_early);
-	if (ret)
-		goto out;
+	if (flags & MREMAP_FIXED) {
+		ret = do_munmap(mm, new_addr, new_len, uf_unmap_early);
+		if (ret)
+			goto out;
+	}
 
 	if (old_len >= new_len) {
 		ret = do_munmap(mm, addr+new_len, old_len - new_len, uf_unmap);
@@ -545,13 +568,22 @@ static unsigned long mremap_to(unsigned
 		old_len = new_len;
 	}
 
-	vma = vma_to_resize(addr, old_len, new_len, &charged);
+	vma = vma_to_resize(addr, old_len, new_len, flags, &charged);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
 	}
 
-	map_flags = MAP_FIXED;
+	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
+	if (flags & MREMAP_DONTUNMAP &&
+		!may_expand_vm(mm, vma->vm_flags, old_len >> PAGE_SHIFT)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (flags & MREMAP_FIXED)
+		map_flags |= MAP_FIXED;
+
 	if (vma->vm_flags & VM_MAYSHARE)
 		map_flags |= MAP_SHARED;
 
@@ -561,10 +593,16 @@ static unsigned long mremap_to(unsigned
 	if (IS_ERR_VALUE(ret))
 		goto out1;
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, uf,
+	/* We got a new mapping */
+	if (!(flags & MREMAP_FIXED))
+		new_addr = ret;
+
+	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, flags, uf,
 		       uf_unmap);
+
 	if (!(offset_in_page(ret)))
 		goto out;
+
 out1:
 	vm_unacct_memory(charged);
 
@@ -618,12 +656,21 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	 */
 	addr = untagged_addr(addr);
 
-	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
+	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP))
 		return ret;
 
 	if (flags & MREMAP_FIXED && !(flags & MREMAP_MAYMOVE))
 		return ret;
 
+	/*
+	 * MREMAP_DONTUNMAP is always a move and it does not allow resizing
+	 * in the process.
+	 */
+	if (flags & MREMAP_DONTUNMAP &&
+			(!(flags & MREMAP_MAYMOVE) || old_len != new_len))
+		return ret;
+
+
 	if (offset_in_page(addr))
 		return ret;
 
@@ -641,9 +688,10 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	if (down_write_killable(&current->mm->mmap_sem))
 		return -EINTR;
 
-	if (flags & MREMAP_FIXED) {
+	if (flags & (MREMAP_FIXED | MREMAP_DONTUNMAP)) {
 		ret = mremap_to(addr, old_len, new_addr, new_len,
-				&locked, &uf, &uf_unmap_early, &uf_unmap);
+				&locked, flags, &uf, &uf_unmap_early,
+				&uf_unmap);
 		goto out;
 	}
 
@@ -671,7 +719,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	/*
 	 * Ok, we need to grow..
 	 */
-	vma = vma_to_resize(addr, old_len, new_len, &charged);
+	vma = vma_to_resize(addr, old_len, new_len, flags, &charged);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
@@ -721,7 +769,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		}
 
 		ret = move_vma(vma, addr, old_len, new_len, new_addr,
-			       &locked, &uf, &uf_unmap);
+			       &locked, flags, &uf, &uf_unmap);
 	}
 out:
 	if (offset_in_page(ret)) {
_
