From: akpm@linux-foundation.org
Subject: + mac80211-michaelc-use-kernel-provided-infrastructure.patch added to -mm tree
Date: Wed, 30 Apr 2008 11:50:57 -0700
Message-ID: <200804301850.m3UIowAB029353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419AbYD3SwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 14:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linville@tuxdriver.com


The patch titled
     mac80211: michael.c use kernel-provided infrastructure
has been added to the -mm tree.  Its filename is
     mac80211-michaelc-use-kernel-provided-infrastructure.patch

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
Subject: mac80211: michael.c use kernel-provided infrastructure
From: Harvey Harrison <harvey.harrison@gmail.com>

Replace private implementation of bit rotation and unaligned access helpers
with kernel-provided implementation.

Fold xswap helper in its one usage in the michael_block macro.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   60 +++++++++------------------------------
 1 file changed, 14 insertions(+), 46 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-michaelc-use-kernel-provided-infrastructure net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-michaelc-use-kernel-provided-infrastructure
+++ a/net/mac80211/michael.c
@@ -8,71 +8,39 @@
  */
 
 #include <linux/types.h>
+#include <linux/bitops.h>
+#include <asm/unaligned.h>
 
 #include "michael.h"
 
-static inline u32 rotr(u32 val, int bits)
-{
-	return (val >> bits) | (val << (32 - bits));
-}
-
-
-static inline u32 rotl(u32 val, int bits)
-{
-	return (val << bits) | (val >> (32 - bits));
-}
-
-
-static inline u32 xswap(u32 val)
-{
-	return ((val & 0xff00ff00) >> 8) | ((val & 0x00ff00ff) << 8);
-}
-
-
 #define michael_block(l, r) \
 do { \
-	r ^= rotl(l, 17); \
+	r ^= rol32(l, 17); \
 	l += r; \
-	r ^= xswap(l); \
+	r ^= ((l & 0xff00ff00) >> 8) | ((l & 0x00ff00ff) << 8); \
 	l += r; \
-	r ^= rotl(l, 3); \
+	r ^= rol32(l, 3); \
 	l += r; \
-	r ^= rotr(l, 2); \
+	r ^= ror32(l, 2); \
 	l += r; \
 } while (0)
 
-
-static inline u32 michael_get32(u8 *data)
-{
-	return data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24);
-}
-
-
-static inline void michael_put32(u32 val, u8 *data)
-{
-	data[0] = val & 0xff;
-	data[1] = (val >> 8) & 0xff;
-	data[2] = (val >> 16) & 0xff;
-	data[3] = (val >> 24) & 0xff;
-}
-
-
 void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		 u8 *data, size_t data_len, u8 *mic)
 {
 	u32 l, r, val;
 	size_t block, blocks, left;
 
-	l = michael_get32(key);
-	r = michael_get32(key + 4);
+	l = get_unaligned_le32(key);
+	r = get_unaligned_le32(key + 4);
 
 	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
 	 * calculation, but it is _not_ transmitted */
-	l ^= michael_get32(da);
+	l ^= get_unaligned_le32(da);
 	michael_block(l, r);
-	l ^= da[4] | (da[5] << 8) | (sa[0] << 16) | (sa[1] << 24);
+	l ^= get_unaligned_le16(&da[4]) | (get_unaligned_le16(sa) << 16);
 	michael_block(l, r);
-	l ^= michael_get32(&sa[2]);
+	l ^= get_unaligned_le32(&sa[2]);
 	michael_block(l, r);
 	l ^= priority;
 	michael_block(l, r);
@@ -82,7 +50,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 	left = data_len % 4;
 
 	for (block = 0; block < blocks; block++) {
-		l ^= michael_get32(&data[block * 4]);
+		l ^= get_unaligned_le32(&data[block * 4]);
 		michael_block(l, r);
 	}
 
@@ -99,6 +67,6 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 	/* last block is zero, so l ^ 0 = l */
 	michael_block(l, r);
 
-	michael_put32(l, mic);
-	michael_put32(r, mic + 4);
+	put_unaligned_le32(l, mic);
+	put_unaligned_le32(r, mic + 4);
 }
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

