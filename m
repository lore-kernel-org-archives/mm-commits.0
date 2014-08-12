From: akpm@linux-foundation.org
Subject: [merged] fs-efs-nameic-return-is-not-a-function.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:38:12 -0700
Message-ID: <53ea6d24.9s1hZPI5kEdCmbS5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:56748 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaHLTiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:13 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so1308212ykb.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/efs/namei.c: return is not a function
has been removed from the -mm tree.  Its filename was
     fs-efs-nameic-return-is-not-a-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/efs/namei.c: return is not a function

Fix checkpatch errors:

"ERROR: return is not a function, parentheses are not required"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/namei.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/efs/namei.c~fs-efs-nameic-return-is-not-a-function fs/efs/namei.c
--- a/fs/efs/namei.c~fs-efs-nameic-return-is-not-a-function
+++ a/fs/efs/namei.c
@@ -12,7 +12,8 @@
 #include "efs.h"
 
 
-static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len) {
+static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len)
+{
 	struct buffer_head *bh;
 
 	int			slot, namelen;
@@ -40,10 +41,10 @@ static efs_ino_t efs_find_entry(struct i
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
 			pr_err("%s(): invalid directory block\n", __func__);
 			brelse(bh);
-			return(0);
+			return 0;
 		}
 
-		for(slot = 0; slot < dirblock->slots; slot++) {
+		for (slot = 0; slot < dirblock->slots; slot++) {
 			dirslot  = (struct efs_dentry *) (((char *) bh->b_data) + EFS_SLOTAT(dirblock, slot));
 
 			namelen  = dirslot->namelen;
@@ -52,12 +53,12 @@ static efs_ino_t efs_find_entry(struct i
 			if ((namelen == len) && (!memcmp(name, nameptr, len))) {
 				inodenum = be32_to_cpu(dirslot->inode);
 				brelse(bh);
-				return(inodenum);
+				return inodenum;
 			}
 		}
 		brelse(bh);
 	}
-	return(0);
+	return 0;
 }
 
 struct dentry *efs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

