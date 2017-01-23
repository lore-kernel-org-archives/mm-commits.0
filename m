From: akpm@linux-foundation.org
Subject: + hfs-atomically-read-inode-size.patch added to -mm tree
Date: Mon, 23 Jan 2017 14:22:42 -0800
Message-ID: <58868232.v+rb/URjEByiF0YY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdAWWWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: atomically read inode size
has been added to the -mm tree.  Its filename is
     hfs-atomically-read-inode-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfs-atomically-read-inode-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfs-atomically-read-inode-size.patch

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
Subject: hfs: atomically read inode size

See i_size_read() comments in include/linux/fs.h

Link: http://lkml.kernel.org/r/20170123175245.3272-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/mdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfs/mdb.c~hfs-atomically-read-inode-size fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-atomically-read-inode-size
+++ a/fs/hfs/mdb.c
@@ -38,7 +38,7 @@ static int hfs_get_last_session(struct s
 
 	/* default values */
 	*start = 0;
-	*size = sb->s_bdev->bd_inode->i_size >> 9;
+	*size = i_size_read(sb->s_bdev->bd_inode) >> 9;
 
 	if (HFS_SB(sb)->session >= 0) {
 		te.cdte_track = HFS_SB(sb)->session;
_

Patches currently in -mm which might be from fabf@skynet.be are

documentation-filesystems-proctxt-add-vmpin.patch
hfs-atomically-read-inode-size.patch
hfsplus-atomically-read-inode-size.patch
fs-affs-remove-reference-to-affs_parent_ino.patch
fs-affs-add-validation-block-function.patch
fs-affs-make-affs-exportable.patch
fs-affs-use-octal-for-permissions.patch
fs-affs-add-prefix-to-some-functions.patch
fs-affs-nameic-forward-declarations-clean-up.patch
fs-affs-make-export-work-with-cold-dcache.patch
fs-add-i_blocksize.patch

