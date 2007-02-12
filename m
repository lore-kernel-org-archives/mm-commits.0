From: akpm@linux-foundation.org
Subject: - mark-struct-file_operations-const-4-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:26:46 -0800
Message-ID: <200702120726.l1C7Qki6024799@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933063AbXBLH0s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:26:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     mark-struct-file_operations-const-4-fix
has been removed from the -mm tree.  Its filename was
     mark-struct-file_operations-const-4-fix.patch

This patch was dropped because it was folded into mark-struct-file_operations-const-4.patch

------------------------------------------------------
Subject: mark-struct-file_operations-const-4-fix
From: Andrew Morton <akpm@osdl.org>

drivers/media/video/saa7134/saa7134-oss.c:566: error: conflicting type qualifiers for 'saa7134_dsp_fops'
drivers/media/video/saa7134/saa7134.h:675: error: previous declaration of 'saa7134_dsp_fops' was here
drivers/media/video/saa7134/saa7134-oss.c:807: error: conflicting type qualifiers for 'saa7134_mixer_fops'
drivers/media/video/saa7134/saa7134.h:676: error: previous declaration of 'saa7134_mixer_fops' was here

Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/saa7134/saa7134.h~mark-struct-file_operations-const-4-fix drivers/media/video/saa7134/saa7134.h
--- a/drivers/media/video/saa7134/saa7134.h~mark-struct-file_operations-const-4-fix
+++ a/drivers/media/video/saa7134/saa7134.h
@@ -683,8 +683,8 @@ int saa_dsp_writel(struct saa7134_dev *d
 /* ----------------------------------------------------------- */
 /* saa7134-oss.c                                               */
 
-extern struct file_operations saa7134_dsp_fops;
-extern struct file_operations saa7134_mixer_fops;
+extern const struct file_operations saa7134_dsp_fops;
+extern const struct file_operations saa7134_mixer_fops;
 
 int saa7134_oss_init1(struct saa7134_dev *dev);
 int saa7134_oss_fini(struct saa7134_dev *dev);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-generalize-metadata-read-write.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-4-fix.patch
