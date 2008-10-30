From: akpm@linux-foundation.org
Subject: + elevatorc-prevent-flushing-small-requests-to-device.patch added to -mm tree
Date: Thu, 30 Oct 2008 14:20:19 -0700
Message-ID: <200810302120.m9ULKJci014110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634AbYJ3VUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 17:20:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikevs@xs4all.net, jens.axboe@oracle.com


The patch titled
     elevator.c: prevent flushing small requests to device
has been added to the -mm tree.  Its filename is
     elevatorc-prevent-flushing-small-requests-to-device.patch

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
Subject: elevator.c: prevent flushing small requests to device
From: Miquel van Smoorenburg <mikevs@xs4all.net>

While tracing I/O patterns with blktrace (a great tool) a few weeks ago I
identified a minor issue in elevator.c

When elv_insert() is called to insert a new request, and the device is
plugged, bit of code at the end of the function will unplug the device if
the number of pending requests >= q->unplug_thresh.

This means the current request is also sent to the device immidiately
while it is potentially mergeable with the next request.  This has been
observed when a lot of small sequential requests are made.

By unplugging the device before we add the new request to the
queue this can be prevented.

Signed-off-by: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/elevator.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN block/elevator.c~elevatorc-prevent-flushing-small-requests-to-device block/elevator.c
--- a/block/elevator.c~elevatorc-prevent-flushing-small-requests-to-device
+++ a/block/elevator.c
@@ -617,6 +617,20 @@ void elv_insert(struct request_queue *q,
 
 	case ELEVATOR_INSERT_SORT:
 		BUG_ON(!blk_fs_request(rq) && !blk_discard_rq(rq));
+		/*
+		 * If we're going to unplug the device, do it now before
+		 * we put a potentially small and mergeable new
+		 * request on the queue, instead of just after it.
+		 */
+		if (blk_queue_plugged(q)) {
+			int nrq = q->rq.count[READ] + q->rq.count[WRITE]
+				- q->in_flight;
+			if (nrq >= q->unplug_thresh)
+				__generic_unplug_device(q);
+			if (elv_queue_empty(q))
+				blk_plug_device(q);
+			unplug_it = 0;
+		}
 		rq->cmd_flags |= REQ_SORTED;
 		q->nr_sorted++;
 		if (rq_mergeable(rq)) {
_

Patches currently in -mm which might be from mikevs@xs4all.net are

elevatorc-prevent-flushing-small-requests-to-device.patch

