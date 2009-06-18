From: akpm@linux-foundation.org
Subject: [merged] gru-add-user-request-to-explicitly-unload-a-gru-context.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:56 -0700
Message-ID: <200906182248.n5IMmu0N007983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350AbZFRWz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: add user request to explicitly unload a gru context
has been removed from the -mm tree.  Its filename was
     gru-add-user-request-to-explicitly-unload-a-gru-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: add user request to explicitly unload a gru context
From: Jack Steiner <steiner@sgi.com>

Add user function to explicitly unload GRU kernel contexts from the GRU. 
Only contexts that are not in-use will be unloaded.

This function is primarily for testing.  It is not expected that this will
be used in normal production systems.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c      |   10 +---
 drivers/misc/sgi-gru/grukservices.c |   55 ++++++++++++++++----------
 drivers/misc/sgi-gru/grutables.h    |    4 -
 3 files changed, 41 insertions(+), 28 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~gru-add-user-request-to-explicitly-unload-a-gru-context drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-add-user-request-to-explicitly-unload-a-gru-context
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -287,7 +287,6 @@ static void gru_init_chiplet(struct gru_
 	gru_dbg(grudev, "bid %d, nid %d, gid %d, vaddr %p (0x%lx)\n",
 		bid, nid, gru->gs_gid, gru->gs_gru_base_vaddr,
 		gru->gs_gru_base_paddr);
-	gru_kservices_init(gru);
 }
 
 static int gru_init_tables(unsigned long gru_base_paddr, void *gru_base_vaddr)
@@ -314,6 +313,7 @@ static int gru_init_tables(unsigned long
 		memset(gru_base[bid], 0, sizeof(struct gru_blade_state));
 		gru_base[bid]->bs_lru_gru = &gru_base[bid]->bs_grus[0];
 		spin_lock_init(&gru_base[bid]->bs_lock);
+		init_rwsem(&gru_base[bid]->bs_kgts_sema);
 
 		dsrbytes = 0;
 		cbrs = 0;
@@ -426,6 +426,7 @@ static int __init gru_init(void)
 		printk(KERN_ERR "%s: init tables failed\n", GRU_DRIVER_ID_STR);
 		goto exit3;
 	}
+	gru_kservices_init();
 
 	printk(KERN_INFO "%s: v%s\n", GRU_DRIVER_ID_STR,
 	       GRU_DRIVER_VERSION_STR);
@@ -444,7 +445,7 @@ exit1:
 
 static void __exit gru_exit(void)
 {
-	int i, bid, gid;
+	int i, bid;
 	int order = get_order(sizeof(struct gru_state) *
 			      GRU_CHIPLETS_PER_BLADE);
 
@@ -453,10 +454,7 @@ static void __exit gru_exit(void)
 
 	for (i = 0; i < GRU_CHIPLETS_PER_BLADE; i++)
 		free_irq(IRQ_GRU + i, NULL);
-
-	foreach_gid(gid)
-		gru_kservices_exit(GID_TO_GRU(gid));
-
+	gru_kservices_exit();
 	for (bid = 0; bid < GRU_MAX_BLADES; bid++)
 		free_pages((unsigned long)gru_base[bid], order);
 
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-add-user-request-to-explicitly-unload-a-gru-context drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-add-user-request-to-explicitly-unload-a-gru-context
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -188,6 +188,34 @@ static void gru_load_kernel_context(stru
 }
 
 /*
+ * Free all kernel contexts that are not currently in use.
+ *   Returns 0 if all freed, else number of inuse context.
+ */
+static int gru_free_kernel_contexts(void)
+{
+	struct gru_blade_state *bs;
+	struct gru_thread_state *kgts;
+	int bid, ret = 0;
+
+	for (bid = 0; bid < GRU_MAX_BLADES; bid++) {
+		bs = gru_base[bid];
+		if (!bs)
+			continue;
+		if (down_write_trylock(&bs->bs_kgts_sema)) {
+			kgts = bs->bs_kgts;
+			if (kgts && kgts->ts_gru)
+				gru_unload_context(kgts, 0);
+			kfree(kgts);
+			bs->bs_kgts = NULL;
+			up_write(&bs->bs_kgts_sema);
+		} else {
+			ret++;
+		}
+	}
+	return ret;
+}
+
+/*
  * Lock & load the kernel context for the specified blade.
  */
 static struct gru_blade_state *gru_lock_kernel_context(int blade_id)
@@ -1009,35 +1037,22 @@ int gru_ktest(unsigned long arg)
 	case 2:
 		ret = quicktest2(arg);
 		break;
+	case 99:
+		ret = gru_free_kernel_contexts();
+		break;
 	}
 	return ret;
 
 }
 
-int gru_kservices_init(struct gru_state *gru)
+int gru_kservices_init(void)
 {
-	struct gru_blade_state *bs;
-
-	bs = gru->gs_blade;
-	if (gru != &bs->bs_grus[0])
-		return 0;
-
-	init_rwsem(&bs->bs_kgts_sema);
 	return 0;
 }
 
-void gru_kservices_exit(struct gru_state *gru)
+void gru_kservices_exit(void)
 {
-	struct gru_blade_state *bs;
-	struct gru_thread_state *kgts;
-
-	bs = gru->gs_blade;
-	if (gru != &bs->bs_grus[0])
-		return;
-
-	kgts = bs->bs_kgts;
-	if (kgts && kgts->ts_gru)
-		gru_unload_context(kgts, 0);
-	kfree(kgts);
+	if (gru_free_kernel_contexts())
+		BUG();
 }
 
diff -puN drivers/misc/sgi-gru/grutables.h~gru-add-user-request-to-explicitly-unload-a-gru-context drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-add-user-request-to-explicitly-unload-a-gru-context
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -638,8 +638,8 @@ extern void gru_unload_context(struct gr
 extern int gru_update_cch(struct gru_thread_state *gts, int force_unload);
 extern void gts_drop(struct gru_thread_state *gts);
 extern void gru_tgh_flush_init(struct gru_state *gru);
-extern int gru_kservices_init(struct gru_state *gru);
-extern void gru_kservices_exit(struct gru_state *gru);
+extern int gru_kservices_init(void);
+extern void gru_kservices_exit(void);
 extern int gru_dump_chiplet_request(unsigned long arg);
 extern irqreturn_t gru_intr(int irq, void *dev_id);
 extern int gru_handle_user_call_os(unsigned long address);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

