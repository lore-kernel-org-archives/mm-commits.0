From: akpm@linux-foundation.org
Subject: [merged] kcore-fix-vread-vwrite-to-be-aware-of-holes.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:47 -0700
Message-ID: <200909222040.n8MKelnV006268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbZIVUlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, scgtrp@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kcore: fix vread/vwrite to be aware of holes
has been removed from the -mm tree.  Its filename was
     kcore-fix-vread-vwrite-to-be-aware-of-holes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 mm/vmalloc.c |  199 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 176 insertions(+), 23 deletions(-)

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
@@ -1643,10 +1643,120 @@ void *vmalloc_32_user(unsigned long size
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
+			/*
+			 * we can expect USER0 is not used (see vread/vwrite's
+			 * function description)
+			 */
+			void *map = kmap_atomic(p, KM_USER0);
+			memcpy(buf, map + offset, length);
+			kunmap_atomic(map, KM_USER0);
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
+			/*
+			 * we can expect USER0 is not used (see vread/vwrite's
+			 * function description)
+			 */
+			void *map = kmap_atomic(p, KM_USER0);
+			memcpy(map + offset, buf, length);
+			kunmap_atomic(map, KM_USER0);
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
+ *	(same number to @count). Returns 0 if [addr...addr+count) doesn't
+ *	includes any intersect with alive vmalloc area.
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	copy data from that area to a given buffer. If the given memory range
+ *	of [addr...addr+count) includes some valid address, data is copied to
+ *	proper area of @buf. If there are memory holes, they'll be zero-filled.
+ *	IOREMAP area is treated as memory hole and no copy is done.
+ *
+ *	If [addr...addr+count) doesn't includes any intersects with alive
+ *	vm_struct area, returns 0.
+ *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
+ *	the caller should guarantee KM_USER0 is not used.
+ *
+ *	Note: In usual ops, vread() is never necessary because the caller
+ *	should know vmalloc() area is valid and can use memcpy().
+ *	This is for routines which have to access vmalloc area without
+ *	any informaion, as /dev/kmem.
+ *
+ */
+
 long vread(char *buf, char *addr, unsigned long count)
 {
 	struct vm_struct *tmp;
 	char *vaddr, *buf_start = buf;
+	unsigned long buflen = count;
 	unsigned long n;
 
 	/* Don't allow overflow */
@@ -1654,7 +1764,7 @@ long vread(char *buf, char *addr, unsign
 		count = -(unsigned long) addr;
 
 	read_lock(&vmlist_lock);
-	for (tmp = vmlist; tmp; tmp = tmp->next) {
+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
 			continue;
@@ -1667,32 +1777,72 @@ long vread(char *buf, char *addr, unsign
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
+ *	(same number to @count).
+ *	If [addr...addr+count) doesn't includes any intersect with valid
+ *	vmalloc area, returns 0.
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	copy data from a buffer to the given addr. If specified range of
+ *	[addr...addr+count) includes some valid address, data is copied from
+ *	proper area of @buf. If there are memory holes, no copy to hole.
+ *	IOREMAP area is treated as memory hole and no copy is done.
+ *
+ *	If [addr...addr+count) doesn't includes any intersects with alive
+ *	vm_struct area, returns 0.
+ *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
+ *	the caller should guarantee KM_USER0 is not used.
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
@@ -1704,18 +1854,21 @@ long vwrite(char *buf, char *addr, unsig
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

origin.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
walk-system-ram-range-fix.patch
walk-system-ram-range-fix-2.patch
kcore-use-registerd-physmem-information.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
kcore-more-fixes-for-init.patch
proc-kcore-fix-statst_size.patch
proc-kcore-update-statst_size-after-memory-hotplug.patch
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
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

