From: akpm@linux-foundation.org
Subject: - drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:32 -0700
Message-ID: <200708310634.l7V6YW9j027705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598AbXHaGeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/input/serio/gscps2.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/input/serio/gscps2.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/input/serio/gscps2.c | 11696 -> 11607 (-89 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/gscps2.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/input/serio/gscps2.c~drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc drivers/input/serio/gscps2.c
--- a/drivers/input/serio/gscps2.c~drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/input/serio/gscps2.c
@@ -340,8 +340,8 @@ static int __init gscps2_probe(struct pa
 	if (dev->id.sversion == 0x96)
 		hpa += GSC_DINO_OFFSET;
 
-	ps2port = kmalloc(sizeof(struct gscps2port), GFP_KERNEL);
-	serio = kmalloc(sizeof(struct serio), GFP_KERNEL);
+	ps2port = kzalloc(sizeof(struct gscps2port), GFP_KERNEL);
+	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
 	if (!ps2port || !serio) {
 		ret = -ENOMEM;
 		goto fail_nomem;
@@ -349,8 +349,6 @@ static int __init gscps2_probe(struct pa
 
 	dev_set_drvdata(&dev->dev, ps2port);
 
-	memset(ps2port, 0, sizeof(struct gscps2port));
-	memset(serio, 0, sizeof(struct serio));
 	ps2port->port = serio;
 	ps2port->padev = dev;
 	ps2port->addr = ioremap_nocache(hpa, GSC_STATUS + 4);
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
request_irq-fix-debug_shirq-handling-re-2623-rc2-mm1-rtl8139-inconsistent-lock-state.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
git-mmc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
git-v9fs.patch
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
