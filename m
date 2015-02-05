From: akpm@linux-foundation.org
Subject: + fs-affs-use-unsigned-int-for-string-lengths.patch added to -mm
 tree
Date: Thu, 05 Feb 2015 15:19:16 -0800
Message-ID: <54d3fa74.RphpO5yWGPTzcu4B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbbBEXTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2015 18:19:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: use unsigned int for string lengths
has been added to the -mm tree.  Its filename is
     fs-affs-use-unsigned-int-for-string-lengths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-use-unsigned-int-for-string-lengths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-use-unsigned-int-for-string-lengths.patch

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
Subject: fs/affs: use unsigned int for string lengths

- Some min() were used with different types.

- Create a new variable in __affs_hash_dentry() to process
  affs_check_name()/min() return

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    2 +-
 fs/affs/namei.c    |   15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/affs/amigaffs.c~fs-affs-use-unsigned-int-for-string-lengths fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-use-unsigned-int-for-string-lengths
+++ a/fs/affs/amigaffs.c
@@ -508,7 +508,7 @@ affs_check_name(const unsigned char *nam
 int
 affs_copy_name(unsigned char *bstr, struct dentry *dentry)
 {
-	int len = min(dentry->d_name.len, 30u);
+	u32 len = min(dentry->d_name.len, 30u);
 
 	*bstr++ = len;
 	memcpy(bstr, dentry->d_name.name, len);
diff -puN fs/affs/namei.c~fs-affs-use-unsigned-int-for-string-lengths fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-use-unsigned-int-for-string-lengths
+++ a/fs/affs/namei.c
@@ -64,15 +64,16 @@ __affs_hash_dentry(struct qstr *qstr, to
 {
 	const u8 *name = qstr->name;
 	unsigned long hash;
-	int i;
+	int retval;
+	u32 len;
 
-	i = affs_check_name(qstr->name, qstr->len, notruncate);
-	if (i)
-		return i;
+	retval = affs_check_name(qstr->name, qstr->len, notruncate);
+	if (retval)
+		return retval;
 
 	hash = init_name_hash();
-	i = min(qstr->len, 30u);
-	for (; i > 0; name++, i--)
+	len = min(qstr->len, 30u);
+	for (; len > 0; name++, len--)
 		hash = partial_name_hash(toupper(*name), hash);
 	qstr->hash = end_name_hash(hash);
 
@@ -173,7 +174,7 @@ int
 affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len)
 {
 	toupper_t toupper = affs_get_toupper(sb);
-	int hash;
+	u32 hash;
 
 	hash = len = min(len, 30u);
 	for (; len > 0; len--)
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

