From: akpm@linux-foundation.org
Subject: [merged] libertas-read-buffer-overflow.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:28 -0700
Message-ID: <200907302038.n6UKcSvg013158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbZG3Uiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dcbw@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     libertas: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     libertas-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libertas: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Several arrays were read before checking whether the index was within
bounds.  ARRAY_SIZE() should be used to determine the size of arrays.

rates->rates has an arraysize of 1, so calling get_common_rates() with a
rates_size of MAX_RATES (14) was causing reads out of bounds.

Since ratesize is at most MAX_RATES, tmp_size can increment at most to
MAX_RATES * ARRAY_SIZE(lbs_bg_rates), so that should be the number of
elements of tmp[].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/assoc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/net/wireless/libertas/assoc.c~libertas-read-buffer-overflow drivers/net/wireless/libertas/assoc.c
--- a/drivers/net/wireless/libertas/assoc.c~libertas-read-buffer-overflow
+++ a/drivers/net/wireless/libertas/assoc.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 2006, Red Hat, Inc. */
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/if_arp.h>
@@ -43,14 +44,14 @@ static int get_common_rates(struct lbs_p
 	u16 *rates_size)
 {
 	u8 *card_rates = lbs_bg_rates;
-	size_t num_card_rates = sizeof(lbs_bg_rates);
+	size_t num_card_rates = ARRAY_SIZE(lbs_bg_rates);
 	int ret = 0, i, j;
-	u8 tmp[30];
+	u8 tmp[MAX_RATES * ARRAY_SIZE(lbs_bg_rates)];
 	size_t tmp_size = 0;
 
 	/* For each rate in card_rates that exists in rate1, copy to tmp */
-	for (i = 0; card_rates[i] && (i < num_card_rates); i++) {
-		for (j = 0; rates[j] && (j < *rates_size); j++) {
+	for (i = 0; i < num_card_rates && card_rates[i]; i++) {
+		for (j = 0; j < *rates_size && rates[j]; j++) {
 			if (rates[j] == card_rates[i])
 				tmp[tmp_size++] = card_rates[i];
 		}
@@ -320,7 +321,7 @@ static int lbs_associate(struct lbs_priv
 	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	memcpy(&rates->rates, &bss->rates, MAX_RATES);
-	tmplen = MAX_RATES;
+	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
 	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
 		goto done;
@@ -594,7 +595,7 @@ static int lbs_adhoc_join(struct lbs_pri
 
 	/* Copy Data rates from the rates recorded in scan response */
 	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
-	ratesize = min_t(u16, sizeof(cmd.bss.rates), MAX_RATES);
+	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
 	memcpy(cmd.bss.rates, bss->rates, ratesize);
 	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
 		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
irda-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
cyclades-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-iprh-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
i915-fix-read-outside-array-bounds.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

