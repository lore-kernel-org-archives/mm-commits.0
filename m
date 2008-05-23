From: akpm@linux-foundation.org
Subject: - mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:40 -0700
Message-ID: <200805231859.m4NIxeVm004256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981AbYEWTAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 15:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: introduce struct michael_mic_ctx and static helpers
has been removed from the -mm tree.  Its filename was
     mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: introduce struct michael_mic_ctx and static helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Replace the existing macro with a static function, significantly shrinks the
size of the produced object file.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   75 ++++++++++++++++++++-------------------
 net/mac80211/michael.h |    4 ++
 2 files changed, 44 insertions(+), 35 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-introduce-struct-michael_mic_ctx-and-static-helpers net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-introduce-struct-michael_mic_ctx-and-static-helpers
+++ a/net/mac80211/michael.c
@@ -13,46 +13,52 @@
 
 #include "michael.h"
 
-#define michael_block(l, r) \
-do { \
-	r ^= rol32(l, 17); \
-	l += r; \
-	r ^= ((l & 0xff00ff00) >> 8) | ((l & 0x00ff00ff) << 8); \
-	l += r; \
-	r ^= rol32(l, 3); \
-	l += r; \
-	r ^= ror32(l, 2); \
-	l += r; \
-} while (0)
+static void michael_block(struct michael_mic_ctx *mctx, u32 val)
+{
+	mctx->l ^= val;
+	mctx->r ^= rol32(mctx->l, 17);
+	mctx->l += mctx->r;
+	mctx->r ^= ((mctx->l & 0xff00ff00) >> 8) |
+		   ((mctx->l & 0x00ff00ff) << 8);
+	mctx->l += mctx->r;
+	mctx->r ^= rol32(mctx->l, 3);
+	mctx->l += mctx->r;
+	mctx->r ^= ror32(mctx->l, 2);
+	mctx->l += mctx->r;
+}
+
+static void michael_mic_hdr(struct michael_mic_ctx *mctx,
+			    u8 *key, u8 *da, u8 *sa, u8 priority)
+{
+	mctx->l = get_unaligned_le32(key);
+	mctx->r = get_unaligned_le32(key + 4);
+
+	/*
+	 * A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
+	 * calculation, but it is _not_ transmitted
+	 */
+	michael_block(mctx, get_unaligned_le32(da));
+	michael_block(mctx, get_unaligned_le16(&da[4]) |
+			    (get_unaligned_le16(sa) << 16));
+	michael_block(mctx, get_unaligned_le32(&sa[2]));
+	michael_block(mctx, priority);
+}
 
 void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		 u8 *data, size_t data_len, u8 *mic)
 {
-	u32 l, r, val;
+	u32 val;
 	size_t block, blocks, left;
+	struct michael_mic_ctx mctx;
 
-	l = get_unaligned_le32(key);
-	r = get_unaligned_le32(key + 4);
-
-	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
-	 * calculation, but it is _not_ transmitted */
-	l ^= get_unaligned_le32(da);
-	michael_block(l, r);
-	l ^= get_unaligned_le16(&da[4]) | (get_unaligned_le16(sa) << 16);
-	michael_block(l, r);
-	l ^= get_unaligned_le32(&sa[2]);
-	michael_block(l, r);
-	l ^= priority;
-	michael_block(l, r);
+	michael_mic_hdr(&mctx, key, da, sa, priority);
 
 	/* Real data */
 	blocks = data_len / 4;
 	left = data_len % 4;
 
-	for (block = 0; block < blocks; block++) {
-		l ^= get_unaligned_le32(&data[block * 4]);
-		michael_block(l, r);
-	}
+	for (block = 0; block < blocks; block++)
+		michael_block(&mctx, get_unaligned_le32(&data[block * 4]));
 
 	/* Partial block of 0..3 bytes and padding: 0x5a + 4..7 zeros to make
 	 * total length a multiple of 4. */
@@ -62,11 +68,10 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 		left--;
 		val |= data[blocks * 4 + left];
 	}
-	l ^= val;
-	michael_block(l, r);
-	/* last block is zero, so l ^ 0 = l */
-	michael_block(l, r);
 
-	put_unaligned_le32(l, mic);
-	put_unaligned_le32(r, mic + 4);
+	michael_block(&mctx, val);
+	michael_block(&mctx, 0);
+
+	put_unaligned_le32(mctx.l, mic);
+	put_unaligned_le32(mctx.r, mic + 4);
 }
diff -puN net/mac80211/michael.h~mac80211-introduce-struct-michael_mic_ctx-and-static-helpers net/mac80211/michael.h
--- a/net/mac80211/michael.h~mac80211-introduce-struct-michael_mic_ctx-and-static-helpers
+++ a/net/mac80211/michael.h
@@ -14,6 +14,10 @@
 
 #define MICHAEL_MIC_LEN 8
 
+struct michael_mic_ctx {
+	u32 l, r;
+};
+
 void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		 u8 *data, size_t data_len, u8 *mic);
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

