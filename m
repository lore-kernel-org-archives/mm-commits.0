From: akpm@linux-foundation.org
Subject: [merged] gru-fix-cache-coherency-issues-with-instruction-retry.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:54 -0700
Message-ID: <200906182248.n5IMmsCI007980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162AbZFRWtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: fix cache coherency issues with instruction retry
has been removed from the -mm tree.  Its filename was
     gru-fix-cache-coherency-issues-with-instruction-retry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fix cache coherency issues with instruction retry
From: Jack Steiner <steiner@sgi.com>

Fix two problems related to GRU instruction failures.  Cache coherency is
not maintained for CBEs except when loading or unloading contexts.  When
reading a CBE to extract error information, the CBE must first be flushed
from the cache.

The function that reads kerrnel CBEs was reading the wrong CBE.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c     |    3 ++-
 drivers/misc/sgi-gru/grufile.c      |    2 +-
 drivers/misc/sgi-gru/grukservices.c |   12 ++++++++++--
 drivers/misc/sgi-gru/grutables.h    |    1 +
 4 files changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-fix-cache-coherency-issues-with-instruction-retry drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-fix-cache-coherency-issues-with-instruction-retry
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -614,7 +614,7 @@ int gru_get_exception_detail(unsigned lo
 	} else if (gts->ts_gru) {
 		cbrnum = thread_cbr_number(gts, ucbnum);
 		cbe = get_cbe_by_index(gts->ts_gru, cbrnum);
-		prefetchw(cbe);/* Harmless on hardware, required for emulator */
+		gru_flush_cache(cbe);	/* CBE not coherent */
 		excdet.opc = cbe->opccpy;
 		excdet.exopc = cbe->exopccpy;
 		excdet.ecause = cbe->ecause;
@@ -622,6 +622,7 @@ int gru_get_exception_detail(unsigned lo
 		excdet.exceptdet1 = cbe->idef3upd;
 		excdet.cbrstate = cbe->cbrstate;
 		excdet.cbrexecstatus = cbe->cbrexecstatus;
+		gru_flush_cache(cbe);
 		ret = 0;
 	} else {
 		ret = -EAGAIN;
diff -puN drivers/misc/sgi-gru/grufile.c~gru-fix-cache-coherency-issues-with-instruction-retry drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-fix-cache-coherency-issues-with-instruction-retry
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -46,6 +46,7 @@
 
 struct gru_blade_state *gru_base[GRU_MAX_BLADES] __read_mostly;
 unsigned long gru_start_paddr __read_mostly;
+void *gru_start_vaddr __read_mostly;
 unsigned long gru_end_paddr __read_mostly;
 unsigned int gru_max_gids __read_mostly;
 struct gru_stats_s gru_stats;
@@ -376,7 +377,6 @@ static int __init gru_init(void)
 {
 	int ret, irq, chip;
 	char id[10];
-	void *gru_start_vaddr;
 
 	if (!is_uv_system())
 		return 0;
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-fix-cache-coherency-issues-with-instruction-retry drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-fix-cache-coherency-issues-with-instruction-retry
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -98,6 +98,9 @@
 #define ASYNC_HAN_TO_BID(h)	((h) - 1)
 #define ASYNC_BID_TO_HAN(b)	((b) + 1)
 #define ASYNC_HAN_TO_BS(h)	gru_base[ASYNC_HAN_TO_BID(h)]
+#define KCB_TO_GID(cb)		((cb - gru_start_vaddr) /		\
+					(GRU_SIZE * GRU_CHIPLETS_PER_BLADE))
+#define KCB_TO_BS(cb)		gru_base[KCB_TO_GID(cb)]
 
 #define GRU_NUM_KERNEL_CBR	1
 #define GRU_NUM_KERNEL_DSR_BYTES 256
@@ -354,14 +357,19 @@ int gru_get_cb_exception_detail(void *cb
 		struct control_block_extended_exc_detail *excdet)
 {
 	struct gru_control_block_extended *cbe;
+	struct gru_blade_state *bs;
+	int cbrnum;
 
-	cbe = get_cbe(GRUBASE(cb), get_cb_number(cb));
-	prefetchw(cbe);	/* Harmless on hardware, required for emulator */
+	bs = KCB_TO_BS(cb);
+	cbrnum = thread_cbr_number(bs->bs_kgts, get_cb_number(cb));
+	cbe = get_cbe(GRUBASE(cb), cbrnum);
+	gru_flush_cache(cbe);	/* CBE not coherent */
 	excdet->opc = cbe->opccpy;
 	excdet->exopc = cbe->exopccpy;
 	excdet->ecause = cbe->ecause;
 	excdet->exceptdet0 = cbe->idef1upd;
 	excdet->exceptdet1 = cbe->idef3upd;
+	gru_flush_cache(cbe);
 	return 0;
 }
 
diff -puN drivers/misc/sgi-gru/grutables.h~gru-fix-cache-coherency-issues-with-instruction-retry drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-fix-cache-coherency-issues-with-instruction-retry
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -153,6 +153,7 @@
 extern struct gru_stats_s gru_stats;
 extern struct gru_blade_state *gru_base[];
 extern unsigned long gru_start_paddr, gru_end_paddr;
+extern void *gru_start_vaddr;
 extern unsigned int gru_max_gids;
 
 #define GRU_MAX_BLADES		MAX_NUMNODES
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

