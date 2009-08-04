From: akpm@linux-foundation.org
Subject: + kcore-fix-vread-vwrite-to-be-aware-of-holes.patch added to -mm tree
Date: Tue, 04 Aug 2009 14:30:58 -0700
Message-ID: <200908042130.n74LUxr8027929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601AbZHDVbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 17:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, scgtrp@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     kcore: fix vread/vwrite to be aware of holes
has been added to the -mm tree.  Its filename is
     kcore-fix-vread-vwrite-to-be-aware-of-holes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore: fix vread/vwrite to be aware of holes
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

vread/vwrite access vmalloc area without checking there is a page or not. 
In most case, this works well.

In old ages, the caller of get_vm_ara() is only IOREMAP and there is no
memory hole within vm_struct's [addr...addr + size - PAGE_SIZE] (
-PAGE_SIZE is for a guard page.)

After per-cpu-alloc patch, it uses get_vm_area() for reserve continuous
virtual address but remap _later_.  There tend to be a hole in valid
vmalloc area in vm_struct lists.  Then, skip the hole (not mapped page) is
necessary.  This patch updates vread/vwrite() for avoiding memory hole.

Routines which access vmalloc area without knowing for which addr is used
are
  - /proc/kcore
  - /dev/kmem

kcore checks IOREMAP, /dev/kmem doesn't.  After this patch, IOREMAP is
checked and /dev/kmem will avoid to read/write it.  Fixes to /proc/kcore
will be in the next patch in series.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |  182 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 159 insertions(+), 23 deletions(-)

diff -puN mm/vmalloc.c~kcore-fix-vread-vwrite-to-be-aware-of-holes mm/vmalloc.c
--- a/mm/vmalloc.c~kcore-fix-vread-vwrite-to-be-aware-of-holes
+++ a/mm/vmalloc.c
@@ -25,7 +25,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
-
+#include <linux/highmem.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
@@ -1627,10 +1627,109 @@ void *vmalloc_32_user(unsigned long size
 }
 EXPORT_SYMBOL(vmalloc_32_user);
 
