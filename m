From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mremap_dontunmap-to-mremap.patch added to -mm
 tree
Date: Sun, 09 Feb 2020 17:22:50 -0800
Message-ID: <20200210012250.ZoQ5GbMvj%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgBJBWw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 20:22:52 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, arnd@arndb.de, bgeffon@google.com, fweimer@redhat.com, joel@joelfernandes.org, jsbarnes@google.com, kirill@shutemov.name, luto@amacapital.net, minchan@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, natechancellor@gmail.com, sonnyrao@google.com, will@kernel.org, yuzhao@google.com


The patch titled
     Subject: mm/mremap: add MREMAP_DONTUNMAP to mremap()
has been added to the -mm tree.  Its filename is
     mm-add-mremap_dontunmap-to-mremap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-mremap_dontunmap-to-mre=
map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-mremap_dontunmap-to-mre=
map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Brian Geffon <bgeffon@google.com>
Subject: mm/mremap: add MREMAP_DONTUNMAP to mremap()

When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is set,
the source mapping will not be removed.  Instead it will be cleared as if
a brand new anonymous, private mapping had been created atomically as part
of the mremap() call.  =C2=A0If a userfaultfd was watching the source, it w=
ill
continue to watch the new mapping.  =C2=A0For a mapping that is shared or n=
ot
anonymous, MREMAP_DONTUNMAP will cause the mremap() call to fail.  Because
MREMAP_DONTUNMAP always results in moving a VMA you MUST use the
MREMAP_MAYMOVE flag.  The final result is two equally sized VMAs where the
destination contains the PTEs of the source.

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

Link: http://lkml.kernel.org/r/20200207201856.46070-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
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
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mman.h |    5 +
 mm/mremap.c               |   98 ++++++++++++++++++++++++++++--------
 2 files changed, 80 insertions(+), 23 deletions(-)

--- a/include/uapi/linux/mman.h~mm-add-mremap_dontunmap-to-mremap
+++ a/include/uapi/linux/mman.h
@@ -5,8 +5,9 @@
 #include <asm/mman.h>
 #include <asm-generic/hugetlb_encode.h>
=20
-#define MREMAP_MAYMOVE	1
-#define MREMAP_FIXED	2
+#define MREMAP_MAYMOVE		1
+#define MREMAP_FIXED		2
+#define MREMAP_DONTUNMAP	4
=20
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
 	struct mm_struct *mm =3D vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -408,11 +408,41 @@ static unsigned long move_vma(struct vm_
 	if (unlikely(vma->vm_flags & VM_PFNMAP))
 		untrack_pfn_moved(vma);
=20
+	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
+		if (vm_flags & VM_ACCOUNT) {
+			/* Always put back VM_ACCOUNT since we won't unmap */
+			vma->vm_flags |=3D VM_ACCOUNT;
+
+			vm_acct_memory(vma_pages(new_vma));
+		}
+
+		/*
+		 * locked_vm accounting: if the mapping remained the same size
+		 * it will have just moved and we don't need to touch locked_vm
+		 * because we skip the do_unmap. If the mapping shrunk before
+		 * being moved then the do_unmap on that portion will have
+		 * adjusted vm_locked. Only if the mapping grows do we need to
+		 * do something special; the reason is locked_vm only accounts
+		 * for old_len, but we're now adding new_len - old_len locked
+		 * bytes to the new mapping.
+		 */
+		if (new_len > old_len)
+			mm->locked_vm +=3D (new_len - old_len) >> PAGE_SHIFT;
+
+		goto out;
+	}
+
 	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		vm_unacct_memory(excess >> PAGE_SHIFT);
 		excess =3D 0;
 	}
+
+	if (vm_flags & VM_LOCKED) {
+		mm->locked_vm +=3D new_len >> PAGE_SHIFT;
+		*locked =3D true;
+	}
+out:
 	mm->hiwater_vm =3D hiwater_vm;
=20
 	/* Restore VM_ACCOUNT if one or two pieces of vma left */
@@ -422,16 +452,12 @@ static unsigned long move_vma(struct vm_
 			vma->vm_next->vm_flags |=3D VM_ACCOUNT;
 	}
=20
-	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm +=3D new_len >> PAGE_SHIFT;
-		*locked =3D true;
-	}
-
 	return new_addr;
 }
=20
 static struct vm_area_struct *vma_to_resize(unsigned long addr,
-	unsigned long old_len, unsigned long new_len, unsigned long *p)
+	unsigned long old_len, unsigned long new_len, unsigned long flags,
+	unsigned long *p)
 {
 	struct mm_struct *mm =3D current->mm;
 	struct vm_area_struct *vma =3D find_vma(mm, addr);
@@ -453,6 +479,10 @@ static struct vm_area_struct *vma_to_res
 		return ERR_PTR(-EINVAL);
 	}
=20
+	if (flags & MREMAP_DONTUNMAP && (!vma_is_anonymous(vma) ||
+			vma->vm_flags & VM_SHARED))
+		return ERR_PTR(-EINVAL);
+
 	if (is_vm_hugetlb_page(vma))
 		return ERR_PTR(-EINVAL);
