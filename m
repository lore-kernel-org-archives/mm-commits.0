Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2ABBC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F8A611EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbhI1AkP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238236AbhI1AkP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 20:40:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A41C60FC2;
        Tue, 28 Sep 2021 00:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632789516;
        bh=3vPkk77offL+QS8NcGFqi9OqRP217CFrpVdKyCdpItk=;
        h=Date:From:To:Subject:From;
        b=2Bh5c1nlFBDGjm4X51/ImiQ2QDM+DKXsYmSKwu8yn5YF0+CRYzSut4jQ2dKCV4XE6
         +xqzkg/GXbzipPciRzLnfl4lG8vL2n7qbufXjf3dJFktI+8EkhYZjhwx7ZdyYCp55A
         U9P0VFgdzb5nM5fjkS0i+p2Hh+SiNi0JxxVMqcS8=
Date:   Mon, 27 Sep 2021 17:38:36 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, christian.brauner@ubuntu.com,
        gregkh@linuxfoundation.org, jack@suse.cz,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  + hfs-hfsplus-use-warn_on-for-sanity-check.patch added to
 -mm tree
Message-ID: <20210928003836.7kUwWf8j6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs/hfsplus: use WARN_ON for sanity check
has been added to the -mm tree.  Its filename is
     hfs-hfsplus-use-warn_on-for-sanity-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hfs-hfsplus-use-warn_on-for-sanity-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hfs-hfsplus-use-warn_on-for-sanity-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: hfs/hfsplus: use WARN_ON for sanity check

gcc warns about a couple of instances in which a sanity check exists but
the author wasn't sure how to react to it failing, which makes it look
like a possible bug:

fs/hfsplus/inode.c: In function 'hfsplus_cat_read_inode':
fs/hfsplus/inode.c:503:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  503 |                         /* panic? */;
      |                                     ^
fs/hfsplus/inode.c:524:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  524 |                         /* panic? */;
      |                                     ^
fs/hfsplus/inode.c: In function 'hfsplus_cat_write_inode':
fs/hfsplus/inode.c:582:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  582 |                         /* panic? */;
      |                                     ^
fs/hfsplus/inode.c:608:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  608 |                         /* panic? */;
      |                                     ^
fs/hfs/inode.c: In function 'hfs_write_inode':
fs/hfs/inode.c:464:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  464 |                         /* panic? */;
      |                                     ^
fs/hfs/inode.c:485:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  485 |                         /* panic? */;
      |                                     ^

panic() is probably not the correct choice here, but a WARN_ON
seems appropriate and avoids the compile-time warning.

Link: https://lkml.kernel.org/r/20210927102149.1809384-1-arnd@kernel.org
Link: https://lore.kernel.org/all/20210322223249.2632268-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/inode.c     |    6 ++----
 fs/hfsplus/inode.c |   12 ++++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

--- a/fs/hfs/inode.c~hfs-hfsplus-use-warn_on-for-sanity-check
+++ a/fs/hfs/inode.c
@@ -462,8 +462,7 @@ int hfs_write_inode(struct inode *inode,
 		goto out;
 
 	if (S_ISDIR(main_inode->i_mode)) {
-		if (fd.entrylength < sizeof(struct hfs_cat_dir))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfs_cat_dir));
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_dir));
 		if (rec.type != HFS_CDR_DIR ||
@@ -483,8 +482,7 @@ int hfs_write_inode(struct inode *inode,
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 				sizeof(struct hfs_cat_file));
 	} else {
-		if (fd.entrylength < sizeof(struct hfs_cat_file))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfs_cat_file));
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_file));
 		if (rec.type != HFS_CDR_FIL ||
--- a/fs/hfsplus/inode.c~hfs-hfsplus-use-warn_on-for-sanity-check
+++ a/fs/hfsplus/inode.c
@@ -509,8 +509,7 @@ int hfsplus_cat_read_inode(struct inode
 	if (type == HFSPLUS_FOLDER) {
 		struct hfsplus_cat_folder *folder = &entry.folder;
 
-		if (fd->entrylength < sizeof(struct hfsplus_cat_folder))
-			/* panic? */;
+		WARN_ON(fd->entrylength < sizeof(struct hfsplus_cat_folder));
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		hfsplus_get_perms(inode, &folder->permissions, 1);
@@ -530,8 +529,7 @@ int hfsplus_cat_read_inode(struct inode
 	} else if (type == HFSPLUS_FILE) {
 		struct hfsplus_cat_file *file = &entry.file;
 
-		if (fd->entrylength < sizeof(struct hfsplus_cat_file))
-			/* panic? */;
+		WARN_ON(fd->entrylength < sizeof(struct hfsplus_cat_file));
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_file));
 
@@ -588,8 +586,7 @@ int hfsplus_cat_write_inode(struct inode
 	if (S_ISDIR(main_inode->i_mode)) {
 		struct hfsplus_cat_folder *folder = &entry.folder;
 
-		if (fd.entrylength < sizeof(struct hfsplus_cat_folder))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfsplus_cat_folder));
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		/* simple node checks? */
@@ -614,8 +611,7 @@ int hfsplus_cat_write_inode(struct inode
 	} else {
 		struct hfsplus_cat_file *file = &entry.file;
 
-		if (fd.entrylength < sizeof(struct hfsplus_cat_file))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfsplus_cat_file));
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 					sizeof(struct hfsplus_cat_file));
 		hfsplus_inode_write_fork(inode, &file->data_fork);
_

Patches currently in -mm which might be from arnd@arndb.de are

posix-acl-avoid-wempty-body-warning.patch
hfs-hfsplus-use-warn_on-for-sanity-check.patch

