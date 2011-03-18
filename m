From: akpm@linux-foundation.org
Subject: [wrecked] vfs-ignore-error-on-forced-remount.patch removed from -mm tree
Date: Fri, 18 Mar 2011 11:41:47 -0700
Message-ID: <201103181844.p2IIiTo2004644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333Ab1CRSoc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Mar 2011 14:44:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     vfs: ignore error on forced remount
has been removed from the -mm tree.  Its filename was
     vfs-ignore-error-on-forced-remount.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: ignore error on forced remount
From: Miklos Szeredi <mszeredi@suse.cz>

On emergency remount we want to force MS_RDONLY on the super block even if
->remount_fs() failed for some reason.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/super.c~vfs-ignore-error-on-forced-remount fs/super.c
--- a/fs/super.c~vfs-ignore-error-on-forced-remount
+++ a/fs/super.c
@@ -588,7 +588,8 @@ int do_remount_sb(struct super_block *sb
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval)
+		/* If forced remount, go ahead despite any errors */
+		if (retval && !force)
 			return retval;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
mm-add-replace_page_cache_page-function.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
vfs-keep-list-of-mounts-for-each-superblock.patch
vfs-protect-remounting-superblock-read-only.patch
vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch

