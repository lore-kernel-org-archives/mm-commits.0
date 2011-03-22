From: akpm@linux-foundation.org
Subject: [folded] epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:05:43 -0700
Message-ID: <201103222305.p2MN5i1L000570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725Ab1CVXLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davidel@xmailserver.org, shawn.bohrer@gmail.com, mm-commits@vger.kernel.org


The patch titled
     epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix
has been removed from the -mm tree.  Its filename was
     epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch

This patch was dropped because it was folded into epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix
From: Johannes Weiner <hannes@cmpxchg.org>

The non-blocking ep_poll path optimization introduced skipping over the
return value setup.

Initialize it properly, my userspace gets upset by epoll_wait() returning
random things.

In addition, remove the reinitialization at the fetch_events label, the
return value is garuanteed to be zero when execution reaches there.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix
+++ a/fs/eventpoll.c
@@ -1168,7 +1168,7 @@ static inline struct timespec ep_set_mst
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail, timed_out = 0;
+	int res = 0, eavail, timed_out = 0;
 	unsigned long flags;
 	long slack = 0;
 	wait_queue_t wait;
@@ -1193,7 +1193,6 @@ static int ep_poll(struct eventpoll *ep,
 fetch_events:
 	spin_lock_irqsave(&ep->lock, flags);
 
-	res = 0;
 	if (!ep_events_available(ep)) {
 		/*
 		 * We don't have any available event to return to the caller.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-simplify-code-of-swapc.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch

