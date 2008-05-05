From: akpm@linux-foundation.org
Subject: - irda-use-get_unaligned_-helpers.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:49 -0700
Message-ID: <200805051916.m45JGnNr000330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbYEETQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:16:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     irda: use get_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     irda-use-get_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irda: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/irda/iriap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN net/irda/iriap.c~irda-use-get_unaligned_-helpers net/irda/iriap.c
--- a/net/irda/iriap.c~irda-use-get_unaligned_-helpers
+++ a/net/irda/iriap.c
@@ -451,12 +451,14 @@ static void iriap_getvaluebyclass_confir
 	n = 2;
 
 	/* Get length, MSB first */
-	len = be16_to_cpu(get_unaligned((__be16 *)(fp+n))); n += 2;
+	len = get_unaligned_be16(fp + n);
+	n += 2;
 
 	IRDA_DEBUG(4, "%s(), len=%d\n", __func__, len);
 
 	/* Get object ID, MSB first */
-	obj_id = be16_to_cpu(get_unaligned((__be16 *)(fp+n))); n += 2;
+	obj_id = get_unaligned_be16(fp + n);
+	n += 2;
 
 	type = fp[n++];
 	IRDA_DEBUG(4, "%s(), Value type = %d\n", __func__, type);
@@ -506,7 +508,7 @@ static void iriap_getvaluebyclass_confir
 		value = irias_new_string_value(fp+n);
 		break;
 	case IAS_OCT_SEQ:
-		value_len = be16_to_cpu(get_unaligned((__be16 *)(fp+n)));
+		value_len = get_unaligned_be16(fp + n);
 		n += 2;
 
 		/* Will truncate to IAS_MAX_OCTET_STRING bytes */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
block-use-get_unaligned_-helpers.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
usb-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

