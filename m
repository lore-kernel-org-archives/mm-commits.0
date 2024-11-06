Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3928183CC1
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855665; cv=none; b=FFQ3WqXAPlWrMncOXaLSnm5bi6Yc+SLvZ0OV+XSsuixUCrqZNByHZczjT1l4v8j/CxchlCVafdgf6dLOeF1GBUG6TFemG9CZMBzJm7afJd5eHoCkYzMg38rDUBJQAvVD58nKlFzon2L/zsyW56qHEAWwCRQP9S9vmY+4ODHBzSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855665; c=relaxed/simple;
	bh=6w/Ao6ugotK0yq2hJDAyNw3uTZoXJCcJpXTEchaTJ88=;
	h=Date:To:From:Subject:Message-Id; b=f2EZZJX+V8GqP1c05NjR8p7vh4RGdBAtjWS2AkaM7kJyQDDBRj5YRPQmiJWoKpshOwVslz8m8Lf2+WA0AfwPNTVuWIizuhJMUCF2z5+ctHDaECIa3mj0PMHKcx1/q/F1GSrMfvp4Ffbh3axgLQB9zH13csEp8QeSgT67kRcBkNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L7H28XLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L7H28XLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8804BC4CECF;
	Wed,  6 Nov 2024 01:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855665;
	bh=6w/Ao6ugotK0yq2hJDAyNw3uTZoXJCcJpXTEchaTJ88=;
	h=Date:To:From:Subject:From;
	b=L7H28XLmCJJjV3zqJcMVkY5cEC88rO0bMDilcKKbHPoNk91YHesrbLCIPK/RNUiCE
	 QnvM8eZtXkqzZNOybmXbU+C1SRmiZouPpGg8btECW+VeeWYb4Ddslxnj2/hUumWpVF
	 0uMfQYlTHfSn8y6rKbfAsrLsLFu6GWDAXCtZj8lQ=
Date: Tue, 05 Nov 2024 17:14:25 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch removed from -mm tree
Message-Id: <20241106011425.8804BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_recovery_copy_block() to take a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_recovery_copy_block() to take a folio
Date: Thu, 24 Oct 2024 18:25:45 +0900

Use memcpy_to_folio() instead of open-coding it, and use offset_in_folio()
in case anybody wants to use nilfs2 on a device with large blocks.

[konishi.ryusuke@gmail.com: added label name change]
Link: https://lkml.kernel.org/r/20241002150036.1339475-4-willy@infradead.org
Link: https://lkml.kernel.org/r/20241024092602.13395-12-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/recovery.c~nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio
+++ a/fs/nilfs2/recovery.c
@@ -481,19 +481,16 @@ static int nilfs_prepare_segment_for_rec
 
 static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
 				     struct nilfs_recovery_block *rb,
-				     loff_t pos, struct page *page)
+				     loff_t pos, struct folio *folio)
 {
 	struct buffer_head *bh_org;
-	size_t from = pos & ~PAGE_MASK;
-	void *kaddr;
+	size_t from = offset_in_folio(folio, pos);
 
 	bh_org = __bread(nilfs->ns_bdev, rb->blocknr, nilfs->ns_blocksize);
 	if (unlikely(!bh_org))
 		return -EIO;
 
-	kaddr = kmap_local_page(page);
-	memcpy(kaddr + from, bh_org->b_data, bh_org->b_size);
-	kunmap_local(kaddr);
+	memcpy_to_folio(folio, from, bh_org->b_data, bh_org->b_size);
 	brelse(bh_org);
 	return 0;
 }
@@ -531,13 +528,13 @@ static int nilfs_recover_dsync_blocks(st
 			goto failed_inode;
 		}
 
-		err = nilfs_recovery_copy_block(nilfs, rb, pos, &folio->page);
+		err = nilfs_recovery_copy_block(nilfs, rb, pos, folio);
 		if (unlikely(err))
-			goto failed_page;
+			goto failed_folio;
 
 		err = nilfs_set_file_dirty(inode, 1);
 		if (unlikely(err))
-			goto failed_page;
+			goto failed_folio;
 
 		block_write_end(NULL, inode->i_mapping, pos, blocksize,
 				blocksize, folio, NULL);
@@ -548,7 +545,7 @@ static int nilfs_recover_dsync_blocks(st
 		(*nr_salvaged_blocks)++;
 		goto next;
 
- failed_page:
+ failed_folio:
 		folio_unlock(folio);
 		folio_put(folio);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

