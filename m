From: akpm@linux-foundation.org
Subject: [merged]
 mm-writeback-flush-plugged-io-in-wakeup_flusher_threads.patch removed from
 -mm tree
Date: Mon, 15 Aug 2016 13:40:40 -0700
Message-ID: <57b228c8.s/lXK91MNKvvEYOx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbcHOUkl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 16:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, axboe@kernel.dk, dchinner@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, writeback: flush plugged IO in wakeup_flusher_threads()
has been removed from the -mm tree.  Its filename was
     mm-writeback-flush-plugged-io-in-wakeup_flusher_threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm, writeback: flush plugged IO in wakeup_flusher_threads()

I've found funny livelock between raid10 barriers during resync and memory
controller hard limits.  Inside mpage_readpages() task holds on its plug
bio which blocks barrier in raid10.  Its memory cgroup have no free memory
thus task goes into reclaimer but all reclaimable pages are dirty and
cannot be written because raid10 is rebuilding and stuck on barrier.

Common flush of such IO in schedule() never happens because machine where
that happened has a lot of free cpus and task never goes sleep.

Lock is 'live' because changing memory limit or killing tasks which holds
that stuck bio unblock whole progress.

That was happened in 3.18.x but I see no difference in upstream logic.
Theoretically this might happen even without memory cgroup.

Link: http://lkml.kernel.org/r/147033576532.682609.2277943215598867297.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/fs-writeback.c~mm-writeback-flush-plugged-io-in-wakeup_flusher_threads fs/fs-writeback.c
--- a/fs/fs-writeback.c~mm-writeback-flush-plugged-io-in-wakeup_flusher_threads
+++ a/fs/fs-writeback.c
@@ -1949,6 +1949,12 @@ void wakeup_flusher_threads(long nr_page
 {
 	struct backing_dev_info *bdi;
 
+	/*
+	 * If we are expecting writeback progress we must submit plugged IO.
+	 */
+	if (blk_needs_flush_plug(current))
+		blk_schedule_flush_plug(current);
+
 	if (!nr_pages)
 		nr_pages = get_nr_dirty_pages();
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-use-nmi-registers-snapshot-in-hardlockup-handler.patch

