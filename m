From: akpm@linux-foundation.org
Subject: - isofs-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:40 -0700
Message-ID: <200804300549.m3U5neUc030020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141AbYD3GBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     isofs: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     isofs-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isofs: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/isofs.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/isofs/isofs.h~isofs-use-get-put_unaligned_-helpers fs/isofs/isofs.h
--- a/fs/isofs/isofs.h~isofs-use-get-put_unaligned_-helpers
+++ a/fs/isofs/isofs.h
@@ -78,29 +78,29 @@ static inline int isonum_712(char *p)
 }
 static inline unsigned int isonum_721(char *p)
 {
-	return le16_to_cpu(get_unaligned((__le16 *)p));
+	return get_unaligned_le16(p);
 }
 static inline unsigned int isonum_722(char *p)
 {
-	return be16_to_cpu(get_unaligned((__le16 *)p));
+	return get_unaligned_be16(p);
 }
 static inline unsigned int isonum_723(char *p)
 {
 	/* Ignore bigendian datum due to broken mastering programs */
-	return le16_to_cpu(get_unaligned((__le16 *)p));
+	return get_unaligned_le16(p);
 }
 static inline unsigned int isonum_731(char *p)
 {
-	return le32_to_cpu(get_unaligned((__le32 *)p));
+	return get_unaligned_le32(p);
 }
 static inline unsigned int isonum_732(char *p)
 {
-	return be32_to_cpu(get_unaligned((__le32 *)p));
+	return get_unaligned_be32(p);
 }
 static inline unsigned int isonum_733(char *p)
 {
 	/* Ignore bigendian datum due to broken mastering programs */
-	return le32_to_cpu(get_unaligned((__le32 *)p));
+	return get_unaligned_le32(p);
 }
 extern int iso_date(char *, int);
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
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
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

