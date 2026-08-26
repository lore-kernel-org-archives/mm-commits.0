Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B127488DBA;
	Wed, 26 Aug 2026 21:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787781423; cv=none; b=jWMPzonKm99BbPXPIQ0MOvDfe48Q/z8RUkBtUcU7S0O0wP9CZr2pg4ebldVeRR1MVLuG2PScSBa8GSqs6T4H1RzZmRqmjAUJw71XzI7m/8jxz6GHFqPDsSWU/Uyb0yjXkkDPmljXpm9sFhMk/WIUZ0WVSxqoeQUDCS3XroEDdDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787781423; c=relaxed/simple;
	bh=NrsEobShx9WZVwMcuUeChevlYDjtgqNUDlV0oqsa/sI=;
	h=Date:To:From:Subject:Message-Id; b=sG8KjG2xiIZWTpl7nH/B31B3/qIs59Wn2lbzfCYvu/QmCguXsbUiWaIK6lC6os/Dl/LXgOX6vxrfeEcIi9fjRSJVB8dEWeEdIbUx64uFLzKz/nrQR9UjI9G91PbXYZUDQx4OTBHZGkDEKZbLi+z/TdZ1uZPVMS9F1ciO0cZuZxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SG3Sj56T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SG3Sj56T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7B91F000E9;
	Wed, 26 Aug 2026 21:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787781419;
	bh=BSU19ZZsEPOek3tW4eX1/YaFsOMv7mNnDNXm5YPCxrM=;
	h=Date:To:From:Subject;
	b=SG3Sj56TC3kSKDc5sD3UR/YSyJG5aj7ouuU+24sbvxBukc3Cp0bWcvi9HBkEnYzu6
	 gh6deQuY155fJBdPLWtjcuqzn8bniYt1TVbC35Yz6QhQJjDtPuaVAbulcNR3Raqw6u
	 5FQIJ3a9dU4QryR5piLZWx6xBY+eLsx0GalkQFrA=
Date: Wed, 26 Aug 2026 14:56:58 -0700
To: mm-commits@vger.kernel.org,yuantan098@gmail.com,yifanwucs@gmail.com,tomapufckgml@gmail.com,stable@vger.kernel.org,prcups@krgm.moe,n05ec@lzu.edu.cn,bird@lzu.edu.cn,hirofumi@mail.parknet.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-fix-fat_ent_write-for-reverting-the-value.patch added to mm-nonmm-unstable branch
Message-Id: <20260826215659.4C7B91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: fix fat_ent_write() for reverting the value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-fix-fat_ent_write-for-reverting-the-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-fix-fat_ent_write-for-reverting-the-value.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix fat_ent_write() for reverting the value
Date: Tue, 25 Aug 2026 21:11:32 +0900

commit 64d9183203ee ("fat: restore original value when fat_ent_write
failed") try to revert the fatent value to old value when got the error on
mirror FAT.

However it didn't work if the error is when writing the fatent bh.  In
that case, the bh is cleared the uptodate flag, so reuse bh is invalid.

Fix this by reverting the fatent only if got the error on mirror FAT.

Link: https://lore.kernel.org/87ik4yz9fv.fsf_-_@mail.parknet.co.jp
Fixes: 64d9183203ee ("fat: restore original value when fat_ent_write failed")
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: syzbot+e64c6472a3d96a75172a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e64c6472a3d96a75172a
Reported-by: syzbot+26461e903494e689c24f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=26461e903494e689c24f
Cc: Yemu Lu <prcups@krgm.moe>
Cc: Ren Wei <n05ec@lzu.edu.cn>
Cc: Yuan Tan <yuantan098@gmail.com>
Cc: Yifan Wu <yifanwucs@gmail.com>
Cc: Juefei Pu <tomapufckgml@gmail.com>
Cc: Xin Liu <bird@lzu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h    |    2 +-
 fs/fat/fatent.c |   21 ++++++++++++++++++---
 fs/fat/file.c   |    3 ++-
 fs/fat/misc.c   |    6 ++----
 4 files changed, 23 insertions(+), 9 deletions(-)

--- a/fs/fat/fatent.c~fat-fix-fat_ent_write-for-reverting-the-value
+++ a/fs/fat/fatent.c
@@ -413,7 +413,7 @@ error:
 }
 
 int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
-		  int new, int wait)
+		  int new, int old, int wait)
 {
 	struct super_block *sb = inode->i_sb;
 	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
@@ -422,10 +422,25 @@ int fat_ent_write(struct inode *inode, s
 	ops->ent_put(fatent, new);
 	if (wait) {
 		err = fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
-		if (err)
+		if (err) {
+			/*
+			 * bhs are not uptodate after I/O error. So we
+			 * can't simply re-dirty to revert. And it
+			 * would not have value to write again on I/O
+			 * error.
+			 */
 			return err;
+		}
 	}
-	return fat_mirror_bhs(sb, fatent->bhs, fatent->nr_bhs);
+
+	err = fat_mirror_bhs(sb, fatent->bhs, fatent->nr_bhs);
+	if (err) {
+		/* Try to revert if got the error on mirror FAT */
+		ops->ent_put(fatent, old);
+		if (wait)
+			fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
+	}
+	return err;
 }
 
 static inline int fat_ent_next(struct msdos_sb_info *sbi,
--- a/fs/fat/fat.h~fat-fix-fat_ent_write-for-reverting-the-value
+++ a/fs/fat/fat.h
@@ -392,7 +392,7 @@ extern void fat_ent_access_init(struct s
 extern int fat_ent_read(struct inode *inode, struct fat_entry *fatent,
 			int entry);
 extern int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
-			 int new, int wait);
+			 int new, int old, int wait);
 extern int fat_alloc_clusters(struct inode *inode, int *cluster,
 			      int nr_cluster);
 extern int fat_free_clusters(struct inode *inode, int cluster);
--- a/fs/fat/file.c~fat-fix-fat_ent_write-for-reverting-the-value
+++ a/fs/fat/file.c
@@ -364,7 +364,8 @@ static int fat_free(struct inode *inode,
 				     __func__, MSDOS_I(inode)->i_pos);
 			ret = -EIO;
 		} else if (ret > 0) {
-			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, wait);
+			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, ret,
+					    wait);
 			if (err)
 				ret = err;
 		}
--- a/fs/fat/misc.c~fat-fix-fat_ent_write-for-reverting-the-value
+++ a/fs/fat/misc.c
@@ -133,11 +133,9 @@ int fat_chain_add(struct inode *inode, i
 		ret = fat_ent_read(inode, &fatent, last);
 		if (ret >= 0) {
 			int wait = inode_needs_sync(inode);
-			int old = ret;
 
-			ret = fat_ent_write(inode, &fatent, new_dclus, wait);
-			if (ret < 0)
-				fat_ent_write(inode, &fatent, old, wait);
+			ret = fat_ent_write(inode, &fatent, new_dclus, ret,
+					    wait);
 			fatent_brelse(&fatent);
 		}
 		if (ret < 0)
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-fat_ent_write-for-reverting-the-value.patch

