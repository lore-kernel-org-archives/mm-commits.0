From: akpm@linux-foundation.org
Subject: [merged] dme1737-keep-index-within-pwm_config.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:35 -0700
Message-ID: <200909231952.n8NJqZk4029447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbZIWTxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     dme1737: Keep index within pwm_config[]
has been removed from the -mm tree.  Its filename was
     dme1737-keep-index-within-pwm_config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dme1737: Keep index within pwm_config[]
From: Roel Kluin <roel.kluin@gmail.com>

The static code scanner "Parfait" reported this because pwm_config is
only 3 bytes - pwm_config[3] is out of range.

Since this code path is never called with ix == 3 (the device has no PWM4
output) this doesn't change anything in practice.  But to encourage
testing with Parfait, lets make the warning go away...

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/dme1737.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/dme1737.c~dme1737-keep-index-within-pwm_config drivers/hwmon/dme1737.c
--- a/drivers/hwmon/dme1737.c~dme1737-keep-index-within-pwm_config
+++ a/drivers/hwmon/dme1737.c
@@ -1134,7 +1134,7 @@ static ssize_t show_pwm(struct device *d
 		res = PWM_FREQ_FROM_REG(data->pwm_freq[ix]);
 		break;
 	case SYS_PWM_ENABLE:
-		if (ix > 3) {
+		if (ix >= 3) {
 			res = 1; /* pwm[5-6] hard-wired to manual mode */
 		} else {
 			res = PWM_EN_FROM_REG(data->pwm_config[ix]);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
dm-strncpy-does-not-null-terminate-string.patch
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
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

