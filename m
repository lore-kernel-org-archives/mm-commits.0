From: akpm@linux-foundation.org
Subject: + cfq-fix-ioprio_class_idle-accounting.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:37:35 -0800
Message-ID: <200711060037.lA60bZH8027827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbXKFAiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:38:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, gentuu@gmail.com


The patch titled
     cfq: fix IOPRIO_CLASS_IDLE accounting
has been added to the -mm tree.  Its filename is
     cfq-fix-ioprio_class_idle-accounting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cfq: fix IOPRIO_CLASS_IDLE accounting
From: Oleg Nesterov <oleg@tv-sign.ru>

Spotted by Nick <gentuu@gmail.com>, hopefully can explain the second trace
in http://bugzilla.kernel.org/show_bug.cgi?id=9180.

If ->async_idle_cfqq != NULL cfq_put_async_queues() puts it IOPRIO_BE_NR
times in a loop.  Fix this.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN block/cfq-iosched.c~cfq-fix-ioprio_class_idle-accounting block/cfq-iosched.c
--- a/block/cfq-iosched.c~cfq-fix-ioprio_class_idle-accounting
+++ a/block/cfq-iosched.c
@@ -2068,9 +2068,10 @@ static void cfq_put_async_queues(struct 
 			cfq_put_queue(cfqd->async_cfqq[0][i]);
 		if (cfqd->async_cfqq[1][i])
 			cfq_put_queue(cfqd->async_cfqq[1][i]);
-		if (cfqd->async_idle_cfqq)
-			cfq_put_queue(cfqd->async_idle_cfqq);
 	}
+
+	if (cfqd->async_idle_cfqq)
+		cfq_put_queue(cfqd->async_idle_cfqq);
 }
 
 static void cfq_exit_queue(elevator_t *e)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
cfq-fix-ioprio_class_idle-accounting.patch
add-task_wakekill.patch
