From: akpm@linux-foundation.org
Subject: - ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch removed from -mm tree
Date: Mon, 06 Aug 2007 11:25:32 -0700
Message-ID: <200708061825.l76IPW12008143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649AbXHFSZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ata-ahci-alpm-enable-link-power-management-for-ata-drivers fix
has been removed from the -mm tree.  Its filename was
     ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch

This patch was dropped because an updated version will be merged

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
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix
+++ a/drivers/ata/libata-core.c
@@ -2038,7 +2038,7 @@ int ata_dev_configure(struct ata_device 
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
-	if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
+	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_ALPM) {
 		dev->horkage |= ATA_HORKAGE_ALPM;
 
 		/* reset link pm_policy for this port to no pm */
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

git-alsa.patch
git-kvm.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch
fs-remove-some-aop_truncated_page-fix.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
