From: akpm@linux-foundation.org
Subject: - input-ads7846c-remove-sparse-endian-warnings.patch removed from -mm tree
Date: Wed, 23 Jul 2008 20:44:28 -0700
Message-ID: <200807240344.m6O3iSvx027087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYGXDof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 23:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: ads7846.c remove sparse endian warnings
has been removed from the -mm tree.  Its filename was
     input-ads7846c-remove-sparse-endian-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: ads7846.c remove sparse endian warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

Also remove the temporary pointer and use ->rx_buf directly.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/input/touchscreen/ads7846.c~input-ads7846c-remove-sparse-endian-warnings drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~input-ads7846c-remove-sparse-endian-warnings
+++ a/drivers/input/touchscreen/ads7846.c
@@ -633,19 +633,17 @@ static void ads7846_rx_val(void *ads)
 	struct ads7846 *ts = ads;
 	struct spi_message *m;
 	struct spi_transfer *t;
-	u16 *rx_val;
 	int val;
 	int action;
 	int status;
 
 	m = &ts->msg[ts->msg_idx];
 	t = list_entry(m->transfers.prev, struct spi_transfer, transfer_list);
-	rx_val = t->rx_buf;
 
 	/* adjust:  on-wire is a must-ignore bit, a BE12 value, then padding;
 	 * built from two 8 bit values written msb-first.
 	 */
-	val = be16_to_cpu(*rx_val) >> 3;
+	val = be16_to_cpup((__be16 *)t->rx_buf) >> 3;
 
 	action = ts->filter(ts->filter_data, ts->msg_idx, &val);
 	switch (action) {
@@ -659,7 +657,7 @@ static void ads7846_rx_val(void *ads)
 		m = ts->last_msg;
 		break;
 	case ADS7846_FILTER_OK:
-		*rx_val = val;
+		*(u16 *)t->rx_buf = val;
 		ts->tc.ignore = 0;
 		m = &ts->msg[++ts->msg_idx];
 		break;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
git-input.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
lockd-trivial-sparse-endian-annotations.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
markers-fix-sparse-integer-as-null-pointer-warning.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

