From: akpm@linux-foundation.org
Subject: - scsi-make-pcmcia-directory-use-obj-ym-instead-of-subdir-ym.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:32 -0800
Message-ID: <200712172340.lBHNeWWD008299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937572AbXLQXwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, James.Bottomley@steeleye.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scsi: make pcmcia directory use obj-y|m instead of subdir-y|m
has been removed from the -mm tree.  Its filename was
     scsi-make-pcmcia-directory-use-obj-ym-instead-of-subdir-ym.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: make pcmcia directory use obj-y|m instead of subdir-y|m
From: Tejun Heo <htejun@gmail.com>

subdir-y|m isn't supposed to contain modules or built-in components. 
Change subdir-$(CONFIG_PCMCIA) to obj-$(CONFIG_PCMCIA).

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Makefile~scsi-make-pcmcia-directory-use-obj-ym-instead-of-subdir-ym drivers/scsi/Makefile
--- a/drivers/scsi/Makefile~scsi-make-pcmcia-directory-use-obj-ym-instead-of-subdir-ym
+++ a/drivers/scsi/Makefile
@@ -17,7 +17,7 @@
 CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
 CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ -DGDTH_STATISTICS
 
-subdir-$(CONFIG_PCMCIA)		+= pcmcia
+obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
 obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-kbuild.patch
git-libata-all.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-scsi-misc.patch
git-block.patch
