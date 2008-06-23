From: akpm@linux-foundation.org
Subject: - intel-agp-rewrite-gtt-on-resume.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:07 -0700
Message-ID: <200806232102.m5NL27gu016049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759582AbYFWVCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keithp@keithp.com, airlied@linux.ie, andi@firstfloor.org, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     intel-agp: rewrite GTT on resume
has been removed from the -mm tree.  Its filename was
     intel-agp-rewrite-gtt-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-agp: rewrite GTT on resume
From: Keith Packard <keithp@keithp.com>

On my Intel chipset (965GM), the GTT is entirely erased across
suspend/resume.  This patch simply re-plays the current mapping at resume
time to restore the table.=20

I noticed this once I started relying on persistent GTT mappings across VT
switch in our GEM work -- the old X server and DRM code carefully unbind
all memory from the GTT on VT switch, but GEM does not bother.

I placed the list management and rewrite code in the generic layer on the
assumption that it will be needed on other hardware, but I did not add the
rewrite call to anything other than the Intel resume function.


Keep a list of current GATT mappings.  At resume time, rewrite them into
the GATT.  This is needed on Intel (at least) as the entire GATT is
cleared across suspend/resume.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/agp.h       |    3 +++
 drivers/char/agp/backend.c   |    2 ++
 drivers/char/agp/generic.c   |   28 ++++++++++++++++++++++++++++
 drivers/char/agp/intel-agp.c |    5 +++++
 include/linux/agp_backend.h  |    5 +++++
 5 files changed, 43 insertions(+)

diff -puN drivers/char/agp/agp.h~intel-agp-rewrite-gtt-on-resume drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h~intel-agp-rewrite-gtt-on-resume
+++ a/drivers/char/agp/agp.h
@@ -148,6 +148,9 @@ struct agp_bridge_data {
 	char minor_version;
 	struct list_head list;
 	u32 apbase_config;
+	/* list of agp_memory mapped to the aperture */
+	struct list_head mapped_list;
+	spinlock_t mapped_lock;
 };
 
 #define KB(x)	((x) * 1024)
diff -puN drivers/char/agp/backend.c~intel-agp-rewrite-gtt-on-resume drivers/char/agp/backend.c
--- a/drivers/char/agp/backend.c~intel-agp-rewrite-gtt-on-resume
+++ a/drivers/char/agp/backend.c
@@ -183,6 +183,8 @@ static int agp_backend_initialize(struct
 		rc = -EINVAL;
 		goto err_out;
 	}
+	INIT_LIST_HEAD(&bridge->mapped_list);
+	spin_lock_init(&bridge->mapped_lock);
 
 	return 0;
 
diff -puN drivers/char/agp/generic.c~intel-agp-rewrite-gtt-on-resume drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~intel-agp-rewrite-gtt-on-resume
+++ a/drivers/char/agp/generic.c
@@ -426,6 +426,10 @@ int agp_bind_memory(struct agp_memory *c
 
 	curr->is_bound = TRUE;
 	curr->pg_start = pg_start;
+	spin_lock(&agp_bridge->mapped_lock);
+	list_add(&curr->mapped_list, &agp_bridge->mapped_list);
+	spin_unlock(&agp_bridge->mapped_lock);
+
 	return 0;
 }
 EXPORT_SYMBOL(agp_bind_memory);
@@ -458,10 +462,34 @@ int agp_unbind_memory(struct agp_memory 
 
 	curr->is_bound = FALSE;
 	curr->pg_start = 0;
+	spin_lock(&curr->bridge->mapped_lock);
+	list_del(&curr->mapped_list);
+	spin_unlock(&curr->bridge->mapped_lock);
 	return 0;
 }
 EXPORT_SYMBOL(agp_unbind_memory);
 
+/**
+ *	agp_rebind_emmory  -  Rewrite the entire GATT, useful on resume
+ */
+int agp_rebind_memory(void)
+{
+	struct agp_memory *curr;
+	int ret_val = 0;
+
+	spin_lock(&agp_bridge->mapped_lock);
+	list_for_each_entry(curr, &agp_bridge->mapped_list, mapped_list) {
+		ret_val = curr->bridge->driver->insert_memory(curr,
+							      curr->pg_start,
+							      curr->type);
+		if (ret_val != 0)
+			break;
+	}
+	spin_unlock(&agp_bridge->mapped_lock);
+	return ret_val;
+}
+EXPORT_SYMBOL(agp_rebind_memory);
+
 /* End - Routines for handling swapping of agp_memory into the GATT */
 
 
diff -puN drivers/char/agp/intel-agp.c~intel-agp-rewrite-gtt-on-resume drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel-agp-rewrite-gtt-on-resume
+++ a/drivers/char/agp/intel-agp.c
@@ -2176,6 +2176,7 @@ static void __devexit agp_intel_remove(s
 static int agp_intel_resume(struct pci_dev *pdev)
 {
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
+	int ret_val;
 
 	pci_restore_state(pdev);
 
@@ -2203,6 +2204,10 @@ static int agp_intel_resume(struct pci_d
 	else if (bridge->driver == &intel_i965_driver)
 		intel_i915_configure();
 
+	ret_val = agp_rebind_memory();
+	if (ret_val != 0)
+		return ret_val;
+
 	return 0;
 }
 #endif
diff -puN include/linux/agp_backend.h~intel-agp-rewrite-gtt-on-resume include/linux/agp_backend.h
--- a/include/linux/agp_backend.h~intel-agp-rewrite-gtt-on-resume
+++ a/include/linux/agp_backend.h
@@ -30,6 +30,8 @@
 #ifndef _AGP_BACKEND_H
 #define _AGP_BACKEND_H 1
 
+#include <linux/list.h>
+
 #ifndef TRUE
 #define TRUE 1
 #endif
@@ -86,6 +88,8 @@ struct agp_memory {
 	u8 is_bound;
 	u8 is_flushed;
         u8 vmalloc_flag;
+	/* list of agp_memory mapped to the aperture */
+	struct list_head mapped_list;
 };
 
 #define AGP_NORMAL_MEMORY 0
@@ -104,6 +108,7 @@ extern struct agp_memory *agp_allocate_m
 extern int agp_copy_info(struct agp_bridge_data *, struct agp_kern_info *);
 extern int agp_bind_memory(struct agp_memory *, off_t);
 extern int agp_unbind_memory(struct agp_memory *);
+extern int agp_rebind_memory(void);
 extern void agp_enable(struct agp_bridge_data *, u32);
 extern struct agp_bridge_data *agp_backend_acquire(struct pci_dev *);
 extern void agp_backend_release(struct agp_bridge_data *);
_

Patches currently in -mm which might be from keithp@keithp.com are


