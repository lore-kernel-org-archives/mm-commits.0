From: akpm@linux-foundation.org
Subject: + fs-hfsplus-atomically-set-inode-i_flags.patch added to -mm tree
Date: Thu, 12 Mar 2015 13:57:14 -0700
Message-ID: <5501fdaa.3+q+uK1eD04DQHbd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbbCLU5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfsplus: atomically set inode->i_flags
has been added to the -mm tree.  Its filename is
     fs-hfsplus-atomically-set-inode-i_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfsplus-atomically-set-inode-i_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfsplus-atomically-set-inode-i_flags.patch

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
Subject: fs/hfsplus: atomically set inode->i_flags

According to commit 5f16f3225b06

("ext4: atomically set inode->i_flags in ext4_set_inode_flags()")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/ioctl.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/hfsplus/ioctl.c~fs-hfsplus-atomically-set-inode-i_flags fs/hfsplus/ioctl.c
--- a/fs/hfsplus/ioctl.c~fs-hfsplus-atomically-set-inode-i_flags
+++ a/fs/hfsplus/ioctl.c
@@ -76,7 +76,7 @@ static int hfsplus_ioctl_setflags(struct
 {
 	struct inode *inode = file_inode(file);
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
-	unsigned int flags;
+	unsigned int flags, new_fl = 0;
 	int err = 0;
 
 	err = mnt_want_write_file(file);
@@ -110,14 +110,12 @@ static int hfsplus_ioctl_setflags(struct
 	}
 
 	if (flags & FS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
-	else
-		inode->i_flags &= ~S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 
 	if (flags & FS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
-	else
-		inode->i_flags &= ~S_APPEND;
+		new_fl |= S_APPEND;
+
+	inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
 
 	if (flags & FS_NODUMP_FL)
 		hip->userflags |= HFSPLUS_FLG_NODUMP;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch
fs-hfsplus-atomically-set-inode-i_flags.patch
fs-affs-use-affs_mount-prefix-for-mount-options.patch
fs-affs-affsh-add-mount-option-manipulation-macros.patch
fs-affs-superc-use-affs_set_opt.patch
fs-affs-use-affs_test_opt.patch
linux-next.patch

