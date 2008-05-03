From: akpm@linux-foundation.org
Subject: - scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch removed from -mm tree
Date: Fri, 02 May 2008 17:08:32 -0700
Message-ID: <200805030008.m4308WMv022233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932542AbYECAIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 20:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scsi: use the common hex_asc array rather than a private one
has been removed from the -mm tree.  Its filename was
     scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: use the common hex_asc array rather than a private one
From: Harvey Harrison <harvey.harrison@gmail.com>

Also use the hi/lo helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmmca.c    |    3 +--
 drivers/scsi/ultrastor.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ibmmca.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one
+++ a/drivers/scsi/ibmmca.c
@@ -1002,12 +1002,11 @@ static char *ti_p(int dev)
 /* interpreter for logical device numbers (ldn) */
 static char *ti_l(int val)
 {
-	const char hex[16] = "0123456789abcdef";
 	static char answer[2];
 
 	answer[1] = (char) (0x0);
 	if (val <= MAX_LOG_DEV)
-		answer[0] = hex[val];
+		answer[0] = hex_asc[val];
 	else
 		answer[0] = '-';
 	return (char *) &answer;
diff -puN drivers/scsi/ultrastor.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one drivers/scsi/ultrastor.c
--- a/drivers/scsi/ultrastor.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one
+++ a/drivers/scsi/ultrastor.c
@@ -876,8 +876,8 @@ static int ultrastor_abort(struct scsi_c
 	for (i = 0; i < 16; i++)
 	  {
 	    unsigned char p = inb(port0 + i);
-	    out[28 + i * 3] = "0123456789abcdef"[p >> 4];
-	    out[29 + i * 3] = "0123456789abcdef"[p & 15];
+	    out[28 + i * 3] = hex_asc_hi(p);
+	    out[29 + i * 3] = hex_asc_lo(p);
 	    out[30 + i * 3] = ' ';
 	  }
 	out[28 + i * 3] = '\n';
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
input-ff-memlessc-use-clamp_val-macro.patch
ata-remove-fit-macro.patch
ide-eliminate-fit-macro.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
ide-use-get_unaligned_-helpers.patch
git-mips.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
net-use-get-put_unaligned_-helpers.patch
bluetooth-use-get-put_unaligned_-helpers.patch
irda-use-get_unaligned_-helpers.patch
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
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
cris-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
frv-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch
sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

