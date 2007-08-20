From: akpm@linux-foundation.org
Subject: - drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:21 -0700
Message-ID: <200708201913.l7KJDLt0018433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756297AbXHTTVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/gdth.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/gdth.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/gdth.c | 189401 -> 189342 (-59 bytes)
 drivers/scsi/gdth.o | 331028 -> 330324 (-704 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/gdth.c~drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/scsi/gdth.c
@@ -726,10 +726,10 @@ int __gdth_execute(struct scsi_device *s
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
-    scp = kmalloc(sizeof(*scp), GFP_KERNEL);
+    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
-    memset(scp, 0, sizeof(*scp));
+
     scp->device = sdev;
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
