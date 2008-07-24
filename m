From: akpm@linux-foundation.org
Subject: - autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:13 -0700
Message-ID: <200807242329.m6ONTDcM011356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756668AbYGXX3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix symlink name allocation
has been removed from the -mm tree.  Its filename was
     autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix symlink name allocation
From: Ian Kent <raven@themaw.net>

The length of the symlink name has been moved but it needs to be set
before allocating space for it in the dentry info struct.  This corrects a
mistake in a recent patch.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/root.c~autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation
+++ a/fs/autofs4/root.c
@@ -775,6 +775,7 @@ static int autofs4_dir_symlink(struct in
 		list_del_init(&ino->active);
 	spin_unlock(&sbi->lookup_lock);
 
+	ino->size = strlen(symname);
 	cp = kmalloc(ino->size + 1, GFP_KERNEL);
 	if (!cp) {
 		if (!dentry->d_fsdata)
@@ -806,7 +807,6 @@ static int autofs4_dir_symlink(struct in
 		atomic_inc(&p_ino->count);
 	ino->inode = inode;
 
-	ino->size = strlen(symname);
 	ino->u.symlink = cp;
 	dir->i_mtime = CURRENT_TIME;
 
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

