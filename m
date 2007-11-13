From: akpm@linux-foundation.org
Subject: - cfq-fix-ioprio_class_idle-accounting.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:28 -0800
Message-ID: <200711130407.lAD47RH5025231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760520AbXKMEHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:07:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, gentuu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cfq: fix IOPRIO_CLASS_IDLE accounting
has been removed from the -mm tree.  Its filename was
     cfq-fix-ioprio_class_idle-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
add-task_wakekill.patch
