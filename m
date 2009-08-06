From: akpm@linux-foundation.org
Subject: + kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch added to -mm tree
Date: Wed, 05 Aug 2009 17:47:35 -0700
Message-ID: <200908060047.n760lZeX023299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbZHFAsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 20:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, scgtrp@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     kcore-fix-vread-vwrite-to-be-aware-of-holes-update
has been added to the -mm tree.  Its filename is
     kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch

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
Subject: kcore-fix-vread-vwrite-to-be-aware-of-holes-update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelov v3->v3.1
 - fixed comments. (mainly vread/vwrite description is updated.)
 - use KM_USER0 instead of KM_USER1

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff -puN mm/vmalloc.c~kcore-fix-vread-vwrite-to-be-aware-of-holes-update mm/vmalloc.c
--- a/mm/vmalloc.c~kcore-fix-vread-vwrite-to-be-aware-of-holes-update
+++ a/mm/vmalloc.c
@@ -1653,10 +1653,13 @@ static int aligned_vread(char *buf, char
 		 * kmap() and get small overhead in this access function.
 		 */
 		if (p) {
-			/* we can expect USR1 is not used */
-			void *map = kmap_atomic(p, KM_USER1);
+			/*
+			 * we can expect USER0 is not used (see vread/vwrite's
+			 * function description)
+			 */
+			void *map = kmap_atomic(p, KM_USER0);
 			memcpy(buf, map + offset, length);
-			kunmap_atomic(map, KM_USER1);
+			kunmap_atomic(map, KM_USER0);
 		} else
 			memset(buf, 0, length);
 
@@ -1689,10 +1692,13 @@ static int aligned_vwrite(char *buf, cha
 		 * kmap() and get small overhead in this access function.
 		 */
 		if (p) {
-			/* we can expect USR1 is not used */
-			void *map = kmap_atomic(p, KM_USER1);
+			/*
+			 * we can expect USER0 is not used (see vread/vwrite's
+			 * function description)
+			 */
+			void *map = kmap_atomic(p, KM_USER0);
 			memcpy(map + offset, buf, length);
-			kunmap_atomic(map, KM_USER1);
+			kunmap_atomic(map, KM_USER0);
 		}
 		addr += length;
 		buf += length;
@@ -1709,20 +1715,25 @@ static int aligned_vwrite(char *buf, cha
  *	@count:		number of bytes to be read.
  *
  *	Returns # of bytes which addr and buf should be increased.
- *	(same to count).
- *	If [addr...addr+count) doesn't includes any valid area, returns 0.
+ *	(same number to @count). Returns 0 if [addr...addr+count) doesn't
+ *	includes any intersect with alive vmalloc area.
  *
  *	This function checks that addr is a valid vmalloc'ed area, and
- *	copy data from that area to a given buffer. If the given memory range of
- *	[addr...addr+count) includes some valid address, data is copied to
+ *	copy data from that area to a given buffer. If the given memory range
+ *	of [addr...addr+count) includes some valid address, data is copied to
  *	proper area of @buf. If there are memory holes, they'll be zero-filled.
  *	IOREMAP area is treated as memory hole and no copy is done.
  *
- *	Note: In usual ops, vread() is never necessary because the caller should
- *	know vmalloc() area is valid and can use memcpy(). This is for routines
- *	which have to access vmalloc area without any informaion, as /dev/kmem.
+ *	If [addr...addr+count) doesn't includes any intersects with alive
+ *	vm_struct area, returns 0.
+ *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
+ *	the caller should guarantee KM_USER0 is not used.
+ *
+ *	Note: In usual ops, vread() is never necessary because the caller
+ *	should know vmalloc() area is valid and can use memcpy().
+ *	This is for routines which have to access vmalloc area without
+ *	any informaion, as /dev/kmem.
  *
- *	The caller should guarantee KM_USER1 is not used.
  */
 
 long vread(char *buf, char *addr, unsigned long count)
@@ -1779,8 +1790,9 @@ finished:
  *	@count:		number of bytes to be read.
  *
  *	Returns # of bytes which addr and buf should be incresed.
- *	(same to count).
- *	If [addr...addr+count) doesn't includes any valid area, returns 0.
+ *	(same number to @count).
+ *	If [addr...addr+count) doesn't includes any intersect with valid
+ *	vmalloc area, returns 0.
  *
  *	This function checks that addr is a valid vmalloc'ed area, and
  *	copy data from a buffer to the given addr. If specified range of
@@ -1788,6 +1800,11 @@ finished:
  *	proper area of @buf. If there are memory holes, no copy to hole.
  *	IOREMAP area is treated as memory hole and no copy is done.
  *
+ *	If [addr...addr+count) doesn't includes any intersects with alive
+ *	vm_struct area, returns 0.
+ *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
+ *	the caller should guarantee KM_USER0 is not used.
+ *
  *	Note: In usual ops, vwrite() is never necessary because the caller
  *	should know vmalloc() area is valid and can use memcpy().
  *	This is for routines which have to access vmalloc area without
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix-2.patch
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
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
oom-move-oom_adj-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
oom-fix-oom_adjust_write-input-sanity-check-fix.patch
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

