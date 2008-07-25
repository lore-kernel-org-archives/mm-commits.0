From: akpm@linux-foundation.org
Subject: - include-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:07 -0700
Message-ID: <200807252254.m6PMs7Pb002785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbYGYWyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     include: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     include-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
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
byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update.patch

