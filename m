From: akpm@linux-foundation.org
Subject: + fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch added to -mm tree
Date: Wed, 09 Apr 2014 13:59:23 -0700
Message-ID: <5345b4ab.MPWHINiugrwWHftD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDIU7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 16:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 13:59:23 -0700


The patch titled
     Subject: fs/befs/linuxvfs.c: replace strncpy by strlcpy
has been added to the -mm tree.  Its filename is
     fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch

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
Subject: fs/befs/linuxvfs.c: replace strncpy by strlcpy

strncpy + end of string assignment replaced by strlcpy

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-replace-strncpy-by-strlcpy fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-replace-strncpy-by-strlcpy
+++ a/fs/befs/linuxvfs.c
@@ -396,9 +396,8 @@ static struct inode *befs_iget(struct su
 	if (S_ISLNK(inode->i_mode) && !(befs_ino->i_flags & BEFS_LONG_SYMLINK)){
 		inode->i_size = 0;
 		inode->i_blocks = befs_sb->block_size / VFS_BLOCK_SIZE;
-		strncpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
-			BEFS_SYMLINK_LEN - 1);
-		befs_ino->i_data.symlink[BEFS_SYMLINK_LEN - 1] = '\0';
+		strlcpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
+			BEFS_SYMLINK_LEN);
 	} else {
 		int num_blks;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

