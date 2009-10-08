From: akpm@linux-foundation.org
Subject: + elv_iosched_store-fix-strstrip-misuse.patch added to -mm tree
Date: Thu, 08 Oct 2009 16:04:43 -0700
Message-ID: <200910082304.n98N4ijk015821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757346AbZJHXG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 19:06:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, jens.axboe@oracle.com, lizf@cn.fujitsu.com


The patch titled
     elv_iosched_store(): fix strstrip() misuse
has been added to the -mm tree.  Its filename is
     elv_iosched_store-fix-strstrip-misuse.patch

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