=20
@@ -497,7 +527,7 @@ static struct vm_area_struct *vma_to_res
=20
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 		unsigned long new_addr, unsigned long new_len, bool *locked,
-		struct vm_userfaultfd_ctx *uf,
+		unsigned long flags, struct vm_userfaultfd_ctx *uf,
 		struct list_head *uf_unmap_early,
 		struct list_head *uf_unmap)
 {
@@ -505,7 +535,7 @@ static unsigned long mremap_to(unsigned
 	struct vm_area_struct *vma;
 	unsigned long ret =3D -EINVAL;
 	unsigned long charged =3D 0;
-	unsigned long map_flags;
+	unsigned long map_flags =3D 0;
=20
 	if (offset_in_page(new_addr))
 		goto out;
@@ -534,9 +564,11 @@ static unsigned long mremap_to(unsigned
 	if ((mm->map_count + 2) >=3D sysctl_max_map_count - 3)
 		return -ENOMEM;
=20
-	ret =3D do_munmap(mm, new_addr, new_len, uf_unmap_early);
-	if (ret)
-		goto out;
+	if (flags & MREMAP_FIXED) {
+		ret =3D do_munmap(mm, new_addr, new_len, uf_unmap_early);
+		if (ret)
+			goto out;
+	}
=20
 	if (old_len >=3D new_len) {
 		ret =3D do_munmap(mm, addr+new_len, old_len - new_len, uf_unmap);
@@ -545,13 +577,26 @@ static unsigned long mremap_to(unsigned
 		old_len =3D new_len;
 	}
=20
-	vma =3D vma_to_resize(addr, old_len, new_len, &charged);
+	vma =3D vma_to_resize(addr, old_len, new_len, flags, &charged);
 	if (IS_ERR(vma)) {
 		ret =3D PTR_ERR(vma);
 		goto out;
 	}
=20
-	map_flags =3D MAP_FIXED;
+	/*
+	 * MREMAP_DONTUNMAP expands by new_len - (new_len - old_len), we will
+	 * check that we can expand by new_len and vma_to_resize will handle
+	 * the vma growing which is (new_len - old_len).
+	 */
+	if (flags & MREMAP_DONTUNMAP &&
+		!may_expand_vm(mm, vma->vm_flags, new_len >> PAGE_SHIFT)) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+
+	if (flags & MREMAP_FIXED)
+		map_flags |=3D MAP_FIXED;
+
 	if (vma->vm_flags & VM_MAYSHARE)
 		map_flags |=3D MAP_SHARED;
=20
@@ -561,10 +606,16 @@ static unsigned long mremap_to(unsigned
 	if (IS_ERR_VALUE(ret))
 		goto out1;
=20
-	ret =3D move_vma(vma, addr, old_len, new_len, new_addr, locked, uf,
+	/* We got a new mapping */
+	if (!(flags & MREMAP_FIXED))
+		new_addr =3D ret;
+
+	ret =3D move_vma(vma, addr, old_len, new_len, new_addr, locked, flags, uf,
 		       uf_unmap);
+
 	if (!(offset_in_page(ret)))
 		goto out;
+
 out1:
 	vm_unacct_memory(charged);
=20
@@ -609,12 +660,16 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	addr =3D untagged_addr(addr);
 	new_addr =3D untagged_addr(new_addr);
=20
-	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
+	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP))
 		return ret;
=20
 	if (flags & MREMAP_FIXED && !(flags & MREMAP_MAYMOVE))
 		return ret;
=20
+	/* MREMAP_DONTUNMAP is always a move */
+	if (flags & MREMAP_DONTUNMAP && !(flags & MREMAP_MAYMOVE))
+		return ret;
+
 	if (offset_in_page(addr))
 		return ret;
=20
@@ -632,9 +687,10 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	if (down_write_killable(&current->mm->mmap_sem))
 		return -EINTR;
=20
-	if (flags & MREMAP_FIXED) {
+	if (flags & MREMAP_FIXED || flags & MREMAP_DONTUNMAP) {
 		ret =3D mremap_to(addr, old_len, new_addr, new_len,
-				&locked, &uf, &uf_unmap_early, &uf_unmap);
+				&locked, flags, &uf, &uf_unmap_early,
+				&uf_unmap);
 		goto out;
 	}
=20
@@ -662,7 +718,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	/*
 	 * Ok, we need to grow..
 	 */
-	vma =3D vma_to_resize(addr, old_len, new_len, &charged);
+	vma =3D vma_to_resize(addr, old_len, new_len, flags, &charged);
 	if (IS_ERR(vma)) {
 		ret =3D PTR_ERR(vma);
 		goto out;
@@ -712,7 +768,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		}
=20
 		ret =3D move_vma(vma, addr, old_len, new_len, new_addr,
-			       &locked, &uf, &uf_unmap);
+			       &locked, flags, &uf, &uf_unmap);
 	}
 out:
 	if (offset_in_page(ret)) {
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-add-mremap_dontunmap-to-mremap.patch
