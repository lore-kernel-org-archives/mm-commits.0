From: akpm@linux-foundation.org
Subject: [merged] hid-fix-read-buffer-overflow.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:14 -0700
Message-ID: <200908101928.n7AJSEh2027263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbZHJT2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     hid-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

declared in drivers/hid/usbhid/hid-core.c:62:
static char *quirks_param[MAX_USBHID_BOOT_QUIRKS] = ...

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/usbhid/hid-quirks.c~hid-fix-read-buffer-overflow drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c~hid-fix-read-buffer-overflow
+++ a/drivers/hid/usbhid/hid-quirks.c
@@ -201,7 +201,7 @@ int usbhid_quirks_init(char **quirks_par
 	u32 quirks;
 	int n = 0, m;
 
-	for (; quirks_param[n] && n < MAX_USBHID_BOOT_QUIRKS; n++) {
+	for (; n < MAX_USBHID_BOOT_QUIRKS && quirks_param[n]; n++) {
 
 		m = sscanf(quirks_param[n], "0x%hx:0x%hx:0x%x",
 				&idVendor, &idProduct, &quirks);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

