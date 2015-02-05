From: akpm@linux-foundation.org
Subject: + define-affsnamemax-to-replace-constant-use.patch added to -mm
 tree
Date: Thu, 05 Feb 2015 15:19:18 -0800
Message-ID: <54d3fa76.BULgFH088SDkTADx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbBEXTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2015 18:19:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: define AFFSNAMEMAX to replace constant use
has been added to the -mm tree.  Its filename is
     define-affsnamemax-to-replace-constant-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/define-affsnamemax-to-replace-constant-use.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/define-affsnamemax-to-replace-constant-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: define AFFSNAMEMAX to replace constant use

30 was used all over the place to compare name length against
AFFS maximum name length.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h     |    2 ++
 fs/affs/amigaffs.c |    6 +++---
 fs/affs/dir.c      |    3 ++-
 fs/affs/namei.c    |   16 ++++++++--------
 fs/affs/super.c    |    2 +-
 5 files changed, 16 insertions(+), 13 deletions(-)

diff -puN fs/affs/affs.h~define-affsnamemax-to-replace-constant-use fs/affs/affs.h
--- a/fs/affs/affs.h~define-affsnamemax-to-replace-constant-use
+++ a/fs/affs/affs.h
@@ -30,6 +30,8 @@
 #define AFFS_AC_SIZE		(AFFS_CACHE_SIZE/sizeof(struct affs_ext_key)/2)
 #define AFFS_AC_MASK		(AFFS_AC_SIZE-1)
 
+#define AFFSNAMEMAX 30U
+
 struct affs_ext_key {
 	u32	ext;				/* idx of the extended block */
 	u32	key;				/* block number */
diff -puN fs/affs/amigaffs.c~define-affsnamemax-to-replace-constant-use fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~define-affsnamemax-to-replace-constant-use
+++ a/fs/affs/amigaffs.c
@@ -483,11 +483,11 @@ affs_check_name(const unsigned char *nam
 {
 	int	 i;
 
-	if (len > 30) {
+	if (len > AFFSNAMEMAX) {
 		if (notruncate)
 			return -ENAMETOOLONG;
 		else
-			len = 30;
+			len = AFFSNAMEMAX;
 	}
 	for (i = 0; i < len; i++) {
 		if (name[i] < ' ' || name[i] == ':'
@@ -508,7 +508,7 @@ affs_check_name(const unsigned char *nam
 int
 affs_copy_name(unsigned char *bstr, struct dentry *dentry)
 {
-	u32 len = min(dentry->d_name.len, 30u);
+	u32 len = min(dentry->d_name.len, AFFSNAMEMAX);
 
 	*bstr++ = len;
 	memcpy(bstr, dentry->d_name.name, len);
diff -puN fs/affs/dir.c~define-affsnamemax-to-replace-constant-use fs/affs/dir.c
--- a/fs/affs/dir.c~define-affsnamemax-to-replace-constant-use
+++ a/fs/affs/dir.c
@@ -114,7 +114,8 @@ inside:
 				break;
 			}
 
-			namelen = min(AFFS_TAIL(sb, fh_bh)->name[0], (u8)30);
+			namelen = min(AFFS_TAIL(sb, fh_bh)->name[0],
+				      (u8)AFFSNAMEMAX);
 			name = AFFS_TAIL(sb, fh_bh)->name + 1;
 			pr_debug("readdir(): dir_emit(\"%.*s\", ino=%u), hash=%d, f_pos=%llx\n",
 				 namelen, name, ino, hash_pos, ctx->pos);
diff -puN fs/affs/namei.c~define-affsnamemax-to-replace-constant-use fs/affs/namei.c
--- a/fs/affs/namei.c~define-affsnamemax-to-replace-constant-use
+++ a/fs/affs/namei.c
@@ -72,7 +72,7 @@ __affs_hash_dentry(struct qstr *qstr, to
 		return retval;
 
 	hash = init_name_hash();
-	len = min(qstr->len, 30u);
+	len = min(qstr->len, AFFSNAMEMAX);
 	for (; len > 0; name++, len--)
 		hash = partial_name_hash(toupper(*name), hash);
 	qstr->hash = end_name_hash(hash);
@@ -115,10 +115,10 @@ static inline int __affs_compare_dentry(
 	 * If the names are longer than the allowed 30 chars,
 	 * the excess is ignored, so their length may differ.
 	 */
-	if (len >= 30) {
-		if (name->len < 30)
+	if (len >= AFFSNAMEMAX) {
+		if (name->len < AFFSNAMEMAX)
 			return 1;
-		len = 30;
+		len = AFFSNAMEMAX;
 	} else if (len != name->len)
 		return 1;
 
@@ -157,10 +157,10 @@ affs_match(struct dentry *dentry, const
 	const u8 *name = dentry->d_name.name;
 	int len = dentry->d_name.len;
 
-	if (len >= 30) {
-		if (*name2 < 30)
+	if (len >= AFFSNAMEMAX) {
+		if (*name2 < AFFSNAMEMAX)
 			return 0;
-		len = 30;
+		len = AFFSNAMEMAX;
 	} else if (len != *name2)
 		return 0;
 
@@ -176,7 +176,7 @@ affs_hash_name(struct super_block *sb, c
 	toupper_t toupper = affs_get_toupper(sb);
 	u32 hash;
 
-	hash = len = min(len, 30u);
+	hash = len = min(len, AFFSNAMEMAX);
 	for (; len > 0; len--)
 		hash = (hash * 13 + toupper(*name++)) & 0x7ff;
 
diff -puN fs/affs/super.c~define-affsnamemax-to-replace-constant-use fs/affs/super.c
--- a/fs/affs/super.c~define-affsnamemax-to-replace-constant-use
+++ a/fs/affs/super.c
@@ -584,7 +584,7 @@ affs_statfs(struct dentry *dentry, struc
 	buf->f_bavail  = free;
 	buf->f_fsid.val[0] = (u32)id;
 	buf->f_fsid.val[1] = (u32)(id >> 32);
-	buf->f_namelen = 30;
+	buf->f_namelen = AFFSNAMEMAX;
 	return 0;
 }
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
ocfs2-make-resv_lock-spinlock-static.patch
add-another-clock-for-use-with-the-soft-lockup-watchdog.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
fs-coda-dirc-forward-declaration-clean-up.patch
fs-ufs-superc-remove-unnecessary-casting.patch
fs-ufs-superc-fix-potential-race-condition.patch
fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
fs-affs-filec-replace-if-bug-by-bug_on.patch
fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
fs-affs-use-unsigned-int-for-string-lengths.patch
define-affsnamemax-to-replace-constant-use.patch
fs-affs-amigaffsc-remove-else-after-return.patch
fs-affs-bitmapc-remove-unnecessary-return.patch
fs-affs-inodec-remove-double-extern-affs_symlink_inode_operations.patch
fs-affs-superc-fix-switch-indentation.patch
linux-next.patch

