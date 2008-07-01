From: akpm@linux-foundation.org
Subject: + autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch added to -mm tree
Date: Tue, 01 Jul 2008 11:01:02 -0700
Message-ID: <200807011801.m61I12jR007211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbYGASBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 14:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: fix symlink name allocation
has been added to the -mm tree.  Its filename is
     autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -772,6 +772,7 @@ static int autofs4_dir_symlink(struct in
 		list_del_init(&ino->active);
 	spin_unlock(&sbi->lookup_lock);
 
+	ino->size = strlen(symname);
 	cp = kmalloc(ino->size + 1, GFP_KERNEL);
 	if (!cp) {
 		if (!dentry->d_fsdata)
@@ -803,7 +804,6 @@ static int autofs4_dir_symlink(struct in
 		atomic_inc(&p_ino->count);
 	ino->inode = inode;
 
-	ino->size = strlen(symname);
 	ino->u.symlink = cp;
 	dir->i_mtime = CURRENT_TIME;
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-dont-make-expiring-dentry-negative.patch
autofs4-revert-redo-lookup-in-ttfd.patch
autofs4-use-look-aside-list-for-lookups.patch
autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch
autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
autofs4-use-struct-qstr-in-waitqc.patch
autofs4-fix-pending-mount-race.patch

