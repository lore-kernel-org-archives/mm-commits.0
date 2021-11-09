Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1AFC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8C186137F
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbhKIChu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKICht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70B7961360;
        Tue,  9 Nov 2021 02:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425304;
        bh=HgisFEDPx0YJCt/gW3EYKKnZ1cU9Y83gzSp3obUEoJM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nJV6gCv+IGXRZ2iGW0gFanPke3fD8QlQKzefRJPk+gb9pjfgU3lhdKy74/iyfnKOf
         h8yBd2HICKz34CC7UmbknJTFxY4TadsBz4JKQgM/4Dt73/NwPx0I/vRLjhBbJpoH/V
         UZzFZbdpYZ51we6xPgfkuX53HRy5Nauyu+4Y5lTY=
Date:   Mon, 08 Nov 2021 18:35:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de,
        christian.brauner@ubuntu.com, gregkh@linuxfoundation.org,
        jack@suse.cz, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 68/87] hfs/hfsplus: use WARN_ON for sanity check
Message-ID: <20211109023504.Vmq9yiyZe%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
