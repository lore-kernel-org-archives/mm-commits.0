From: akpm@linux-foundation.org
Subject: + fat-kill-d_invalidate-in-vfat_lookup.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:38 -0700
Message-ID: <200810162207.m9GM7cmN028085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756164AbYJPWHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: Kill d_invalidate() in vfat_lookup()
has been added to the -mm tree.  Its filename is
     fat-kill-d_invalidate-in-vfat_lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Kill d_invalidate() in vfat_lookup()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

d_invalidate() for positive dentry doesn't work in some cases
(vfsmount, nfsd, and maybe others). shrink_dcache_parent() by
d_invalidate() is pointless for vfat usage at all.

So, this kills it, and intead of it uses d_move().

To save old behavior, this returns alias simply for directory (don't
change pwd, etc..). the directory lookup shouldn't be important for
performance.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/fat/namei_vfat.c~fat-kill-d_invalidate-in-vfat_lookup fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-kill-d_invalidate-in-vfat_lookup
+++ a/fs/fat/namei_vfat.c
@@ -745,13 +745,12 @@ static struct dentry *vfat_lookup(struct
 		 *
 		 * Switch to new one for reason of locality if possible.
 		 */
-		if (d_invalidate(alias) == 0)
-			dput(alias);
-		else {
-			iput(inode);
-			unlock_super(sb);
-			return alias;
-		}
+		BUG_ON(d_unhashed(alias));
+		if (!S_ISDIR(inode->i_mode))
+			d_move(alias, dentry);
+		iput(inode);
+		unlock_super(sb);
+		return alias;
 	}
 out:
 	unlock_super(sb);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

