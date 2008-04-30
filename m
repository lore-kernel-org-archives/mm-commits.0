From: akpm@linux-foundation.org
Subject: + mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch added to -mm tree
Date: Wed, 30 Apr 2008 11:50:59 -0700
Message-ID: <200804301850.m3UIoxK8029356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbYD3SwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 14:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linville@tuxdriver.com


The patch titled
     mac80211: introduce struct michael_mic_ctx and static helpers
has been added to the -mm tree.  Its filename is
     mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
frv-unbreak-misalignment-handling-changes.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

