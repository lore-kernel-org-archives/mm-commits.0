From: akpm@linux-foundation.org
Subject: [merged] elv_iosched_store-fix-strstrip-misuse.patch removed from -mm tree
Date: Mon, 12 Oct 2009 14:21:25 -0700
Message-ID: <200910122121.n9CLLPV5031024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758099AbZJLVWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 17:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, jens.axboe@oracle.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     elv_iosched_store(): fix strstrip() misuse
has been removed from the -mm tree.  Its filename was
     elv_iosched_store-fix-strstrip-misuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elv_iosched_store(): fix strstrip() misuse
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

elv_iosched_store() ignore the return value of strstrip().  It makes small
inconsistent behavior.

This patch fixes it.

 <before>
 ====================================
 # cd /sys/block/{blockdev}/queue

 case1:
 # echo "anticipatory" > scheduler
 # cat scheduler
 noop [anticipatory] deadline cfq

 case2:
 # echo "anticipatory " > scheduler
 # cat scheduler
 noop [anticipatory] deadline cfq

 case3:
 # echo " anticipatory" > scheduler
 bash: echo: write error: Invalid argument

 <after>
 ====================================
 # cd /sys/block/{blockdev}/queue

 case1:
 # echo "anticipatory" > scheduler
 # cat scheduler
 noop [anticipatory] deadline cfq

 case2:
 # echo "anticipatory " > scheduler
 # cat scheduler
 noop [anticipatory] deadline cfq

 case3:
 # echo " anticipatory" > scheduler
 noop [anticipatory] deadline cfq

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN block/elevator.c~elv_iosched_store-fix-strstrip-misuse block/elevator.c
--- a/block/elevator.c~elv_iosched_store-fix-strstrip-misuse
+++ a/block/elevator.c
@@ -1053,9 +1053,7 @@ ssize_t elv_iosched_store(struct request
 		return count;
 
 	strlcpy(elevator_name, name, sizeof(elevator_name));
-	strstrip(elevator_name);
