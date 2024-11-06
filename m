Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DC0189F20
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855661; cv=none; b=kGWl2ylzFN+NKJF3dJiFJmSgXKrkltGGMjw0bYlLuOtCvfUzxeYB1k/xFaKAmVqgT5L44q3mWeDOrag6N9nlYBz2Wl9W+iK6M3BbkwlBpqu+cq+S6mgij+htNqggfXsbxhGCNc9KLLrERImblS3zkM21KGxMduUGnVReSLav8eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855661; c=relaxed/simple;
	bh=8pFtmIC+c447dmYtJbPOQj6vZtt6Nl2ADKyE4UPYcKM=;
	h=Date:To:From:Subject:Message-Id; b=cCLRNv09ZaQUdAX5uXyqQVPVyXzqo/UL2H0UPFuLQexCHu/yqZvGpa7/qq4haAnFVgakwaAqYv5zPuaZQrZWRI8EhdCPHA6VTNt0x7AkeCMK0XF1LecrrixRxeHlcOnFC3z7aUx/pjF57eVSpag64aalcvdjKVX7PgDTZlYwDao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oYZRwWBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oYZRwWBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A382C4CECF;
	Wed,  6 Nov 2024 01:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855661;
	bh=8pFtmIC+c447dmYtJbPOQj6vZtt6Nl2ADKyE4UPYcKM=;
	h=Date:To:From:Subject:From;
	b=oYZRwWBJ8lQOmQpEHUeIEZOgx4HFQKRYYuinNtXaPGGoQO5kcYD0XLWdeZgxbh7oW
	 TbBNm/9OKAzJ/1LzahoasohnwTi4izH0iGR7EBnoiq4z2MFJb8p5Ag6UCCO1FX58cO
	 njllQa64aV6keXx3iMv0MT37C0pbPUtxCpqJ0rGo=
Date: Tue, 05 Nov 2024 17:14:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-nilfs_palloc_block_get_entry.patch removed from -mm tree
Message-Id: <20241106011421.0A382C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove nilfs_palloc_block_get_entry()
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-nilfs_palloc_block_get_entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: remove nilfs_palloc_block_get_entry()
Date: Thu, 24 Oct 2024 18:25:41 +0900

All calls to nilfs_palloc_block_get_entry() are now gone, so remove it.

Link: https://lkml.kernel.org/r/20241024092602.13395-8-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   19 -------------------
 fs/nilfs2/alloc.h |    2 --
 2 files changed, 21 deletions(-)

--- a/fs/nilfs2/alloc.c~nilfs2-remove-nilfs_palloc_block_get_entry
+++ a/fs/nilfs2/alloc.c
@@ -391,25 +391,6 @@ size_t nilfs_palloc_entry_offset(const s
 }
 
 /**
- * nilfs_palloc_block_get_entry - get kernel address of an entry
- * @inode: inode of metadata file using this allocator
- * @nr: serial number of the entry (e.g. inode number)
- * @bh: buffer head of the buffer storing the entry block
- * @kaddr: kernel address mapped for the page including the buffer
- */
-void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
-				   const struct buffer_head *bh, void *kaddr)
-{
-	unsigned long entry_offset, group_offset;
-
-	nilfs_palloc_group(inode, nr, &group_offset);
-	entry_offset = group_offset % NILFS_MDT(inode)->mi_entries_per_block;
-
-	return kaddr + bh_offset(bh) +
-		entry_offset * NILFS_MDT(inode)->mi_entry_size;
-}
-
-/**
  * nilfs_palloc_find_available_slot - find available slot in a group
  * @bitmap: bitmap of the group
  * @target: offset number of an entry in the group (start point)
--- a/fs/nilfs2/alloc.h~nilfs2-remove-nilfs_palloc_block_get_entry
+++ a/fs/nilfs2/alloc.h
@@ -31,8 +31,6 @@ nilfs_palloc_entries_per_group(const str
 int nilfs_palloc_init_blockgroup(struct inode *, unsigned int);
 int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
 				 struct buffer_head **);
-void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
-				   const struct buffer_head *, void *);
 size_t nilfs_palloc_entry_offset(const struct inode *inode, __u64 nr,
 				 const struct buffer_head *bh);
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


