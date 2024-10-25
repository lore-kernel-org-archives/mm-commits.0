Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E046B1925AB
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 19:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729885082; cv=none; b=Hqiqy3vRYBzNv+YOduXiSdzwn67PIyVxvnalNBSnzFIBP+Y51AB4k6KlrQ6Ab8pngJhPQV9fNYZZFU5kY38gH86F4bypW/seq9WReH8RYBFzg7yfwvZ0F8lu0QjakqkTEBfPM7AHAt+HgNvEN9ZN8EELgfNquT/Hda5d474pXM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729885082; c=relaxed/simple;
	bh=uOMMFgEErUrKmjLgzo8bq8QuZVIoqzwku0DjiaX867U=;
	h=Date:To:From:Subject:Message-Id; b=OQkiV1/Wa4jOHWehMlYo2DB0tJvLEtwGhlerjIm9ijz/ZFdJeZ08xW5L95h51ee8Feo201p9AVs6gUaabiYKWzwr5RcKRiFEeq+0LiXbMH6P393rOl9X7g/dzjtaSoa3dtB10q4uoSO4Ok4d2quch+3KPy8wz5cJ+d6R28WH9MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZSKwHTyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZSKwHTyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB151C4CEC3;
	Fri, 25 Oct 2024 19:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729885081;
	bh=uOMMFgEErUrKmjLgzo8bq8QuZVIoqzwku0DjiaX867U=;
	h=Date:To:From:Subject:From;
	b=ZSKwHTyK2c6yf3CTHHuZWT9vvhgh2KqrxUvCC9ijTw44o6aHClAJDWAYNa24KwIvL
	 m7LQ/rRROq/aswcZyXzySlD3FzW/GdkI/c75d2GR80P/0j765d3XRXNsQ1E4NhKYJr
	 FxNetXe0QSDxOCntxJ9GO4nffNcAws46UYuJ3n3g=
Date: Fri, 25 Oct 2024 12:38:01 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241025193801.AB151C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert nilfs_recovery_copy_block() to take a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

