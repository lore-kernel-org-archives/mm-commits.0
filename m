From: akpm@linux-foundation.org
Subject: + ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:08:51 -0700
Message-ID: <200707201808.l6KI8p7Z009302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934050AbXGTSJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, kristen.c.accardi@intel.com


The patch titled
     ata-ahci-alpm-enable-link-power-management-for-ata-drivers fix
has been added to the -mm tree.  Its filename is
     ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ata-ahci-alpm-enable-link-power-management-for-ata-drivers fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

drivers/ata/libata-core.c: In function 'ata_dev_configure':
drivers/ata/libata-core.c:2039: error: implicit declaration of function 'ata_device_blacklisted'

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix
+++ a/drivers/ata/libata-core.c
@@ -2036,7 +2036,7 @@ int ata_dev_configure(struct ata_device 
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
-	if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
+	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_ALPM) {
 		dev->horkage |= ATA_HORKAGE_ALPM;
 
 		/* reset link pm_policy for this port to no pm */
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-kvm.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
