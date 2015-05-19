From: akpm@linux-foundation.org
Subject: + fs-affs-symlinkc-remove-unneeded-err-variable.patch added to
 -mm tree
Date: Tue, 19 May 2015 15:44:18 -0700
Message-ID: <555bbcc2.ue1M7VsU9Ro9DSdm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbESWoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 18:44:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/symlink.c: remove unneeded err variable
has been added to the -mm tree.  Its filename is
     fs-affs-symlinkc-remove-unneeded-err-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-symlinkc-remove-unneeded-err-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-symlinkc-remove-unneeded-err-variable.patch

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
Subject: fs/affs/symlink.c: remove unneeded err variable

err is only assigned to -EIO.  Return that value at the end of fail
context.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/symlink.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/affs/symlink.c~fs-affs-symlinkc-remove-unneeded-err-variable fs/affs/symlink.c
--- a/fs/affs/symlink.c~fs-affs-symlinkc-remove-unneeded-err-variable
+++ a/fs/affs/symlink.c
@@ -16,14 +16,12 @@ static int affs_symlink_readpage(struct
 	struct inode *inode = page->mapping->host;
 	char *link = kmap(page);
 	struct slink_front *lf;
-	int err;
 	int			 i, j;
 	char			 c;
 	char			 lc;
 
 	pr_debug("follow_link(ino=%lu)\n", inode->i_ino);
 
-	err = -EIO;
 	bh = affs_bread(inode->i_sb, inode->i_ino);
 	if (!bh)
 		goto fail;
@@ -66,7 +64,7 @@ fail:
 	SetPageError(page);
 	kunmap(page);
 	unlock_page(page);
-	return err;
+	return -EIO;
 }
 
 const struct address_space_operations affs_symlink_aops = {
_

Patches currently in -mm which might be from fabf@skynet.be are

configfs-unexport-make-static-config_item_init.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-btreec-remove-unneeded-initializations.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-symlinkc-remove-unneeded-err-variable.patch
linux-next.patch

