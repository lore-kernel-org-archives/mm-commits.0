From: akpm@linux-foundation.org
Subject: - isdn-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:27 -0700
Message-ID: <200808042007.m74K7RBV027785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751AbYHDUHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     isdn-use-the-common-ascii-hex-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
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
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

