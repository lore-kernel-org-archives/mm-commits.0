From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 16:23:29 -0700
Message-ID: <559f0271.6ydt/f6l5DDFzlCH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbbGIXXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 19:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, david@fromorbit.com, hannes@cmpxchg.org, hughd@google.com, kernel@kyup.com, mm@1h.com, stable@vger.kernel.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: do not wait for page writeback for GFP_NOFS allocations
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm, vmscan: do not wait for page writeback for GFP_NOFS allocations

Nikolay has reported a hang when a memcg reclaim got stuck with the
following backtrace:
PID: 18308  TASK: ffff883d7c9b0a30  CPU: 1   COMMAND: "rsync"
 #0 [ffff88177374ac60] __schedule at ffffffff815ab152
 #1 [ffff88177374acb0] schedule at ffffffff815ab76e
 #2 [ffff88177374acd0] schedule_timeout at ffffffff815ae5e5
 #3 [ffff88177374ad70] io_schedule_timeout at ffffffff815aad6a
 #4 [ffff88177374ada0] bit_wait_io at ffffffff815abfc6
 #5 [ffff88177374adb0] __wait_on_bit at ffffffff815abda5
 #6 [ffff88177374ae00] wait_on_page_bit at ffffffff8111fd4f
 #7 [ffff88177374ae50] shrink_page_list at ffffffff81135445
 #8 [ffff88177374af50] shrink_inactive_list at ffffffff81135845
 #9 [ffff88177374b060] shrink_lruvec at ffffffff81135ead
 #10 [ffff88177374b150] shrink_zone at ffffffff811360c3
 #11 [ffff88177374b220] shrink_zones at ffffffff81136eff
 #12 [ffff88177374b2a0] do_try_to_free_pages at ffffffff8113712f
 #13 [ffff88177374b300] try_to_free_mem_cgroup_pages at ffffffff811372be
 #14 [ffff88177374b380] try_charge at ffffffff81189423
 #15 [ffff88177374b430] mem_cgroup_try_charge at ffffffff8118c6f5
 #16 [ffff88177374b470] __add_to_page_cache_locked at ffffffff8112137d
 #17 [ffff88177374b4e0] add_to_page_cache_lru at ffffffff81121618
 #18 [ffff88177374b510] pagecache_get_page at ffffffff8112170b
 #19 [ffff88177374b560] grow_dev_page at ffffffff811c8297
 #20 [ffff88177374b5c0] __getblk_slow at ffffffff811c91d6
 #21 [ffff88177374b600] __getblk_gfp at ffffffff811c92c1
 #22 [ffff88177374b630] ext4_ext_grow_indepth at ffffffff8124565c
 #23 [ffff88177374b690] ext4_ext_create_new_leaf at ffffffff81246ca8
 #24 [ffff88177374b6e0] ext4_ext_insert_extent at ffffffff81246f09
 #25 [ffff88177374b750] ext4_ext_map_blocks at ffffffff8124a848
 #26 [ffff88177374b870] ext4_map_blocks at ffffffff8121a5b7
 #27 [ffff88177374b910] mpage_map_one_extent at ffffffff8121b1fa
 #28 [ffff88177374b950] mpage_map_and_submit_extent at ffffffff8121f07b
 #29 [ffff88177374b9b0] ext4_writepages at ffffffff8121f6d5
 #30 [ffff88177374bb20] do_writepages at ffffffff8112c490
 #31 [ffff88177374bb30] __filemap_fdatawrite_range at ffffffff81120199
 #32 [ffff88177374bb80] filemap_flush at ffffffff8112041c
 #33 [ffff88177374bb90] ext4_alloc_da_blocks at ffffffff81219da1
 #34 [ffff88177374bbb0] ext4_rename at ffffffff81229b91
 #35 [ffff88177374bcd0] ext4_rename2 at ffffffff81229e32
 #36 [ffff88177374bce0] vfs_rename at ffffffff811a08a5
 #37 [ffff88177374bd60] SYSC_renameat2 at ffffffff811a3ffc
 #38 [ffff88177374bf60] sys_renameat2 at ffffffff811a408e
 #39 [ffff88177374bf70] sys_rename at ffffffff8119e51e
 #40 [ffff88177374bf80] system_call_fastpath at ffffffff815afa89

