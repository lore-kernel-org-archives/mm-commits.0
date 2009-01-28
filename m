From: akpm@linux-foundation.org
Subject: + sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:25:15 -0800
Message-ID: <200901280025.n0S0PFdk004998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbZA1AZY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:25:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     sgi-gru: fix bugs related to module unload of the GRU driver
has been added to the -mm tree.  Its filename is
     sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch

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
@@ -452,7 +452,7 @@ exit1:
 
 static void __exit gru_exit(void)
 {
-	int i, bid;
+	int i, bid, gid;
 	int order = get_order(sizeof(struct gru_state) *
 			      GRU_CHIPLETS_PER_BLADE);
 
@@ -462,6 +462,9 @@ static void __exit gru_exit(void)
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

sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch

