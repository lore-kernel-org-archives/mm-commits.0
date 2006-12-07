From: akpm@osdl.org
Subject: - autofs-fix-error-code-path-in-autofs_fill_sb-fix.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:37:56 -0800
Message-ID: <200612070337.kB73bvRQ027587@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968053AbWLGDiE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:38:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     autofs-fix-error-code-path-in-autofs_fill_sb fix
has been removed from the -mm tree.  Its filename was
     autofs-fix-error-code-path-in-autofs_fill_sb-fix.patch

This patch was dropped because it was folded into autofs-fix-error-code-path-in-autofs_fill_sb.patch

------------------------------------------------------
Subject: autofs-fix-error-code-path-in-autofs_fill_sb fix
From: Ian Kent <raven@themaw.net>

Update descriptive comment also.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/autofs/inode.c  |    3 ++-
 fs/autofs4/inode.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/autofs/inode.c~autofs-fix-error-code-path-in-autofs_fill_sb-fix fs/autofs/inode.c
--- a/fs/autofs/inode.c~autofs-fix-error-code-path-in-autofs_fill_sb-fix
+++ a/fs/autofs/inode.c
@@ -28,7 +28,8 @@ void autofs_kill_sb(struct super_block *
 	/*
 	 * In the event of a failure in get_sb_nodev the superblock
 	 * info is not present so nothing else has been setup, so
-	 * just exit when we are called from deactivate_super.
+	 * just call kill_anon_super when we are called from
+	 * deactivate_super.
 	 */
 	if (!sbi)
 		goto out_kill_sb;
diff -puN fs/autofs4/inode.c~autofs-fix-error-code-path-in-autofs_fill_sb-fix fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs-fix-error-code-path-in-autofs_fill_sb-fix
+++ a/fs/autofs4/inode.c
@@ -152,7 +152,8 @@ void autofs4_kill_sb(struct super_block 
 	/*
 	 * In the event of a failure in get_sb_nodev the superblock
 	 * info is not present so nothing else has been setup, so
-	 * just exit when we are called from deactivate_super.
+	 * just call kill_anon_super when we are called from
+	 * deactivate_super.
 	 */
 	if (!sbi)
 		goto out_kill_sb;
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-fix-error-code-path-in-autofs_fill_sb.patch
autofs-fix-error-code-path-in-autofs_fill_sb-fix.patch

