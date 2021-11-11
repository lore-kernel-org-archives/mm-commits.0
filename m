Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34799C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB536103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhKKC43 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234599AbhKKC43 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBA0361075;
        Thu, 11 Nov 2021 02:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599221;
        bh=XgOo2wC4b1paosH2pAMNeJRy3JDdl3KHmpYR70Odxls=;
        h=Date:From:To:Subject:From;
        b=UACCcZ/NzOk2rp0eiid5xnonH7huZfVnF9P7ix68YlO3CL5CXvUMLldAVn+x4Eu9V
         keUmDGTGzoFglFafNm8+Ar/8Vrw3hhVygNpA8sVmR4QWhojYAyYZmYrgrXAIk2di9d
         OnhwdOboZRGIG8PfuhXh02pSGoRH1M6jdXjAOgM8=
Date:   Wed, 10 Nov 2021 18:53:40 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, christian.brauner@ubuntu.com,
        gregkh@linuxfoundation.org, jack@suse.cz,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged] hfs-hfsplus-use-warn_on-for-sanity-check.patch
 removed from -mm tree
Message-ID: <20211111025340.vJ_SYUHb_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs/hfsplus: use WARN_ON for sanity check
has been removed from the -mm tree.  Its filename was
     hfs-hfsplus-use-warn_on-for-sanity-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kasan-test-use-underlying-string-helpers.patch

