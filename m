From: akpm@linux-foundation.org
Subject: + fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
 added to -mm tree
Date: Fri, 28 Feb 2014 15:56:38 -0800
Message-ID: <53112236.o1JUpPgKG+kgtzhj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaB1X4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:56:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be

Subject: + fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch added to -mm tree
To: fabf@skynet.be,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:56:38 -0800


The patch titled
     Subject: fs/affs/dir.c: unlock/brelse dir on failure + code clean-up
has been added to the -mm tree.  Its filename is
     fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch

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
Subject: fs/affs/dir.c: unlock/brelse dir on failure + code clean-up

0edf977d2ae32b ("[readdir] convert affs") returns directly -EIO without
unlocking dir inode and releasing dir bh when second affs_bread sequence
fails.  This patch restores initial behaviour.It also fixes pr_debug and
affs_error to fit in 80 columns + removes reference to filldir (replaced
by dir_emit in the commit above).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/dir.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN fs/affs/dir.c~fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up fs/affs/dir.c
--- a/fs/affs/dir.c~fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up
+++ a/fs/affs/dir.c
@@ -52,8 +52,10 @@ affs_readdir(struct file *file, struct d
 	int			 hash_pos;
 	int			 chain_pos;
 	u32			 ino;
+	int			 error = 0;
 
-	pr_debug("AFFS: readdir(ino=%lu,f_pos=%lx)\n",inode->i_ino,(unsigned long)ctx->pos);
+	pr_debug("AFFS: readdir(ino=%lu,f_pos=%lx)\n",
+		 inode->i_ino, (unsigned long)ctx->pos);
 
 	if (ctx->pos < 2) {
 		file->private_data = (void *)0;
@@ -72,7 +74,7 @@ affs_readdir(struct file *file, struct d
 	}
 	dir_bh = affs_bread(sb, inode->i_ino);
 	if (!dir_bh)
-		goto readdir_out;
+		goto out_unlock_dir;
 
 	/* If the directory hasn't changed since the last call to readdir(),
 	 * we can jump directly to where we left off.
@@ -88,7 +90,8 @@ affs_readdir(struct file *file, struct d
 		fh_bh = affs_bread(sb, ino);
 		if (!fh_bh) {
 			affs_error(sb, "readdir","Cannot read block %d", i);
-			return -EIO;
+			error = -EIO;
+			goto out_brelse_dir;
 		}
 		ino = be32_to_cpu(AFFS_TAIL(sb, fh_bh)->hash_chain);
 		affs_brelse(fh_bh);
@@ -107,29 +110,34 @@ inside:
 		do {
 			fh_bh = affs_bread(sb, ino);
 			if (!fh_bh) {
-				affs_error(sb, "readdir","Cannot read block %d", ino);
+				affs_error(sb, "readdir",
+					   "Cannot read block %d", ino);
 				break;
 			}
 
 			namelen = min(AFFS_TAIL(sb, fh_bh)->name[0], (u8)30);
 			name = AFFS_TAIL(sb, fh_bh)->name + 1;
-			pr_debug("AFFS: readdir(): filldir(\"%.*s\", ino=%u), hash=%d, f_pos=%x\n",
+			pr_debug("AFFS: readdir(): dir_emit(\"%.*s\", "
+				 "ino=%u), hash=%d, f_pos=%x\n",
 				 namelen, name, ino, hash_pos, (u32)ctx->pos);
+
 			if (!dir_emit(ctx, name, namelen, ino, DT_UNKNOWN))
-				goto readdir_done;
+				goto done;
 			ctx->pos++;
 			ino = be32_to_cpu(AFFS_TAIL(sb, fh_bh)->hash_chain);
 			affs_brelse(fh_bh);
 			fh_bh = NULL;
 		} while (ino);
 	}
-readdir_done:
+done:
 	file->f_version = inode->i_version;
 	file->private_data = (void *)(long)ino;
+	affs_brelse(fh_bh);
 
-readdir_out:
+out_brelse_dir:
 	affs_brelse(dir_bh);
-	affs_brelse(fh_bh);
+
+out_unlock_dir:
 	affs_unlock_dir(inode);
-	return 0;
+	return error;
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

