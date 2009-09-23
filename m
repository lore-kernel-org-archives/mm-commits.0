From: akpm@linux-foundation.org
Subject: [merged] poll-select-avoid-arithmetic-overflow-in-__estimate_accuracy.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:09 -0700
Message-ID: <200909231952.n8NJq9Mv028532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZIWTyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gknispel@proformatique.com, arjan@infradead.org, heiko.carstens@de.ibm.com, tglx@linutronix.de, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     poll/select: avoid arithmetic overflow in __estimate_accuracy()
has been removed from the -mm tree.  Its filename was
     poll-select-avoid-arithmetic-overflow-in-__estimate_accuracy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: poll/select: avoid arithmetic overflow in __estimate_accuracy()
From: Guillaume Knispel <gknispel@proformatique.com>

__estimate_accuracy() was prone to integer overflow, for example if *tv ==
{2147, 483648000} on a 32 bit computer (or even for delays as small as
{429, 500000000} if the task is niced).

Because the result was already forced between 0 and 100ms, the effect of
the overflow was not too problematic, but the use of the hrtimer range
feature was not optimal in overflow cases.

This patch ensures that there can not be an integer overflow in this
function.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/select.c~poll-select-avoid-arithmetic-overflow-in-__estimate_accuracy fs/select.c
--- a/fs/select.c~poll-select-avoid-arithmetic-overflow-in-__estimate_accuracy
+++ a/fs/select.c
@@ -41,22 +41,28 @@
  * better solutions..
  */
 
+#define MAX_SLACK	(100 * NSEC_PER_MSEC)
+
 static long __estimate_accuracy(struct timespec *tv)
 {
 	long slack;
 	int divfactor = 1000;
 
+	if (tv->tv_sec < 0)
+		return 0;
+
 	if (task_nice(current) > 0)
 		divfactor = divfactor / 5;
 
+	if (tv->tv_sec > MAX_SLACK / (NSEC_PER_SEC/divfactor))
+		return MAX_SLACK;
+
 	slack = tv->tv_nsec / divfactor;
 	slack += tv->tv_sec * (NSEC_PER_SEC/divfactor);
 
-	if (slack > 100 * NSEC_PER_MSEC)
-		slack =  100 * NSEC_PER_MSEC;
+	if (slack > MAX_SLACK)
+		return MAX_SLACK;
 
-	if (slack < 0)
-		slack = 0;
 	return slack;
 }
 
_

Patches currently in -mm which might be from gknispel@proformatique.com are

origin.patch

