From: akpm@linux-foundation.org
Subject: [merged]
 fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 14:28:05 -0700
Message-ID: <534469e5.a5NLfzFpSxa6M+gp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbaDHV2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be

Subject: [merged] fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch removed from -mm tree
To: fabf@skynet.be,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:28:05 -0700


The patch titled
     Subject: fs/affs/dir.c: unlock/brelse dir on failure + code clean-up
has been removed from the -mm tree.  Its filename was
     fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

