From: akpm@linux-foundation.org
Subject: [merged] nvidiafb-remove-open_lock-mutex.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:44:13 -0700
Message-ID: <200904011844.n31IiDud010419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933795AbZDATNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:13:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abogani@texware.it, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: remove open_lock mutex
has been removed from the -mm tree.  Its filename was
     nvidiafb-remove-open_lock-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nvidiafb: remove open_lock mutex
From: Alessio Igor Bogani <abogani@texware.it>

Remove mutex from the nvidiafb_open/nvidiafb_release functions as these
operations are mutexed at fb layer.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_type.h |    2 --
 drivers/video/nvidia/nvidia.c  |    7 -------
 2 files changed, 9 deletions(-)

diff -puN drivers/video/nvidia/nv_type.h~nvidiafb-remove-open_lock-mutex drivers/video/nvidia/nv_type.h
--- a/drivers/video/nvidia/nv_type.h~nvidiafb-remove-open_lock-mutex
+++ a/drivers/video/nvidia/nv_type.h
@@ -5,7 +5,6 @@
 #include <linux/types.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include <linux/mutex.h>
 #include <video/vga.h>
 
 #define NV_ARCH_04  0x04
@@ -99,7 +98,6 @@ struct nvidia_par {
 	RIVA_HW_STATE initial_state;
 	RIVA_HW_STATE *CurrentState;
 	struct vgastate vgastate;
-	struct mutex open_lock;
 	u32 pseudo_palette[16];
 	struct pci_dev *pci_dev;
 	u32 Architecture;
diff -puN drivers/video/nvidia/nvidia.c~nvidiafb-remove-open_lock-mutex drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nvidiafb-remove-open_lock-mutex
+++ a/drivers/video/nvidia/nvidia.c
@@ -1004,15 +1004,12 @@ static int nvidiafb_open(struct fb_info 
 {
 	struct nvidia_par *par = info->par;
 
-	mutex_lock(&par->open_lock);
-
 	if (!par->open_count) {
 		save_vga_x86(par);
 		nvidia_save_vga(par, &par->initial_state);
 	}
 
 	par->open_count++;
-	mutex_unlock(&par->open_lock);
 	return 0;
 }
 
@@ -1021,8 +1018,6 @@ static int nvidiafb_release(struct fb_in
 	struct nvidia_par *par = info->par;
 	int err = 0;
 
-	mutex_lock(&par->open_lock);
-
 	if (!par->open_count) {
 		err = -EINVAL;
 		goto done;
@@ -1035,7 +1030,6 @@ static int nvidiafb_release(struct fb_in
 
 	par->open_count--;
 done:
-	mutex_unlock(&par->open_lock);
 	return err;
 }
 
@@ -1300,7 +1294,6 @@ static int __devinit nvidiafb_probe(stru
 
 	par = info->par;
 	par->pci_dev = pd;
-	mutex_init(&par->open_lock);
 	info->pixmap.addr = kzalloc(8 * 1024, GFP_KERNEL);
 
 	if (info->pixmap.addr == NULL)
_

Patches currently in -mm which might be from abogani@texware.it are

origin.patch
linux-next.patch
radio-mr800c-missing-mutex-include.patch

