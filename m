From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:41 -0700
Message-ID: <200904061937.n36JbfKj013035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757889AbZDFTjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: fix bugs related to module unload of the GRU driver
has been removed from the -mm tree.  Its filename was
     sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: fix bugs related to module unload of the GRU driver
From: Jack Steiner <steiner@sgi.com>

Fix bugs related to module unload of the GRU driver.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c      |    5 ++++-
 drivers/misc/sgi-gru/grukservices.c |   19 +++++++++++++++++++
 drivers/misc/sgi-gru/grutables.h    |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grufile.c~sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -440,7 +440,7 @@ exit1:
 
 static void __exit gru_exit(void)
 {
-	int i, bid;
+	int i, bid, gid;
 	int order = get_order(sizeof(struct gru_state) *
 			      GRU_CHIPLETS_PER_BLADE);
 
@@ -450,6 +450,9 @@ static void __exit gru_exit(void)
 	for (i = 0; i < GRU_CHIPLETS_PER_BLADE; i++)
 		free_irq(IRQ_GRU + i, NULL);
 
+	foreach_gid(gid)
+		gru_kservices_exit(GID_TO_GRU(gid));
+
 	for (bid = 0; bid < GRU_MAX_BLADES; bid++)
 		free_pages((unsigned long)gru_base[bid], order);
 
diff -puN drivers/misc/sgi-gru/grukservices.c~sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -690,3 +690,22 @@ int gru_kservices_init(struct gru_state 
 		quicktest(gru);
 	return 0;
 }
+
+void gru_kservices_exit(struct gru_state *gru)
+{
+	struct gru_context_configuration_handle *cch;
+	struct gru_blade_state *bs;
+
+	bs = gru->gs_blade;
+	if (gru != &bs->bs_grus[1])
+		return;
+
+	cch = get_cch(gru->gs_gru_base_vaddr, KERNEL_CTXNUM);
+	lock_cch_handle(cch);
+	if (cch_interrupt_sync(cch))
+		BUG();
+	if (cch_deallocate(cch))
+		BUG();
+	unlock_cch_handle(cch);
+}
+
diff -puN drivers/misc/sgi-gru/grutables.h~sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -600,6 +600,7 @@ extern void gru_unload_context(struct gr
 extern void gts_drop(struct gru_thread_state *gts);
 extern void gru_tgh_flush_init(struct gru_state *gru);
 extern int gru_kservices_init(struct gru_state *gru);
+extern void gru_kservices_exit(struct gru_state *gru);
 extern irqreturn_t gru_intr(int irq, void *dev_id);
 extern int gru_handle_user_call_os(unsigned long address);
 extern int gru_user_flush_tlb(unsigned long arg);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

