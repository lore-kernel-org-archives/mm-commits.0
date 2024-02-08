Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFDE67A13;
	Thu,  8 Feb 2024 05:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369676; cv=none; b=mcEaHGLXcRGiaRzwZ5v2Z9Rk3eGdkzbcp0L+ZbV3MY0RuJBX5WWc54itHrR2Ix+KtuIXRt/jhhT7qicxxEryWluO5UCjsz1sTYm2K9ICC2Loc6PxjrhiK9fMVrtfAWFfsbuvOoUGXoczFs/1Q8HRetCo6y2GV6VeLdR7VVcWqdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369676; c=relaxed/simple;
	bh=h4bJovS+sHBbmmdHx9PEbX1TZbSjxsIU9efURF5ktBU=;
	h=Date:To:From:Subject:Message-Id; b=kl/fItwKVavHOFQpd/wqPdLU5mrffScPNJ2rxn/yk8gQDeKu6gWPNGpZXU2BueR5s/5X9XeXAVxNr+C1oBSmiFWwp/NiTR1wtTcFFD0jmkCcoHEeNGXAwXAyIqJPkG79ELc+X5wSXgF2PNQbgcUNRyz6Xi7k029z5kFEOqL7k7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EZ4j4Bgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EZ4j4Bgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50020C433F1;
	Thu,  8 Feb 2024 05:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369675;
	bh=h4bJovS+sHBbmmdHx9PEbX1TZbSjxsIU9efURF5ktBU=;
	h=Date:To:From:Subject:From;
	b=EZ4j4Bgcum5+WHjfTZjgRci4iqFHOs6ZK40oZ1hWUWiZIMq4OSIabNikOTnt/6N2Q
	 2MToZ71GRAZvwMH6tCTiC1pXUicyIFNjAudQeMOwAn2E5vY2ujJGEZPDfowibcrf3/
	 iSrfXtUxjcuRRL5fOr3bSl4tXMCgOQYLjt8kTXPs=
Date: Wed, 07 Feb 2024 21:21:14 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-data-corruption-in-dsync-block-recovery-for-small-block-sizes.patch removed from -mm tree
Message-Id: <20240208052115.50020C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix data corruption in dsync block recovery for small block sizes
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-data-corruption-in-dsync-block-recovery-for-small-block-sizes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix data corruption in dsync block recovery for small block sizes
Date: Wed, 24 Jan 2024 21:19:36 +0900

The helper function nilfs_recovery_copy_block() of
nilfs_recovery_dsync_blocks(), which recovers data from logs created by
data sync writes during a mount after an unclean shutdown, incorrectly
calculates the on-page offset when copying repair data to the file's page
cache.  In environments where the block size is smaller than the page
size, this flaw can cause data corruption and leak uninitialized memory
bytes during the recovery process.

Fix these issues by correcting this byte offset calculation on the page.

Link: https://lkml.kernel.org/r/20240124121936.10575-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/recovery.c~nilfs2-fix-data-corruption-in-dsync-block-recovery-for-small-block-sizes
+++ a/fs/nilfs2/recovery.c
@@ -472,9 +472,10 @@ static int nilfs_prepare_segment_for_rec
 
 static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
 				     struct nilfs_recovery_block *rb,
-				     struct page *page)
+				     loff_t pos, struct page *page)
 {
 	struct buffer_head *bh_org;
+	size_t from = pos & ~PAGE_MASK;
 	void *kaddr;
 
 	bh_org = __bread(nilfs->ns_bdev, rb->blocknr, nilfs->ns_blocksize);
@@ -482,7 +483,7 @@ static int nilfs_recovery_copy_block(str
 		return -EIO;
 
 	kaddr = kmap_atomic(page);
-	memcpy(kaddr + bh_offset(bh_org), bh_org->b_data, bh_org->b_size);
+	memcpy(kaddr + from, bh_org->b_data, bh_org->b_size);
 	kunmap_atomic(kaddr);
 	brelse(bh_org);
 	return 0;
@@ -521,7 +522,7 @@ static int nilfs_recover_dsync_blocks(st
 			goto failed_inode;
 		}
 
-		err = nilfs_recovery_copy_block(nilfs, rb, page);
+		err = nilfs_recovery_copy_block(nilfs, rb, pos, page);
 		if (unlikely(err))
 			goto failed_page;
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch

