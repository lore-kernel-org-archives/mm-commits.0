From: akpm@linux-foundation.org
Subject: - drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:11:50 -0700
Message-ID: <200708201911.l7KJBoru018291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbXHTTMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/md/dm-table.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/md/dm-table.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/dm-table.c | 21698 -> 21664 (-34 bytes)
 drivers/md/dm-table.o | 132153 -> 132093 (-60 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-table.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/md/dm-table.c~drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/md/dm-table.c
@@ -213,12 +213,12 @@ static int alloc_targets(struct dm_table
 int dm_table_create(struct dm_table **result, int mode,
 		    unsigned num_targets, struct mapped_device *md)
 {
-	struct dm_table *t = kmalloc(sizeof(*t), GFP_KERNEL);
+	struct dm_table *t;
 
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
 	if (!t)
 		return -ENOMEM;
 
-	memset(t, 0, sizeof(*t));
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 1);
 
@@ -229,7 +229,6 @@ int dm_table_create(struct dm_table **re
 
 	if (alloc_targets(t, num_targets)) {
 		kfree(t);
-		t = NULL;
 		return -ENOMEM;
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