Dave Chinner has properly pointed out that this is a deadlock in the
reclaim code because ext4 doesn't submit pages which are marked by
PG_writeback right away. The heuristic was introduced by e62e384e9da8
("memcg: prevent OOM with too many dirty pages") and it was applied
only when may_enter_fs was specified. The code has been changed by
c3b94f44fcb0 ("memcg: further prevent OOM with too many dirty pages")
which has removed the __GFP_FS restriction with a reasoning that we
do not get into the fs code. But this is not sufficient apparently
because the fs doesn't necessarily submit pages marked PG_writeback
for IO right away.

ext4_bio_write_page calls io_submit_add_bh but that doesn't necessarily
submit the bio. Instead it tries to map more pages into the bio and
mpage_map_one_extent might trigger memcg charge which might end up
waiting on a page which is marked PG_writeback but hasn't been submitted
yet so we would end up waiting for something that never finishes.

Fix this issue by replacing __GFP_IO by __GFP_FS check (for case 2)
before we go to wait on the writeback. The page fault path, which is the
only path that triggers memcg oom killer since 3.12, shouldn't require
GFP_NOFS and so we shouldn't reintroduce the premature OOM killer issue
which was originally addressed by the heuristic.

As per David Chinner the xfs is doing similar thing since 2.6.15 already
so ext4 is not the only affected filesystem. Moreover he notes:
: For example: IO completion might require unwritten extent conversion
: which executes filesystem transactions and GFP_NOFS allocations. The
: writeback flag on the pages can not be cleared until unwritten
: extent conversion completes. Hence memory reclaim cannot wait on
: page writeback to complete in GFP_NOFS context because it is not
: safe to do so, memcg reclaim or otherwise.

Fixes: c3b94f44fcb0 ("memcg: further prevent OOM with too many dirty pages")
[tytso@mit.edu: check for __GFP_FS rather than __GFP_IO]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Nikolay Borisov <kernel@kyup.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Marian Marinov <mm@1h.com>
Cc: Hugh Dickins <hughd@google.com
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations
+++ a/mm/vmscan.c
@@ -974,21 +974,17 @@ static unsigned long shrink_page_list(st
 		 *
 		 * 2) Global or new memcg reclaim encounters a page that is
 		 *    not marked for immediate reclaim or the caller does not
-		 *    have __GFP_IO. In this case mark the page for immediate
+		 *    have __GFP_FS. In this case mark the page for immediate
 		 *    reclaim and continue scanning.
 		 *
-		 *    __GFP_IO is checked  because a loop driver thread might
-		 *    enter reclaim, and deadlock if it waits on a page for
-		 *    which it is needed to do the write (loop masks off
+		 *    Require __GFP_FS even though we are not entering fs
+		 *    because we are waiting for a fs activity and we might
+		 *    be in the middle of the writeout. Moreover a loop driver
+		 *    might enter reclaim, and deadlock of it waits on a page
+		 *    for which it is needed to do the write (loop masks off
 		 *    __GFP_IO|__GFP_FS for this reason); but more thought
 		 *    would probably show more reasons.
 		 *
-		 *    Don't require __GFP_FS, since we're not going into the
-		 *    FS, just waiting on its writeback completion. Worryingly,
-		 *    ext4 gfs2 and xfs allocate pages with
-		 *    grab_cache_page_write_begin(,,AOP_FLAG_NOFS), so testing
-		 *    may_enter_fs here is liable to OOM on them.
-		 *
 		 * 3) Legacy memcg encounters a page that is not already marked
 		 *    PageReclaim. memcg does not have any dirty pages
 		 *    throttling so we could easily OOM just because too many
@@ -1005,7 +1001,7 @@ static unsigned long shrink_page_list(st
 
 			/* Case 2 above */
 			} else if (sane_reclaim(sc) ||
-			    !PageReclaim(page) || !(sc->gfp_mask & __GFP_IO)) {
+			    !PageReclaim(page) || !(sc->gfp_mask & __GFP_FS)) {
 				/*
 				 * This is slightly racy - end_page_writeback()
 				 * might have just cleared PageReclaim, then
@@ -1022,10 +1018,10 @@ static unsigned long shrink_page_list(st
 
 				goto keep_locked;
 
-			/* Case 3 above */
-			} else {
-				wait_on_page_writeback(page);
 			}
+
+			/* Case 3 above */
+			wait_on_page_writeback(page);
 		}
 
 		if (!force_reclaim)
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch

