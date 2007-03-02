From: akpm@linux-foundation.org
Subject: + nvidiafb-bring-back-generic-ddc-reading-fix.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:47:22 -0800
Message-ID: <200703022247.l22MlMHd021371@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45415 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992669AbXCBWrY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:47:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, adaplas@gmail.com


The patch titled
     nvidiafb-bring-back-generic-ddc-reading fix
has been added to the -mm tree.  Its filename is
     nvidiafb-bring-back-generic-ddc-reading-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nvidiafb-bring-back-generic-ddc-reading fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Possible fix for

nvidiafb-bring-back-generic-ddc-reading.patch

drivers/built-in.o: In function `nvidia_probe_i2c_connector':
/mnt/md0/devel/linux-mm/drivers/video/nvidia/nv_i2c.c:166: undefined reference to `fb_ddc_read'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Makefile |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/video/Makefile~nvidiafb-bring-back-generic-ddc-reading-fix drivers/video/Makefile
--- a/drivers/video/Makefile~nvidiafb-bring-back-generic-ddc-reading-fix
+++ a/drivers/video/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_FB_PM3)		  += pm3fb.o
 obj-$(CONFIG_FB_MATROX)		  += matrox/
 obj-$(CONFIG_FB_RIVA)		  += riva/ vgastate.o
 obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
+obj-$(CONFIG_FB_NVIDIA_I2C)	  += fb_ddc.o
 obj-$(CONFIG_FB_ATY)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_RADEON)		  += aty/
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch
nvidiafb-bring-back-generic-ddc-reading-fix.patch
