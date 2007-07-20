From: akpm@linux-foundation.org
Subject: - write-only-stuff-in-cfq-data-structures.patch removed from -mm tree
Date: Thu, 19 Jul 2007 22:58:55 -0700
Message-ID: <200707200558.l6K5wtpH010334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196AbXGTGFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Write-only stuff in CFQ data structures
has been removed from the -mm tree.  Its filename was
     write-only-stuff-in-cfq-data-structures.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: Write-only stuff in CFQ data structures
From: Alexey Dobriyan <adobriyan@sw.ru>

There are some write-only fields in cfq_data and cfq_queue.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |   11 -----------
 1 files changed, 11 deletions(-)

diff -puN block/cfq-iosched.c~write-only-stuff-in-cfq-data-structures block/cfq-iosched.c
--- a/block/cfq-iosched.c~write-only-stuff-in-cfq-data-structures
+++ a/block/cfq-iosched.c
@@ -111,9 +111,6 @@ struct cfq_data {
 	unsigned int cfq_slice_idle;
 
 	struct list_head cic_list;
-
-	sector_t new_seek_mean;
-	u64 new_seek_total;
 };
 
 /*
@@ -153,8 +150,6 @@ struct cfq_queue {
 
 	/* various state flags, see below */
 	unsigned int flags;
-
-	sector_t last_request_pos;
 };
 
 enum cfqq_state_flags {
@@ -1597,11 +1592,6 @@ cfq_update_io_seektime(struct cfq_data *
 	else
 		sdist = cic->last_request_pos - rq->sector;
 
-	if (!cic->seek_samples) {
-		cfqd->new_seek_total = (7*cic->seek_total + (u64)256*sdist) / 8;
-		cfqd->new_seek_mean = cfqd->new_seek_total / 256;
-	}
-
 	/*
 	 * Don't allow the seek distance to get too large from the
 	 * odd fragment, pagein, etc
@@ -1737,7 +1727,6 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 	cfq_update_idle_window(cfqd, cfqq, cic);
 
 	cic->last_request_pos = rq->sector + rq->nr_sectors;
-	cfqq->last_request_pos = cic->last_request_pos;
 
 	if (cfqq == cfqd->active_queue) {
 		/*
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
consolidate-ptrace_detach.patch
git-dvb.patch
write-only-stuff-in-cfq-data-structures.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
