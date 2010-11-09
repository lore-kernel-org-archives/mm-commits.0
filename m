From: akpm@linux-foundation.org
Subject: + latencytop-fix-per-task-accumulator.patch added to -mm tree
Date: Mon, 08 Nov 2010 17:20:44 -0800
Message-ID: <201011090122.oA91MraC020749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556Ab0KIBXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 20:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, arjan@infradead.org, stable@kernel.org


The patch titled
     latencytop: fix per task accumulator
has been added to the -mm tree.  Its filename is
     latencytop-fix-per-task-accumulator.patch

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
Subject: latencytop: fix per task accumulator
From: Ken Chen <kenchen@google.com>

Per task latencytop accumulator prematurely terminates due to erroneous
placement of latency_record_count.  It should be incremented whenever a
new record is allocated instead of increment on every latencytop event.

Also fix search iterator to only search known record events instead of
blindly searching all pre-allocated space.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/latencytop.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN kernel/latencytop.c~latencytop-fix-per-task-accumulator kernel/latencytop.c
--- a/kernel/latencytop.c~latencytop-fix-per-task-accumulator
+++ a/kernel/latencytop.c
@@ -194,14 +194,7 @@ __account_scheduler_latency(struct task_
 
 	account_global_scheduler_latency(tsk, &lat);
 
-	/*
-	 * short term hack; if we're > 32 we stop; future we recycle:
-	 */
-	tsk->latency_record_count++;
-	if (tsk->latency_record_count >= LT_SAVECOUNT)
-		goto out_unlock;
-
-	for (i = 0; i < LT_SAVECOUNT; i++) {
+	for (i = 0; i < tsk->latency_record_count; i++) {
 		struct latency_record *mylat;
 		int same = 1;
 
@@ -227,8 +220,14 @@ __account_scheduler_latency(struct task_
 		}
 	}
 
+	/*
+	 * short term hack; if we're > 32 we stop; future we recycle:
+	 */
+	if (tsk->latency_record_count >= LT_SAVECOUNT)
+		goto out_unlock;
+
 	/* Allocated a new one: */
-	i = tsk->latency_record_count;
+	i = tsk->latency_record_count++;
 	memcpy(&tsk->latency_record[i], &lat, sizeof(struct latency_record));
 
 out_unlock:
_

Patches currently in -mm which might be from kenchen@google.com are

latencytop-fix-per-task-accumulator.patch

