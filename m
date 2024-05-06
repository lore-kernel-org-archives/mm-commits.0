Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A5B2BAEE
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957095; cv=none; b=PJe3DWA5EEMJYNQiG6DvFmRtuJ4tPFagEqCw/b3enNA5HSyGYjs3AOiwpG9eim40gajG1GaL/G8h2qckSNpc3PKgLTk1cL6azqckHaE3Ky0VQo3VDFuWQVlXch0YifSH1wArKVksHgrBrD6FKbLGhdcfDzKjg+vitc5+5mBn6m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957095; c=relaxed/simple;
	bh=ehJv99hDqHja3O0f2FHkcl9eDkEb/P7ZyH+0nv/g260=;
	h=Date:To:From:Subject:Message-Id; b=GMHHZfa3qABkirV5aoyFbok/GsnT15yy3w/J90MSpS8eAgVZYPRbqQtqOtzEvaHktAa95mQUB/21+pdTrlswrFgcdQijA36xHYbbi7u21kK2qxP+rU2CN4Ytwgr4SybdmvV3Ji8WPPD3YLdtZauOa8BlGwgEyHZRvxp5+8Nu1AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1GD7jxQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1GD7jxQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D352C113CC;
	Mon,  6 May 2024 00:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957095;
	bh=ehJv99hDqHja3O0f2FHkcl9eDkEb/P7ZyH+0nv/g260=;
	h=Date:To:From:Subject:From;
	b=1GD7jxQRu/tqxw+Bh7agDqUEXk0WX/MLj73NPmCsTTOuLQe2W4wuRvU12qgPFRInI
	 9lMvkmRtRrc44cC95CJUYEkpJAA1dljzWZMd+e+yPB67of1nJvLD9uXZS6PTbpnJpT
	 m9S8AmQE70690DJdnvxzkkdlYtshKJ0BtPuBhCZE=
Date: Sun, 05 May 2024 17:58:14 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,ebiggers@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240506005815.6D352C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fscrypt: convert bh_get_inode_and_lblk_num to use a folio
has been removed from the -mm tree.  Its filename was
     fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fscrypt: convert bh_get_inode_and_lblk_num to use a folio
Date: Tue, 23 Apr 2024 23:55:32 +0100

Patch series "Remove page_mapping()".

There are only a few users left.  Convert them all to either call
folio_mapping() or just use folio->mapping directly.  


This patch (of 6):

Remove uses of page->index, page_mapping() and b_page.  Saves a call
to compound_head().

Link: https://lkml.kernel.org/r/20240423225552.4113447-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240423225552.4113447-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/crypto/inline_crypt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/crypto/inline_crypt.c~fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio
+++ a/fs/crypto/inline_crypt.c
@@ -284,7 +284,7 @@ static bool bh_get_inode_and_lblk_num(co
 				      const struct inode **inode_ret,
 				      u64 *lblk_num_ret)
 {
-	struct page *page = bh->b_page;
+	struct folio *folio = bh->b_folio;
 	const struct address_space *mapping;
 	const struct inode *inode;
 
@@ -292,13 +292,13 @@ static bool bh_get_inode_and_lblk_num(co
 	 * The ext4 journal (jbd2) can submit a buffer_head it directly created
 	 * for a non-pagecache page.  fscrypt doesn't care about these.
 	 */
-	mapping = page_mapping(page);
+	mapping = folio_mapping(folio);
 	if (!mapping)
 		return false;
 	inode = mapping->host;
 
 	*inode_ret = inode;
-	*lblk_num_ret = ((u64)page->index << (PAGE_SHIFT - inode->i_blkbits)) +
+	*lblk_num_ret = ((u64)folio->index << (PAGE_SHIFT - inode->i_blkbits)) +
 			(bh_offset(bh) >> inode->i_blkbits);
 	return true;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

