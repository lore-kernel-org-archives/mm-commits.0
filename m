From: akpm@linux-foundation.org
Subject: + congestion_wait-dont-use-write.patch added to -mm tree
Date: Thu, 08 Oct 2009 15:59:55 -0700
Message-ID: <200910082259.n98MxtB1005787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736AbZJHXB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 19:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, jens.axboe@oracle.com


The patch titled
     congestion_wait(): don't use WRITE
has been added to the -mm tree.  Its filename is
     congestion_wait-dont-use-write.patch

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
Subject: congestion_wait(): don't use WRITE
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 8aa7e847d (Fix congestion_wait() sync/async vs read/write
confusion) replace WRITE with BLK_RW_ASYNC.  Unfortunately, concurrent mm
development made the unchanged place accidentally.

This patch fixes it too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/vmscan.c~congestion_wait-dont-use-write mm/vmscan.c
--- a/mm/vmscan.c~congestion_wait-dont-use-write
+++ a/mm/vmscan.c
@@ -1088,7 +1088,7 @@ static unsigned long shrink_inactive_lis
 	int lumpy_reclaim = 0;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
-		congestion_wait(WRITE, HZ/10);
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
congestion_wait-dont-use-write.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

