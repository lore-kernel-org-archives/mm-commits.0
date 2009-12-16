From: akpm@linux-foundation.org
Subject: [merged] gru-update-gru-structures-to-match-latest-hardware-spec.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:02 -0800
Message-ID: <200912162041.nBGKf2ki013698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965029AbZLPUlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: update GRU structures to match latest hardware spec
has been removed from the -mm tree.  Its filename was
     gru-update-gru-structures-to-match-latest-hardware-spec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: update GRU structures to match latest hardware spec
From: Jack Steiner <steiner@sgi.com>

Add a few new definitions for chipset MMR field names.  This matches rev
0.7 of the hardware spec.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |    5 ++++-
 drivers/misc/sgi-gru/gruhandles.h       |   11 +++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~gru-update-gru-structures-to-match-latest-hardware-spec drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~gru-update-gru-structures-to-match-latest-hardware-spec
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -265,6 +265,7 @@ struct gru_instruction {
 #define CBE_CAUSE_PROTOCOL_STATE_DATA_ERROR	(1 << 16)
 #define CBE_CAUSE_RA_RESPONSE_DATA_ERROR	(1 << 17)
 #define CBE_CAUSE_HA_RESPONSE_DATA_ERROR	(1 << 18)
+#define CBE_CAUSE_FORCED_ERROR			(1 << 19)
 
 /* CBE cbrexecstatus bits */
 #define CBR_EXS_ABORT_OCC_BIT			0
@@ -273,13 +274,15 @@ struct gru_instruction {
 #define CBR_EXS_QUEUED_BIT			3
 #define CBR_EXS_TLB_INVAL_BIT			4
 #define CBR_EXS_EXCEPTION_BIT			5
+#define CBR_EXS_CB_INT_PENDING_BIT		6
 
 #define CBR_EXS_ABORT_OCC			(1 << CBR_EXS_ABORT_OCC_BIT)
 #define CBR_EXS_INT_OCC				(1 << CBR_EXS_INT_OCC_BIT)
 #define CBR_EXS_PENDING				(1 << CBR_EXS_PENDING_BIT)
 #define CBR_EXS_QUEUED				(1 << CBR_EXS_QUEUED_BIT)
-#define CBR_TLB_INVAL				(1 << CBR_EXS_TLB_INVAL_BIT)
+#define CBR_EXS_TLB_INVAL			(1 << CBR_EXS_TLB_INVAL_BIT)
 #define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
+#define CBR_EXS_CB_INT_PENDING			(1 << CBR_EXS_CB_INT_PENDING_BIT)
 
 /*
  * Exceptions are retried for the following cases. If any OTHER bits are set
diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-update-gru-structures-to-match-latest-hardware-spec drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-update-gru-structures-to-match-latest-hardware-spec
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -252,6 +252,17 @@ enum gru_tgh_state {
 	TGHSTATE_RESTART_CTX,
 };
 
+enum gru_tgh_cause {
+	TGHCAUSE_RR_ECC,
+	TGHCAUSE_TLB_ECC,
+	TGHCAUSE_LRU_ECC,
+	TGHCAUSE_PS_ECC,
+	TGHCAUSE_MUL_ERR,
+	TGHCAUSE_DATA_ERR,
+	TGHCAUSE_SW_FORCE
+};
+
+
 /*
  * TFH - TLB Global Handle
  * 	Used for TLB dropins into the GRU TLB.
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

