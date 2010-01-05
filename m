From: akpm@linux-foundation.org
Subject: [to-be-updated] i2c-fix-off-by-one-in-piix4vt596_transaction.patch removed from -mm tree
Date: Tue, 05 Jan 2010 11:36:07 -0800
Message-ID: <201001051936.o05Ja73V014848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932137Ab0AETga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2010 14:36:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ben-linux@fluff.org, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c: fix off-by-one in {piix4,vt596}_transaction()
has been removed from the -mm tree.  Its filename was
     i2c-fix-off-by-one-in-piix4vt596_transaction.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: fix off-by-one in {piix4,vt596}_transaction()
From: Roel Kluin <roel.kluin@gmail.com>

With `while (timeout++ < MAX_TIMEOUT)' timeout reaches MAX_TIMEOUT + 1
after the loop This is probably unlikely to produce a problem.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-piix4.c  |    2 +-
 drivers/i2c/busses/i2c-viapro.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/i2c/busses/i2c-piix4.c~i2c-fix-off-by-one-in-piix4vt596_transaction drivers/i2c/busses/i2c-piix4.c
--- a/drivers/i2c/busses/i2c-piix4.c~i2c-fix-off-by-one-in-piix4vt596_transaction
+++ a/drivers/i2c/busses/i2c-piix4.c
@@ -329,7 +329,7 @@ static int piix4_transaction(void)
 		msleep(1);
 
 	/* If the SMBus is still busy, we give up */
-	if (timeout >= MAX_TIMEOUT) {
+	if (timeout > MAX_TIMEOUT) {
 		dev_err(&piix4_adapter.dev, "SMBus Timeout!\n");
 		result = -ETIMEDOUT;
 	}
diff -puN drivers/i2c/busses/i2c-viapro.c~i2c-fix-off-by-one-in-piix4vt596_transaction drivers/i2c/busses/i2c-viapro.c
--- a/drivers/i2c/busses/i2c-viapro.c~i2c-fix-off-by-one-in-piix4vt596_transaction
+++ a/drivers/i2c/busses/i2c-viapro.c
@@ -168,7 +168,7 @@ static int vt596_transaction(u8 size)
 	} while ((temp & 0x01) && (timeout++ < MAX_TIMEOUT));
 
 	/* If the SMBus is still busy, we give up */
-	if (timeout >= MAX_TIMEOUT) {
+	if (timeout > MAX_TIMEOUT) {
 		result = -ETIMEDOUT;
 		dev_err(&vt596_adapter.dev, "SMBus timeout!\n");
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
omap-confusion-in-iommu_put.patch
omap3-add-missing-parentheses.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
i2c-fix-off-by-one-in-piix4vt596_transaction.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
paride-fix-off-by-one-test.patch
ieee80211-add-missing-parentheses.patch
rt2860-test-off-by-one-in-rtmpasicsendcommandtomcu.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

