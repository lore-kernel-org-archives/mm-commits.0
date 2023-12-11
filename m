Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E2179D8
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z70mLbaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9739C433C7;
	Mon, 11 Dec 2023 01:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257759;
	bh=Y2+4A5xe8gCIP7VTvyJnG+KiCkHLdBgkc7i8JwWwjeU=;
	h=Date:To:From:Subject:From;
	b=z70mLbaWVAN2nNkRfeIpdZYvcVoC3NMQfMS9Kg6R4XLk+jJNlcpWDW1RWdbOeHLF6
	 DMUJMMRafnYVq5CPk/ChmS+cXXhi42o7Rp5II8udXCMnv6pOcqCX7fbzplHlyQ+afW
	 0h8RFTAX2FAD+0+/bjt7Q9Qik3cbeNx65rHrKSMA=
Date: Sun, 10 Dec 2023 17:22:38 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-fix-variable-overflow-triggered-by-sysbot.patch removed from -mm tree
Message-Id: <20231211012238.E9739C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: fix variable overflow triggered by sysbot
has been removed from the -mm tree.  Its filename was
     squashfs-fix-variable-overflow-triggered-by-sysbot.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix variable overflow triggered by sysbot
Date: Mon, 13 Nov 2023 16:09:01 +0000

Sysbot reports a slab out of bounds write in squashfs_readahead().

This is ultimately caused by a file reporting an (infeasibly) large file
size (1407374883553280 bytes) with the minimum block size of 4K.

This causes variable overflow.

Link: https://lkml.kernel.org/r/20231113160901.6444-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+604424eb051c2f696163@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000b1fda20609ede0d1@google.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c        |    3 ++-
 fs/squashfs/file_direct.c |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c~squashfs-fix-variable-overflow-triggered-by-sysbot
+++ a/fs/squashfs/file.c
@@ -544,7 +544,8 @@ static void squashfs_readahead(struct re
 	struct squashfs_page_actor *actor;
 	unsigned int nr_pages = 0;
 	struct page **pages;
-	int i, file_end = i_size_read(inode) >> msblk->block_log;
+	int i;
+	loff_t file_end = i_size_read(inode) >> msblk->block_log;
 	unsigned int max_pages = 1UL << shift;
 
 	readahead_expand(ractl, start, (len | mask) + 1);
--- a/fs/squashfs/file_direct.c~squashfs-fix-variable-overflow-triggered-by-sysbot
+++ a/fs/squashfs/file_direct.c
@@ -26,10 +26,10 @@ int squashfs_readpage_block(struct page
 	struct inode *inode = target_page->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 
-	int file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
+	loff_t file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
-	int start_index = target_page->index & ~mask;
-	int end_index = start_index | mask;
+	loff_t start_index = target_page->index & ~mask;
+	loff_t end_index = start_index | mask;
 	int i, n, pages, bytes, res = -ENOMEM;
 	struct page **page;
 	struct squashfs_page_actor *actor;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