+/*
+ * small helper routine , copy contents to buf from addr.
+ * If the page is not present, fill zero.
+ */
+
+static int aligned_vread(char *buf, char *addr, unsigned long count)
+{
+	struct page *p;
+	int copied = 0;
+
+	while (count) {
+		unsigned long offset, length;
+
+		offset = (unsigned long)addr & ~PAGE_MASK;
+		length = PAGE_SIZE - offset;
+		if (length > count)
+			length = count;
+		p = vmalloc_to_page(addr);
+		/*
+		 * To do safe access to this _mapped_ area, we need
+		 * lock. But adding lock here means that we need to add
+		 * overhead of vmalloc()/vfree() calles for this _debug_
+		 * interface, rarely used. Instead of that, we'll use
+		 * kmap() and get small overhead in this access function.
+		 */
+		if (p) {
+			/* we can expect USR1 is not used */
+			void *map = kmap_atomic(p, KM_USER1);
+			memcpy(buf, map + offset, length);
+			kunmap_atomic(map, KM_USER1);
+		} else
+			memset(buf, 0, length);
+
+		addr += length;
+		buf += length;
+		copied += length;
+		count -= length;
+	}
+	return copied;
+}
+
+static int aligned_vwrite(char *buf, char *addr, unsigned long count)
+{
+	struct page *p;
+	int copied = 0;
+
+	while (count) {
+		unsigned long offset, length;
+
+		offset = (unsigned long)addr & ~PAGE_MASK;
+		length = PAGE_SIZE - offset;
+		if (length > count)
+			length = count;
+		p = vmalloc_to_page(addr);
+		/*
+		 * To do safe access to this _mapped_ area, we need
+		 * lock. But adding lock here means that we need to add
+		 * overhead of vmalloc()/vfree() calles for this _debug_
+		 * interface, rarely used. Instead of that, we'll use
+		 * kmap() and get small overhead in this access function.
+		 */
+		if (p) {
+			/* we can expect USR1 is not used */
+			void *map = kmap_atomic(p, KM_USER1);
+			memcpy(map + offset, buf, length);
+			kunmap_atomic(map, KM_USER1);
+		}
+		addr += length;
+		buf += length;
+		copied += length;
+		count -= length;
+	}
+	return copied;
+}
+
+/**
+ *	vread() -  read vmalloc area in a safe way.
+ *	@buf:		buffer for reading data
+ *	@addr:		vm address.
+ *	@count:		number of bytes to be read.
+ *
+ *	Returns # of bytes which addr and buf should be increased.
+ *	(same to count).
+ *	If [addr...addr+count) doesn't includes any valid area, returns 0.
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	copy data from that area to a given buffer. If the given memory range of
+ *	[addr...addr+count) includes some valid address, data is copied to
+ *	proper area of @buf. If there are memory holes, they'll be zero-filled.
+ *	IOREMAP area is treated as memory hole and no copy is done.
+ *
+ *	Note: In usual ops, vread() is never necessary because the caller should
+ *	know vmalloc() area is valid and can use memcpy(). This is for routines
+ *	which have to access vmalloc area without any informaion, as /dev/kmem.
+ *
+ *	The caller should guarantee KM_USER1 is not used.
+ */
+
 long vread(char *buf, char *addr, unsigned long count)
 {
 	struct vm_struct *tmp;
 	char *vaddr, *buf_start = buf;
+	unsigned long buflen = count;
 	unsigned long n;
 
 	/* Don't allow overflow */
@@ -1638,7 +1737,7 @@ long vread(char *buf, char *addr, unsign
 		count = -(unsigned long) addr;
 
 	read_lock(&vmlist_lock);
-	for (tmp = vmlist; tmp; tmp = tmp->next) {
+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
 			continue;
@@ -1651,32 +1750,66 @@ long vread(char *buf, char *addr, unsign
 			count--;
 		}
 		n = vaddr + tmp->size - PAGE_SIZE - addr;
-		do {
-			if (count == 0)
-				goto finished;
-			*buf = *addr;
-			buf++;
-			addr++;
-			count--;
-		} while (--n > 0);
+		if (n > count)
+			n = count;
+		if (!(tmp->flags & VM_IOREMAP))
+			aligned_vread(buf, addr, n);
+		else /* IOREMAP area is treated as memory hole */
+			memset(buf, 0, n);
+		buf += n;
+		addr += n;
+		count -= n;
 	}
 finished:
 	read_unlock(&vmlist_lock);
-	return buf - buf_start;
+
+	if (buf == buf_start)
+		return 0;
+	/* zero-fill memory holes */
+	if (buf != buf_start + buflen)
+		memset(buf, 0, buflen - (buf - buf_start));
+
+	return buflen;
 }
 
+/**
+ *	vwrite() -  write vmalloc area in a safe way.
+ *	@buf:		buffer for source data
+ *	@addr:		vm address.
+ *	@count:		number of bytes to be read.
+ *
+ *	Returns # of bytes which addr and buf should be incresed.
+ *	(same to count).
+ *	If [addr...addr+count) doesn't includes any valid area, returns 0.
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	copy data from a buffer to the given addr. If specified range of
+ *	[addr...addr+count) includes some valid address, data is copied from
+ *	proper area of @buf. If there are memory holes, no copy to hole.
+ *	IOREMAP area is treated as memory hole and no copy is done.
+ *
+ *	Note: In usual ops, vwrite() is never necessary because the caller
+ *	should know vmalloc() area is valid and can use memcpy().
+ *	This is for routines which have to access vmalloc area without
+ *	any informaion, as /dev/kmem.
+ *
+ *	The caller should guarantee KM_USER1 is not used.
+ */
+
 long vwrite(char *buf, char *addr, unsigned long count)
 {
 	struct vm_struct *tmp;
-	char *vaddr, *buf_start = buf;
-	unsigned long n;
+	char *vaddr;
+	unsigned long n, buflen;
+	int copied = 0;
 
 	/* Don't allow overflow */
 	if ((unsigned long) addr + count < count)
 		count = -(unsigned long) addr;
+	buflen = count;
 
 	read_lock(&vmlist_lock);
-	for (tmp = vmlist; tmp; tmp = tmp->next) {
+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
 			continue;
@@ -1688,18 +1821,21 @@ long vwrite(char *buf, char *addr, unsig
 			count--;
 		}
 		n = vaddr + tmp->size - PAGE_SIZE - addr;
-		do {
-			if (count == 0)
-				goto finished;
-			*addr = *buf;
-			buf++;
-			addr++;
-			count--;
-		} while (--n > 0);
+		if (n > count)
+			n = count;
+		if (!(tmp->flags & VM_IOREMAP)) {
+			aligned_vwrite(buf, addr, n);
+			copied++;
+		}
+		buf += n;
+		addr += n;
+		count -= n;
 	}
 finished:
 	read_unlock(&vmlist_lock);
-	return buf - buf_start;
+	if (!copied)
+		return 0;
+	return buflen;
 }
 
 /**
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
mm-introduce-proc-pid-oom_adj_child.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-proc-kcore-should-use-vread.patch
kcore-fix-proc-kcores-statst_size.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch

