From: akpm@linux-foundation.org
Subject: [merged] fs-affs-symlinkc-remove-unneeded-err-variable.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:58 -0700
Message-ID: <559adb32.eWBgrXBpCrSmw66A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbbGFTq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/symlink.c: remove unneeded err variable
has been removed from the -mm tree.  Its filename was
     fs-affs-symlinkc-remove-unneeded-err-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch

