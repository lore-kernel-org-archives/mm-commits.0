From: akpm@linux-foundation.org
Subject: + autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch added to -mm tree
Date: Wed, 22 Aug 2007 15:21:38 -0700
Message-ID: <200708222221.l7MMLcVD007722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934279AbXHVWVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 18:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4-reinstate-negatitive-timeout-of-mount-fails fix
has been added to the -mm tree.  Its filename is
     autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: autofs4-reinstate-negatitive-timeout-of-mount-fails fix
From: Ian Kent <raven@themaw.net>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN fs/autofs4/inode.c~autofs4-reinstate-negatitive-timeout-of-mount-fails-fix fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-reinstate-negatitive-timeout-of-mount-fails-fix
+++ a/fs/autofs4/inode.c
@@ -108,9 +108,7 @@ static void autofs4_force_release(struct
 	spin_lock(&sbi->rehash_lock);
 	list_for_each_safe(p, next, &sbi->rehash_list) {
 		struct autofs_info *ino;
-		struct dentry *dentry;
 		ino = list_entry(p, struct autofs_info, rehash);
-		dentry = ino->dentry;
 		spin_unlock(&sbi->rehash_lock);
 		dput(ino->dentry);
 		spin_lock(&sbi->rehash_lock);
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-deadlock-during-create.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
autofs4-reinstate-negatitive-timeout-of-mount-fails.patch
autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch
