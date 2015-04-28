From: akpm@linux-foundation.org
Subject: + fs-affs-amigaffsc-remove-unneeded-initialization.patch added to -mm tree
Date: Tue, 28 Apr 2015 13:50:56 -0700
Message-ID: <553ff2b0.f1uQ0EGYBlpn6f06%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965792AbbD1Uu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 16:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/amigaffs.c: remove unneeded initialization
has been added to the -mm tree.  Its filename is
     fs-affs-amigaffsc-remove-unneeded-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-amigaffsc-remove-unneeded-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-amigaffsc-remove-unneeded-initialization.patch

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
Subject: fs/affs/amigaffs.c: remove unneeded initialization

bh is initialized unconditionally in affs_remove_link()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/affs/amigaffs.c~fs-affs-amigaffsc-remove-unneeded-initialization fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-amigaffsc-remove-unneeded-initialization
+++ a/fs/affs/amigaffs.c
@@ -140,7 +140,7 @@ affs_remove_link(struct dentry *dentry)
 {
 	struct inode *dir, *inode = d_inode(dentry);
 	struct super_block *sb = inode->i_sb;
-	struct buffer_head *bh = NULL, *link_bh = NULL;
+	struct buffer_head *bh, *link_bh = NULL;
 	u32 link_ino, ino;
 	int retval;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-befs-btreec-remove-unneeded-initializations.patch

