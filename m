From: akpm@linux-foundation.org
Subject: - driver-edac-mod-edac_align_ptr-function.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:01 -0700
Message-ID: <200707192007.l6JK719f020217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940AbXGSUPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: mod edac_align_ptr function
has been removed from the -mm tree.  Its filename was
     driver-edac-mod-edac_align_ptr-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: mod edac_align_ptr function
From: Douglas Thompson <dougthompson@xmission.com>

Refactor the edac_align_ptr() function to reduce the noise of casting the
aligned pointer to the various types of data objects and modified its callers
to its new signature

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h   |    2 --
 drivers/edac/edac_device.c |    9 +++------
 drivers/edac/edac_mc.c     |    9 ++++-----
 drivers/edac/edac_module.h |    1 +
 4 files changed, 8 insertions(+), 13 deletions(-)

diff -puN drivers/edac/edac_core.h~driver-edac-mod-edac_align_ptr-function drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~driver-edac-mod-edac_align_ptr-function
+++ a/drivers/edac/edac_core.h
@@ -211,8 +211,6 @@ enum scrub_type {
 #define OP_RUNNING_POLL_INTR	0x203
 #define OP_OFFLINE		0x300
 
-extern char *edac_align_ptr(void *ptr, unsigned size);
-
 /*
  * There are several things to be aware of that aren't at all obvious:
  *
diff -puN drivers/edac/edac_device.c~driver-edac-mod-edac_align_ptr-function drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~driver-edac-mod-edac_align_ptr-function
+++ a/drivers/edac/edac_device.c
@@ -89,17 +89,14 @@ struct edac_device_ctl_info *edac_device
 	dev_ctl = (struct edac_device_ctl_info *)NULL;
 
 	/* Calc the 'end' offset past the ctl_info structure */
-	dev_inst = (struct edac_device_instance *)
-		edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
+	dev_inst = edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
 
 	/* Calc the 'end' offset past the instance array */
-	dev_blk = (struct edac_device_block *)
-		edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
+	dev_blk = edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
 
 	/* Calc the 'end' offset past the dev_blk array */
 	count = nr_instances * nr_blocks;
-	dev_attrib = (struct edac_attrib *)
-		edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
+	dev_attrib = edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
 
 	/* Check for case of NO attributes specified */
 	if (nr_attribs > 0)
diff -puN drivers/edac/edac_mc.c~driver-edac-mod-edac_align_ptr-function drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~driver-edac-mod-edac_align_ptr-function
+++ a/drivers/edac/edac_mc.c
@@ -85,7 +85,7 @@ static void edac_mc_dump_mci(struct mem_
  * If 'size' is a constant, the compiler will optimize this whole function
  * down to either a no-op or the addition of a constant to the value of 'ptr'.
  */
-char *edac_align_ptr(void *ptr, unsigned size)
+void *edac_align_ptr(void *ptr, unsigned size)
 {
 	unsigned align, r;
 
@@ -109,7 +109,7 @@ char *edac_align_ptr(void *ptr, unsigned
 	if (r == 0)
 		return (char *)ptr;
 
-	return (char *)(((unsigned long)ptr) + align - r);
+	return (void *)(((unsigned long)ptr) + align - r);
 }
 
 /**
@@ -144,9 +144,8 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	 * hardcode everything into a single struct.
 	 */
 	mci = (struct mem_ctl_info *)0;
-	csi = (struct csrow_info *)edac_align_ptr(&mci[1], sizeof(*csi));
-	chi = (struct channel_info *)
-		edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
+	csi = edac_align_ptr(&mci[1], sizeof(*csi));
+	chi = edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
 	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
diff -puN drivers/edac/edac_module.h~driver-edac-mod-edac_align_ptr-function drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~driver-edac-mod-edac_align_ptr-function
+++ a/drivers/edac/edac_module.h
@@ -44,6 +44,7 @@ extern void edac_device_workq_setup(stru
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
+extern void *edac_align_ptr(void *ptr, unsigned size);
 
 /*
  * EDAC PCI functions
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
