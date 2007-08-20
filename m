From: akpm@linux-foundation.org
Subject: - drivers-md-dm-cryptc-potential-memleak-fix.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:11:54 -0700
Message-ID: <200708201911.l7KJBsui018298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57159 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760414AbXHTTVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, agk@redhat.com, christophe@saout.de, mm-commits@vger.kernel.org


The patch titled
     drivers/md/dm-crypt.c: potential memleak fix
has been removed from the -mm tree.  Its filename was
     drivers-md-dm-cryptc-potential-memleak-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/md/dm-crypt.c: potential memleak fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Fix a potential memleak on error path in dm-crypt code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Christophe Saout <christophe@saout.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/md/dm-crypt.c~drivers-md-dm-cryptc-potential-memleak-fix drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~drivers-md-dm-cryptc-potential-memleak-fix
+++ a/drivers/md/dm-crypt.c
@@ -175,6 +175,7 @@ static int crypt_iv_essiv_ctr(struct cry
 
 	if (err) {
 		ti->error = "Error calculating hash in ESSIV";
+		kfree(salt);
 		return err;
 	}
 
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
