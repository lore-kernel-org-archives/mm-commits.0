From: akpm@linux-foundation.org
Subject: [merged] gru-fix-bug-in-exception-handling.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:53 -0800
Message-ID: <200912162040.nBGKer6K013685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965021AbZLPUk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: fix bug in exception handling
has been removed from the -mm tree.  Its filename was
     gru-fix-bug-in-exception-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fix bug in exception handling
From: Jack Steiner <steiner@sgi.com>

Fix a GRU driver bug converting a CBR address to the context that contains
the CBR.  The conversion is rarely done so performance does not matter.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |   30 +++++++++++++++++++-------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-fix-bug-in-exception-handling drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-fix-bug-in-exception-handling
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -97,9 +97,6 @@
 #define ASYNC_HAN_TO_BID(h)	((h) - 1)
 #define ASYNC_BID_TO_HAN(b)	((b) + 1)
 #define ASYNC_HAN_TO_BS(h)	gru_base[ASYNC_HAN_TO_BID(h)]
-#define KCB_TO_GID(cb)		((cb - gru_start_vaddr) /		\
-					(GRU_SIZE * GRU_CHIPLETS_PER_BLADE))
-#define KCB_TO_BS(cb)		gru_base[KCB_TO_GID(cb)]
 
 #define GRU_NUM_KERNEL_CBR	1
 #define GRU_NUM_KERNEL_DSR_BYTES 256
@@ -388,11 +385,28 @@ int gru_get_cb_exception_detail(void *cb
 		struct control_block_extended_exc_detail *excdet)
 {
 	struct gru_control_block_extended *cbe;
-	struct gru_blade_state *bs;
-	int cbrnum;
-
-	bs = KCB_TO_BS(cb);
-	cbrnum = thread_cbr_number(bs->bs_kgts, get_cb_number(cb));
+	struct gru_thread_state *kgts = NULL;
+	unsigned long off;
+	int cbrnum, bid;
+
+	/*
+	 * Locate kgts for cb. This algorithm is SLOW but
+	 * this function is rarely called (ie., almost never).
+	 * Performance does not matter.
+	 */
+	for_each_possible_blade(bid) {
+		if (!gru_base[bid])
+			break;
+		kgts = gru_base[bid]->bs_kgts;
+		if (!kgts || !kgts->ts_gru)
+			continue;
+		off = cb - kgts->ts_gru->gs_gru_base_vaddr;
+		if (off < GRU_SIZE)
+			break;
+		kgts = NULL;
+	}
+	BUG_ON(!kgts);
+	cbrnum = thread_cbr_number(kgts, get_cb_number(cb));
 	cbe = get_cbe(GRUBASE(cb), cbrnum);
 	gru_flush_cache(cbe);	/* CBE not coherent */
 	sync_core();
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

