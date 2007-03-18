From: akpm@linux-foundation.org
Subject: + drivers-char-agp-convert-to-generic-boolean.patch added to -mm tree
Date: Sun, 18 Mar 2007 00:36:35 -0800
Message-ID: <200703180836.l2I8aZCg019451@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbXCRIgp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 04:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, davej@codemonkey.org.uk


The patch titled
     drivers/char/agp: convert to generic boolean
has been added to the -mm tree.  Its filename is
     drivers-char-agp-convert-to-generic-boolean.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/agp: convert to generic boolean
From: Richard Knutsson <ricknu-0@student.ltu.se>

drivers/char/agp/
  Convert to generic booleans

include/linux/agpgart.h
  Removed defines of FALSE/TRUE
    was only used under drivers/char/agp/
  struct agp_front_data {
    Removed used_by_controller
      only assigned 'false' once and never used
    Convert backend_acquired from 'u8' to 'bool'
      only used in drivers/char/agp/ and only as a boolean value

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd-k7-agp.c   |    4 ++--
 drivers/char/agp/amd64-agp.c    |    4 ++--
 drivers/char/agp/ati-agp.c      |    4 ++--
 drivers/char/agp/compat_ioctl.c |    2 +-
 drivers/char/agp/efficeon-agp.c |    4 ++--
 drivers/char/agp/frontend.c     |   11 +++++------
 drivers/char/agp/generic.c      |   22 +++++++++++-----------
 drivers/char/agp/hp-agp.c       |    4 ++--
 drivers/char/agp/intel-agp.c    |    8 ++++----
 drivers/char/agp/nvidia-agp.c   |    4 ++--
 drivers/char/agp/parisc-agp.c   |    4 ++--
 drivers/char/agp/sgi-agp.c      |    4 ++--
 drivers/char/agp/sworks-agp.c   |    4 ++--
 include/linux/agpgart.h         |   11 +----------
 14 files changed, 40 insertions(+), 50 deletions(-)

diff -puN drivers/char/agp/amd64-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/amd64-agp.c
@@ -89,9 +89,9 @@ static int amd64_insert_memory(struct ag
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff -puN drivers/char/agp/amd-k7-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/amd-k7-agp.c
--- a/drivers/char/agp/amd-k7-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/amd-k7-agp.c
@@ -308,9 +308,9 @@ static int amd_insert_memory(struct agp_
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff -puN drivers/char/agp/ati-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/ati-agp.c
--- a/drivers/char/agp/ati-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/ati-agp.c
@@ -299,10 +299,10 @@ static int ati_insert_memory(struct agp_
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		/*CACHE_FLUSH(); */
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff -puN drivers/char/agp/compat_ioctl.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/compat_ioctl.c
--- a/drivers/char/agp/compat_ioctl.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/compat_ioctl.c
@@ -213,7 +213,7 @@ long compat_agp_ioctl(struct file *file,
 		ret_val = -EINVAL;
 		goto ioctl_out;
 	}
-	if ((agp_fe.backend_acquired != TRUE) &&
+	if (!agp_fe.backend_acquired &&
 	    (cmd != AGPIOC_ACQUIRE32)) {
 		ret_val = -EBUSY;
 		goto ioctl_out;
diff -puN drivers/char/agp/efficeon-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/efficeon-agp.c
--- a/drivers/char/agp/efficeon-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/efficeon-agp.c
@@ -249,9 +249,9 @@ static int efficeon_insert_memory(struct
 	if (type != 0 || mem->type != 0)
 		return -EINVAL;
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	last_page = NULL;
diff -puN drivers/char/agp/frontend.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/frontend.c
--- a/drivers/char/agp/frontend.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/frontend.c
@@ -393,7 +393,7 @@ static int agp_remove_controller(struct 
 
 	if (agp_fe.current_controller == controller) {
 		agp_fe.current_controller = NULL;
-		agp_fe.backend_acquired = FALSE;
+		agp_fe.backend_acquired = false;
 		agp_backend_release(agp_bridge);
 	}
 	kfree(controller);
@@ -441,7 +441,6 @@ static void agp_controller_release_curre
 	}
 
 	agp_fe.current_controller = NULL;
-	agp_fe.used_by_controller = FALSE;
 	agp_backend_release(agp_bridge);
 }
 
@@ -571,7 +570,7 @@ static int agp_mmap(struct file *file, s
 
 	mutex_lock(&(agp_fe.agp_mutex));
 
-	if (agp_fe.backend_acquired != TRUE)
+	if (!agp_fe.backend_acquired)
 		goto out_eperm;
 
 	if (!(test_bit(AGP_FF_IS_VALID, &priv->access_flags)))
@@ -766,7 +765,7 @@ int agpioc_acquire_wrap(struct agp_file_
 
 	atomic_inc(&agp_bridge->agp_in_use);
 
-	agp_fe.backend_acquired = TRUE;
+	agp_fe.backend_acquired = true;
 
 	controller = agp_find_controller_by_pid(priv->my_pid);
 
@@ -776,7 +775,7 @@ int agpioc_acquire_wrap(struct agp_file_
 		controller = agp_create_controller(priv->my_pid);
 
 		if (controller == NULL) {
-			agp_fe.backend_acquired = FALSE;
+			agp_fe.backend_acquired = false;
 			agp_backend_release(agp_bridge);
 			return -ENOMEM;
 		}
@@ -972,7 +971,7 @@ static int agp_ioctl(struct inode *inode
 		ret_val = -EINVAL;
 		goto ioctl_out;
 	}
-	if ((agp_fe.backend_acquired != TRUE) &&
+	if (!agp_fe.backend_acquired &&
 	    (cmd != AGPIOC_ACQUIRE)) {
 		ret_val = -EBUSY;
 		goto ioctl_out;
diff -puN drivers/char/agp/generic.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/generic.c
@@ -202,7 +202,7 @@ void agp_free_memory(struct agp_memory *
 	if (curr == NULL)
 		return;
 
-	if (curr->is_bound == TRUE)
+	if (curr->is_bound)
 		agp_unbind_memory(curr);
 
 	if (curr->type >= AGP_USER_TYPES) {
@@ -425,20 +425,20 @@ int agp_bind_memory(struct agp_memory *c
 	if (curr == NULL)
 		return -EINVAL;
 
-	if (curr->is_bound == TRUE) {
+	if (curr->is_bound) {
 		printk(KERN_INFO PFX "memory %p is already bound!\n", curr);
 		return -EINVAL;
 	}
-	if (curr->is_flushed == FALSE) {
+	if (!curr->is_flushed) {
 		curr->bridge->driver->cache_flush();
-		curr->is_flushed = TRUE;
+		curr->is_flushed = true;
 	}
 	ret_val = curr->bridge->driver->insert_memory(curr, pg_start, curr->type);
 
 	if (ret_val != 0)
 		return ret_val;
 
-	curr->is_bound = TRUE;
+	curr->is_bound = true;
 	curr->pg_start = pg_start;
 	return 0;
 }
@@ -460,7 +460,7 @@ int agp_unbind_memory(struct agp_memory 
 	if (curr == NULL)
 		return -EINVAL;
 
-	if (curr->is_bound != TRUE) {
+	if (!curr->is_bound) {
 		printk(KERN_INFO PFX "memory %p was not bound!\n", curr);
 		return -EINVAL;
 	}
@@ -470,7 +470,7 @@ int agp_unbind_memory(struct agp_memory 
 	if (ret_val != 0)
 		return ret_val;
 
-	curr->is_bound = FALSE;
+	curr->is_bound = false;
 	curr->pg_start = 0;
 	return 0;
 }
@@ -832,7 +832,7 @@ void agp_generic_enable(struct agp_bridg
 			/* If we have 3.5, we can do the isoch stuff. */
 			if (bridge->minor_version >= 5)
 				agp_3_5_enable(bridge);
-			agp_device_command(bridge_agpstat, TRUE);
+			agp_device_command(bridge_agpstat, true);
 			return;
 		} else {
 		    /* Disable calibration cycle in RX91<1> when not in AGP3.0 mode of operation.*/
@@ -849,7 +849,7 @@ void agp_generic_enable(struct agp_bridg
 	}
 
 	/* AGP v<3 */
-	agp_device_command(bridge_agpstat, FALSE);
+	agp_device_command(bridge_agpstat, false);
 }
 EXPORT_SYMBOL(agp_generic_enable);
 
@@ -1088,9 +1088,9 @@ int agp_generic_insert_memory(struct agp
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		bridge->driver->cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff -puN drivers/char/agp/hp-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/hp-agp.c
--- a/drivers/char/agp/hp-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/hp-agp.c
@@ -355,9 +355,9 @@ hp_zx1_insert_memory (struct agp_memory 
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
diff -puN drivers/char/agp/intel-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/intel-agp.c
@@ -1435,7 +1435,7 @@ static const struct agp_bridge_driver in
 	.aperture_sizes		= intel_i810_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 2,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i810_configure,
 	.fetch_size		= intel_i810_fetch_size,
 	.cleanup		= intel_i810_cleanup,
@@ -1484,7 +1484,7 @@ static const struct agp_bridge_driver in
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i830_configure,
 	.fetch_size		= intel_i830_fetch_size,
 	.cleanup		= intel_i830_cleanup,
@@ -1653,7 +1653,7 @@ static const struct agp_bridge_driver in
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= TRUE,
+	.needs_scratch_page	= true,
 	.configure		= intel_i915_configure,
 	.fetch_size		= intel_i9xx_fetch_size,
 	.cleanup		= intel_i915_cleanup,
@@ -1678,7 +1678,7 @@ static const struct agp_bridge_driver in
        .aperture_sizes         = intel_i830_sizes,
        .size_type              = FIXED_APER_SIZE,
        .num_aperture_sizes     = 4,
-       .needs_scratch_page     = TRUE,
+       .needs_scratch_page     = true,
        .configure              = intel_i915_configure,
        .fetch_size             = intel_i9xx_fetch_size,
        .cleanup                = intel_i915_cleanup,
diff -puN drivers/char/agp/nvidia-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/nvidia-agp.c
--- a/drivers/char/agp/nvidia-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/nvidia-agp.c
@@ -211,9 +211,9 @@ static int nvidia_insert_memory(struct a
 			return -EBUSY;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
diff -puN drivers/char/agp/parisc-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/parisc-agp.c
--- a/drivers/char/agp/parisc-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/parisc-agp.c
@@ -144,9 +144,9 @@ parisc_agp_insert_memory(struct agp_memo
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
diff -puN drivers/char/agp/sgi-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/sgi-agp.c
--- a/drivers/char/agp/sgi-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/sgi-agp.c
@@ -184,9 +184,9 @@ static int sgi_tioca_insert_memory(struc
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		bridge->driver->cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff -puN drivers/char/agp/sworks-agp.c~drivers-char-agp-convert-to-generic-boolean drivers/char/agp/sworks-agp.c
--- a/drivers/char/agp/sworks-agp.c~drivers-char-agp-convert-to-generic-boolean
+++ a/drivers/char/agp/sworks-agp.c
@@ -347,9 +347,9 @@ static int serverworks_insert_memory(str
 		j++;
 	}
 
-	if (mem->is_flushed == FALSE) {
+	if (!mem->is_flushed) {
 		global_cache_flush();
-		mem->is_flushed = TRUE;
+		mem->is_flushed = true;
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
diff -puN include/linux/agpgart.h~drivers-char-agp-convert-to-generic-boolean include/linux/agpgart.h
--- a/include/linux/agpgart.h~drivers-char-agp-convert-to-generic-boolean
+++ a/include/linux/agpgart.h
@@ -41,14 +41,6 @@
 
 #define AGP_DEVICE      "/dev/agpgart"
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #ifndef __KERNEL__
 #include <linux/types.h>
 #include <asm/types.h>
@@ -205,8 +197,7 @@ struct agp_front_data {
 	struct agp_controller *current_controller;
 	struct agp_controller *controllers;
 	struct agp_file_private *file_priv_list;
-	u8 used_by_controller;
-	u8 backend_acquired;
+	bool backend_acquired;
 };
 
 #endif				/* __KERNEL__ */
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

drivers-char-agp-convert-to-generic-boolean.patch
git-netdev-all.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
usb-serial-io_edgeport-convert-to-generic-boolean.patch
usb-serial-whiteheat-convert-to-generic-boolean.patch
