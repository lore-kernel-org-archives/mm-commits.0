From: akpm@linux-foundation.org
Subject: - hpt3x2n-correct-revision-boundary.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:20 -0700
Message-ID: <200705291854.l4TIsJQZ008517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760237AbXE2SzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     hpt3x2n: Correct revision boundary
has been removed from the -mm tree.  Its filename was
     hpt3x2n-correct-revision-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hpt3x2n: Correct revision boundary
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We have a revision that isn't correctly claimed as two drivers both go for it:
Fix the test accordingly.  Noticed originally by Bill Nottingham.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt3x2n.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_hpt3x2n.c~hpt3x2n-correct-revision-boundary drivers/ata/pata_hpt3x2n.c
--- a/drivers/ata/pata_hpt3x2n.c~hpt3x2n-correct-revision-boundary
+++ a/drivers/ata/pata_hpt3x2n.c
@@ -521,8 +521,8 @@ static int hpt3x2n_init_one(struct pci_d
 			/* 371N if rev > 1 */
 			break;
 		case PCI_DEVICE_ID_TTI_HPT372:
-			/* 372N if rev >= 1*/
-			if (class_rev == 0)
+			/* 372N if rev >= 2*/
+			if (class_rev < 2)
 				return -ENODEV;
 			break;
 		case PCI_DEVICE_ID_TTI_HPT302:
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-arm-master.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
git-scsi-misc.patch
git-watchdog.patch
add-pci_try_set_mwi-prism54pci.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
