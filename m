From: akpm@linux-foundation.org
Subject: + include-use-get-put_unaligned_-helpers.patch added to -mm tree
Date: Fri, 02 May 2008 16:09:36 -0700
Message-ID: <200805022309.m42N9aXI019871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932535AbYEBXTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linville@tuxdriver.com


The patch titled
     include: use get/put_unaligned_* helpers
has been added to the -mm tree.  Its filename is
     include-use-get-put_unaligned_-helpers.patch

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
Subject: include: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reiserfs_fs.h      |    4 ++--
 include/linux/smb_fs.h           |   19 +++++++------------
 include/net/ieee80211_radiotap.h |    2 +-
 3 files changed, 10 insertions(+), 15 deletions(-)

diff -puN include/linux/reiserfs_fs.h~include-use-get-put_unaligned_-helpers include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~include-use-get-put_unaligned_-helpers
+++ a/include/linux/reiserfs_fs.h
@@ -526,8 +526,8 @@ struct item_head {
 ** p is the array of __u32, i is the index into the array, v is the value
 ** to store there.
 */
-#define get_block_num(p, i) le32_to_cpu(get_unaligned((p) + (i)))
-#define put_block_num(p, i, v) put_unaligned(cpu_to_le32(v), (p) + (i))
+#define get_block_num(p, i) get_unaligned_le32((p) + (i))
+#define put_block_num(p, i, v) put_unaligned_le32((v), (p) + (i))
 
 //
 // in old version uniqueness field shows key type
diff -puN include/linux/smb_fs.h~include-use-get-put_unaligned_-helpers include/linux/smb_fs.h
--- a/include/linux/smb_fs.h~include-use-get-put_unaligned_-helpers
+++ a/include/linux/smb_fs.h
@@ -43,18 +43,13 @@ static inline struct smb_inode_info *SMB
 }
 
 /* macro names are short for word, double-word, long value (?) */
-#define WVAL(buf,pos) \
-	(le16_to_cpu(get_unaligned((__le16 *)((u8 *)(buf) + (pos)))))
-#define DVAL(buf,pos) \
-	(le32_to_cpu(get_unaligned((__le32 *)((u8 *)(buf) + (pos)))))
-#define LVAL(buf,pos) \
-	(le64_to_cpu(get_unaligned((__le64 *)((u8 *)(buf) + (pos)))))
-#define WSET(buf,pos,val) \
-	put_unaligned(cpu_to_le16((u16)(val)), (__le16 *)((u8 *)(buf) + (pos)))
-#define DSET(buf,pos,val) \
-	put_unaligned(cpu_to_le32((u32)(val)), (__le32 *)((u8 *)(buf) + (pos)))
-#define LSET(buf,pos,val) \
-	put_unaligned(cpu_to_le64((u64)(val)), (__le64 *)((u8 *)(buf) + (pos)))
+#define WVAL(buf, pos) (get_unaligned_le16((u8 *)(buf) + (pos)))
+#define DVAL(buf, pos) (get_unaligned_le32((u8 *)(buf) + (pos)))
+#define LVAL(buf, pos) (get_unaligned_le64((u8 *)(buf) + (pos)))
+
+#define WSET(buf, pos, val) put_unaligned_le16((val), (u8 *)(buf) + (pos))
+#define DSET(buf, pos, val) put_unaligned_le32((val), (u8 *)(buf) + (pos))
+#define LSET(buf, pos, val) put_unaligned_le64((val), (u8 *)(buf) + (pos))
 
 /* where to find the base of the SMB packet proper */
 #define smb_base(buf) ((u8 *)(((u8 *)(buf))+4))
diff -puN include/net/ieee80211_radiotap.h~include-use-get-put_unaligned_-helpers include/net/ieee80211_radiotap.h
--- a/include/net/ieee80211_radiotap.h~include-use-get-put_unaligned_-helpers
+++ a/include/net/ieee80211_radiotap.h
@@ -262,7 +262,7 @@ static inline int ieee80211_get_radiotap
 	struct ieee80211_radiotap_header *hdr =
 		(struct ieee80211_radiotap_header *)data;
 
-	return le16_to_cpu(get_unaligned(&hdr->it_len));
+	return get_unaligned_le16(&hdr->it_len);
 }
 
 #endif				/* IEEE80211_RADIOTAP_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
input-ff-memlessc-use-clamp_val-macro.patch
ata-remove-fit-macro.patch
ide-eliminate-fit-macro.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
git-mips.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
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
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
lib-add-ascii-hex-helper-functions.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
cris-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
frv-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch
sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
block-use-get_unaligned_-helpers.patch
ide-use-get_unaligned_-helpers.patch
media-use-get_unaligned_-helpers.patch
scsi-use-get_unaligned_-helpers.patch
usb-use-get_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
irda-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
bluetooth-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch

