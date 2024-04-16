Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3AF1384AD;
	Tue, 16 Apr 2024 22:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307236; cv=none; b=tZ+B2a2oOoeVJRKDydf6sNo0YjXztK8nmP8u//gddWrI2yJkU2vctuNPOWdFH5i7b8mDYl5XT3YWWVD9RobJuzptNTD44vZef3RAQ07JryPBIfKnKZW0lxTDvrt9k0hl55blF95JwoEYGhObg3Mnf5CRzJLQ3FJ/MX7yoywYaTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307236; c=relaxed/simple;
	bh=gQV0H/+4hMv3qKKvIgPuZe8r0gEnMx7SC9eIfguRW3c=;
	h=Date:To:From:Subject:Message-Id; b=ChikK6T8F8CoNYaB9tvqQ5gfQNKFLH+CdIpkJxRBkg90OAIZG8x5D1ihUWAAz+QWGPff8Kq6qfHZOxzAnc3iyVFFXLnrfYiFYyDEVgJfnxSrb8Jv7EzxbnugoIxmXXgi6JzBFPhVU+7lKRSZTqmrrF3SWcM3wIotn6sl/4pX8MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XGTSRmQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGTSRmQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F28DC113CE;
	Tue, 16 Apr 2024 22:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307236;
	bh=gQV0H/+4hMv3qKKvIgPuZe8r0gEnMx7SC9eIfguRW3c=;
	h=Date:To:From:Subject:From;
	b=XGTSRmQTyHsaoyAw9bmTPBuZuEuow9H6qW+QbPIsaWtky5akfLxCsweHi7sfp59bP
	 4LEkbMS73cCx4yrXSFRhzF5WiDUNav3i73o+IgN70beYlXpUGRNgDOuNs5+EDwAXkb
	 7c/yQbka42862Rvw5LvdWYKVAoou1ilo6HX9i7Zw=
Date: Tue, 16 Apr 2024 15:40:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-oob-in-nilfs_set_de_type.patch removed from -mm tree
Message-Id: <20240416224036.8F28DC113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix OOB in nilfs_set_de_type
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-oob-in-nilfs_set_de_type.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeongjun Park <aha310510@gmail.com>
Subject: nilfs2: fix OOB in nilfs_set_de_type
Date: Tue, 16 Apr 2024 03:20:48 +0900

The size of the nilfs_type_by_mode array in the fs/nilfs2/dir.c file is
defined as "S_IFMT >> S_SHIFT", but the nilfs_set_de_type() function,
which uses this array, specifies the index to read from the array in the
same way as "(mode & S_IFMT) >> S_SHIFT".

static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode
 *inode)
{
	umode_t mode = inode->i_mode;

	de->file_type = nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT]; // oob
}

However, when the index is determined this way, an out-of-bounds (OOB)
error occurs by referring to an index that is 1 larger than the array size
when the condition "mode & S_IFMT == S_IFMT" is satisfied.  Therefore, a
patch to resize the nilfs_type_by_mode array should be applied to prevent
OOB errors.

Link: https://lkml.kernel.org/r/20240415182048.7144-1-konishi.ryusuke@gmail.com
Reported-by: syzbot+2e22057de05b9f3b30d8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e22057de05b9f3b30d8
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c~nilfs2-fix-oob-in-nilfs_set_de_type
+++ a/fs/nilfs2/dir.c
@@ -240,7 +240,7 @@ nilfs_filetype_table[NILFS_FT_MAX] = {
 
 #define S_SHIFT 12
 static unsigned char
-nilfs_type_by_mode[S_IFMT >> S_SHIFT] = {
+nilfs_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
 	[S_IFREG >> S_SHIFT]	= NILFS_FT_REG_FILE,
 	[S_IFDIR >> S_SHIFT]	= NILFS_FT_DIR,
 	[S_IFCHR >> S_SHIFT]	= NILFS_FT_CHRDEV,
_

Patches currently in -mm which might be from aha310510@gmail.com are


