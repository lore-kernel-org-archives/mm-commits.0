From: akpm@linux-foundation.org
Subject: - intel-agp-rewrite-gtt-on-resume-update.patch removed from -mm tree
Date: Mon, 09 Jun 2008 16:23:16 -0700
Message-ID: <200806092323.m59NNGHF014075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbYFIXYE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 19:24:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keithp@keithp.com, airlied@linux.ie, andi@firstfloor.org, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     intel-agp-rewrite-gtt-on-resume update
has been removed from the -mm tree.  Its filename was
     intel-agp-rewrite-gtt-on-resume-update.patch

This patch was dropped because it was folded into intel-agp-rewrite-gtt-on-resume.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-agp-rewrite-gtt-on-resume update
From: Keith Packard <keithp@keithp.com>

This version adds a spinlock around all of the mapped_list manipulation.

Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/agp.h      |    1 +
 drivers/char/agp/backend.c  |    1 +
 drivers/char/agp/generic.c  |   12 +++++++++---
 include/linux/agp_backend.h |    2 +-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/char/agp/agp.h~intel-agp-rewrite-gtt-on-resume-update drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h~intel-agp-rewrite-gtt-on-resume-update
+++ a/drivers/char/agp/agp.h
@@ -150,6 +150,7 @@ struct agp_bridge_data {
 	u32 apbase_config;
 	/* list of agp_memory mapped to the aperture */
 	struct list_head mapped_list;
+	spinlock_t mapped_lock;
 };
 
 #define KB(x)	((x) * 1024)
diff -puN drivers/char/agp/backend.c~intel-agp-rewrite-gtt-on-resume-update drivers/char/agp/backend.c
--- a/drivers/char/agp/backend.c~intel-agp-rewrite-gtt-on-resume-update
+++ a/drivers/char/agp/backend.c
@@ -184,6 +184,7 @@ static int agp_backend_initialize(struct
 		goto err_out;
 	}
 	INIT_LIST_HEAD(&bridge->mapped_list);
+	spin_lock_init(&bridge->mapped_lock);
 
 	return 0;
 
diff -puN drivers/char/agp/generic.c~intel-agp-rewrite-gtt-on-resume-update drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~intel-agp-rewrite-gtt-on-resume-update
+++ a/drivers/char/agp/generic.c
@@ -426,7 +426,9 @@ int agp_bind_memory(struct agp_memory *c
 
 	curr->is_bound = TRUE;
 	curr->pg_start = pg_start;
-	list_add(&curr->mapped_list, &agp_bridge->mapped_list);
+	spin_lock(&agp_bridge->mapped_lock);
+	list_add (&curr->mapped_list, &agp_bridge->mapped_list);
+	spin_unlock(&agp_bridge->mapped_lock);
 
 	return 0;
 }
@@ -460,7 +462,9 @@ int agp_unbind_memory(struct agp_memory 
 
 	curr->is_bound = FALSE;
 	curr->pg_start = 0;
-	list_del(&curr->mapped_list);
+	spin_lock(&curr->bridge->mapped_lock);
+	list_del (&curr->mapped_list);
+	spin_unlock(&curr->bridge->mapped_lock);
 	return 0;
 }
 EXPORT_SYMBOL(agp_unbind_memory);
@@ -468,11 +472,12 @@ EXPORT_SYMBOL(agp_unbind_memory);
 /**
  *	agp_rebind_emmory  -  Rewrite the entire GATT, useful on resume
  */
-int agp_rebind_memory(void)
+int agp_rebind_memory (void)
 {
 	struct agp_memory *curr;
 	int ret_val;
 
+	spin_lock(&agp_bridge->mapped_lock);
 	list_for_each_entry(curr, &agp_bridge->mapped_list, mapped_list) {
 		ret_val = curr->bridge->driver->insert_memory(curr,
 							      curr->pg_start,
@@ -480,6 +485,7 @@ int agp_rebind_memory(void)
 		if (ret_val != 0)
 			return ret_val;
 	}
+	spin_unlock(&agp_bridge->mapped_lock);
 	return 0;
 }
 EXPORT_SYMBOL(agp_rebind_memory);
diff -puN include/linux/agp_backend.h~intel-agp-rewrite-gtt-on-resume-update include/linux/agp_backend.h
--- a/include/linux/agp_backend.h~intel-agp-rewrite-gtt-on-resume-update
+++ a/include/linux/agp_backend.h
@@ -108,7 +108,7 @@ extern struct agp_memory *agp_allocate_m
 extern int agp_copy_info(struct agp_bridge_data *, struct agp_kern_info *);
 extern int agp_bind_memory(struct agp_memory *, off_t);
 extern int agp_unbind_memory(struct agp_memory *);
-extern int agp_rebind_memory(void);
+extern int agp_rebind_memory (void);
 extern void agp_enable(struct agp_bridge_data *, u32);
 extern struct agp_bridge_data *agp_backend_acquire(struct pci_dev *);
 extern void agp_backend_release(struct agp_bridge_data *);
_

Patches currently in -mm which might be from keithp@keithp.com are

linux-next.patch
intel-agp-rewrite-gtt-on-resume.patch
intel-agp-rewrite-gtt-on-resume-update.patch
intel-agp-rewrite-gtt-on-resume-update-checkpatch-fixes.patch

