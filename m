Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A244E7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yzzup2w7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEF5C433C8;
	Mon, 11 Dec 2023 01:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257844;
	bh=xOMijBREVFMgukG81IWE3rxqZEsc2qFtqmP+NdhEqmg=;
	h=Date:To:From:Subject:From;
	b=Yzzup2w7JMa4uICnNhfGwesYYp1EGfnN2Fyl1mtvBSb30ZFSfY4vp+Wl0A0YuxCCW
	 deDzRsH8W4ReSfrA8JIRziiyyTZFOS1n5T0IJux6McWNlPkJlN0+gZKGyKfeWpADqk
	 3jWxuxUm5dQ0J4gineRxTMgKBAx2W+O5BvVjnfV0=
Date: Sun, 10 Dec 2023 17:24:03 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-page_address-from-nilfs_set_link.patch removed from -mm tree
Message-Id: <20231211012404.6CEF5C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove page_address() from nilfs_set_link
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-page_address-from-nilfs_set_link.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: remove page_address() from nilfs_set_link
Date: Mon, 27 Nov 2023 23:30:22 +0900

In preparation for removing kmap from directory handling, use
offset_in_page() to calculate 'from'.  Matches ext2.

Link: https://lkml.kernel.org/r/20231127143036.2425-4-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c~nilfs2-remove-page_address-from-nilfs_set_link
+++ a/fs/nilfs2/dir.c
@@ -410,7 +410,7 @@ ino_t nilfs_inode_by_name(struct inode *
 void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct page *page, struct inode *inode)
 {
-	unsigned int from = (char *)de - (char *)page_address(page);
+	unsigned int from = offset_in_page(de);
 	unsigned int to = from + nilfs_rec_len_from_disk(de->rec_len);
 	struct address_space *mapping = page->mapping;
 	int err;
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

