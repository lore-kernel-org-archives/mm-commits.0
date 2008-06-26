From: akpm@linux-foundation.org
Subject: + mlock-mlocked-pages-are-unevictable-fix-4.patch added to -mm tree
Date: Thu, 26 Jun 2008 14:24:26 -0700
Message-ID: <200806262124.m5QLOQV8018799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbYFZVYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jun 2008 17:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     mlock-mlocked-pages-are-unevictable-fix-4
has been added to the -mm tree.  Its filename is
     mlock-mlocked-pages-are-unevictable-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock-mlocked-pages-are-unevictable-fix-4
From: Hugh Dickins <hugh@veritas.com>

I trust you put Linus on unpaid leave for this week, for his poor
judgement in chucking that horrid patch from Russ into 2.6.26.

You may do best just to revert it (I don't even like the result myself)
and then omit the fixups it has demanded; but if you're sticking by
it, then I'm afraid it's still not right - the screen floods with
bad page state messages at startup, because you put PG_swapbacked
into PAGE_FLAGS, you naive man: did you think it's a page flag???
No, it's a PAGE_FLAGS_CLEAR_WHEN_BAD and a PAGE_FLAGS_CHECK_AT_PREP.

Here's a fix to the final result, to
mlock-mlocked-pages-are-unevictable-fix-3.patch
but of course that leaves breakage amidst the earlier ones:
if I were really conscientious I'd supply you with little patches
to the intervening stages too, but I'm tired, and I think you'll find
it a lot easier to do yourself than fiddle around with bits from me.

With this and those build fixes, I do have mmotm running on i386 and
x86_64 and powerpc (I folded in Kosaki's 10/10 and Balbir's 1-5).
I've several little -rc5-mm3/mmotm fixes for you, mainly related to
tmpfs and memcgroups, but never quite get to assemble them, and
most people seem to be managing without them.  Tomorrow...

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~mlock-mlocked-pages-are-unevictable-fix-4 include/linux/page-flags.h
--- a/include/linux/page-flags.h~mlock-mlocked-pages-are-unevictable-fix-4
+++ a/include/linux/page-flags.h
@@ -378,13 +378,14 @@ static inline void __ClearPageTail(struc
 #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
 			 1 << PG_buddy | 1 << PG_writeback | \
 			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
-			 1 << PG_swapbacked | __PG_UNEVICTABLE | __PG_MLOCKED)
+			 __PG_UNEVICTABLE | __PG_MLOCKED)
 
 /*
  * Flags checked in bad_page().  Pages on the free list should not have
  * these flags set.  It they are, there is a problem.
  */
-#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
+#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | \
+		1 << PG_reclaim | 1 << PG_dirty | 1 << PG_swapbacked)
 
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
@@ -397,7 +398,8 @@ static inline void __ClearPageTail(struc
  * Pages being prepped should not have these flags set.  It they are, there
  * is a problem.
  */
-#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
+#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
+		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
 
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-dirty-page-accounting-vs-vm_mixedmap.patch
git-unionfs.patch
mm-remove-nopfn-fix.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-improve-error-handling.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
prio_tree-debugging-patch.patch

