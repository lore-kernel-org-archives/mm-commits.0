From: akpm@linux-foundation.org
Subject: [merged] gru-improve-messages-for-malfunctioning-grus.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:27 -0800
Message-ID: <200912162040.nBGKeRph013642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935430AbZLPUka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: improve messages for malfunctioning GRUs
has been removed from the -mm tree.  Its filename was
     gru-improve-messages-for-malfunctioning-grus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: improve messages for malfunctioning GRUs
From: Jack Steiner <steiner@sgi.com>

Improve error messages for malfunctioning GRUs.  Identify the type of
instruction that is failing.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruhandles.c |   22 +++++++++++++++++++---
 drivers/misc/sgi-gru/gruhandles.h |    6 ++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff -puN drivers/misc/sgi-gru/gruhandles.c~gru-improve-messages-for-malfunctioning-grus drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~gru-improve-messages-for-malfunctioning-grus
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -54,6 +54,21 @@ static void start_instruction(void *h)
 	gru_flush_cache(h);
 }
 
+static void report_instruction_timeout(void *h)
+{
+	unsigned long goff = GSEGPOFF((unsigned long)h);
+	char *id = "???";
+
+	if (TYPE_IS(CCH, goff))
+		id = "CCH";
+	else if (TYPE_IS(TGH, goff))
+		id = "TGH";
+	else if (TYPE_IS(TFH, goff))
+		id = "TFH";
+
+	panic(KERN_ALERT "GRU %p (%s) is malfunctioning\n", h, id);
+}
+
 static int wait_instruction_complete(void *h, enum mcs_op opc)
 {
 	int status;
@@ -64,9 +79,10 @@ static int wait_instruction_complete(voi
 		status = GET_MSEG_HANDLE_STATUS(h);
 		if (status != CCHSTATUS_ACTIVE)
 			break;
-		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time))
-			panic("GRU %p is malfunctioning: start %ld, end %ld\n",
-			      h, start_time, (unsigned long)get_cycles());
+		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time)) {
+			report_instruction_timeout(h);
+			start_time = get_cycles();
+		}
 	}
 	if (gru_options & OPT_STATS)
 		update_mcs_stats(opc, get_cycles() - start_time);
diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-improve-messages-for-malfunctioning-grus drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-improve-messages-for-malfunctioning-grus
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -91,6 +91,12 @@
 /* Convert an arbitrary handle address to the beginning of the GRU segment */
 #define GRUBASE(h)		((void *)((unsigned long)(h) & ~(GRU_SIZE - 1)))
 
+/* Test a valid handle address to determine the type */
+#define TYPE_IS(hn, h)		((h) >= GRU_##hn##_BASE && (h) <	\
+		GRU_##hn##_BASE + GRU_NUM_##hn * GRU_HANDLE_STRIDE &&   \
+		(((h) & (GRU_HANDLE_STRIDE - 1)) == 0))
+
+
 /* General addressing macros. */
 static inline void *get_gseg_base_address(void *base, int ctxnum)
 {
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

