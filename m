From: akpm@linux-foundation.org
Subject: - isdn-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Fri, 02 May 2008 17:08:51 -0700
Message-ID: <200805030008.m4308pGk022257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965379AbYECAIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 20:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     isdn: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     isdn-use-the-common-ascii-hex-helpers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/isocdata.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/isdn/gigaset/isocdata.c~isdn-use-the-common-ascii-hex-helpers drivers/isdn/gigaset/isocdata.c
--- a/drivers/isdn/gigaset/isocdata.c~isdn-use-the-common-ascii-hex-helpers
+++ a/drivers/isdn/gigaset/isocdata.c
@@ -247,7 +247,6 @@ static inline void dump_bytes(enum debug
 #ifdef CONFIG_GIGASET_DEBUG
 	unsigned char c;
 	static char dbgline[3 * 32 + 1];
-	static const char hexdigit[] = "0123456789abcdef";
 	int i = 0;
 	while (count-- > 0) {
 		if (i > sizeof(dbgline) - 4) {
@@ -258,8 +257,8 @@ static inline void dump_bytes(enum debug
 		c = *bytes++;
 		dbgline[i] = (i && !(i % 12)) ? '-' : ' ';
 		i++;
-		dbgline[i++] = hexdigit[(c >> 4) & 0x0f];
-		dbgline[i++] = hexdigit[c & 0x0f];
+		dbgline[i++] = hex_asc_hi(c);
+		dbgline[i++] = hex_asc_lo(c);
 	}
 	dbgline[i] = '\0';
 	gig_dbg(level, "%s:%s", tag, dbgline);
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
isdn-use-the-common-ascii-hex-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

