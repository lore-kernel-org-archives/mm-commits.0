From: akpm@linux-foundation.org
Subject: [merged] dm-strncpy-does-not-null-terminate-string.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:42 -0700
Message-ID: <200909241937.n8OJbgEa005112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523AbZIXTiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: strncpy does not null terminate string
has been removed from the -mm tree.  Its filename was
     dm-strncpy-does-not-null-terminate-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm: strncpy does not null terminate string
From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-ioctl.c~dm-strncpy-does-not-null-terminate-string drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm-strncpy-does-not-null-terminate-string
+++ a/drivers/md/dm-ioctl.c
@@ -634,9 +634,9 @@ static struct mapped_device *find_device
 		 * Sneakily write in both the name and the uuid
 		 * while we have the cell.
 		 */
-		strncpy(param->name, hc->name, sizeof(param->name));
+		strlcpy(param->name, hc->name, sizeof(param->name));
 		if (hc->uuid)
-			strncpy(param->uuid, hc->uuid, sizeof(param->uuid)-1);
+			strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
 		else
 			param->uuid[0] = '\0';
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

