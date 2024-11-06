Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC4818B47E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855666; cv=none; b=CNs2gdo9M61lY0UEjxywQnyOSyJ0qP086LfWQPeUsWEU36OZir9cAoT/ELH+zq/6YsVFLAf6daJz3wfchzQxV75lPmRbKur1LVH1x0VUoS7oWQi7atOh8n2mzwd9XoIGE4o7ql+UM7u8vMBIVUmDjzvhsK7IXfMfkzYkhiLObdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855666; c=relaxed/simple;
	bh=v+E4yx0LhWmio3rbim8v7zIby2wu3bEUQ/NI2JQu4bc=;
	h=Date:To:From:Subject:Message-Id; b=iiWZFPxsiRhBEjuoxDS2sjc/0EVSKfvsSGgHMtf+IwKIUnGrDslr4q4zZvy5XP11FpZY4Pr8rytxWyq8lrdYNxTWN8kealzgLNPyTbQsJllBpq2IkY9ANbD7Frwt7TJGYR/09+JTxz6MZdRrYVy6ehQWca9xhgxD9ouEXs37Tt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=loBqEVrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="loBqEVrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7F4C4CECF;
	Wed,  6 Nov 2024 01:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855666;
	bh=v+E4yx0LhWmio3rbim8v7zIby2wu3bEUQ/NI2JQu4bc=;
	h=Date:To:From:Subject:From;
	b=loBqEVrUeyw73shbjVHgtN50XIbnCujLJwZjANyYiGifUUl3do7LOO3f12eSE22TL
	 umDcvbnX6JxnskRzVCha4zQSL2ZpLKzofkNndOSfRI/GQ7+Hw7uY7owQTVR9wP8YQA
	 TJDtRNybvq3MAdbXOI9K+kw7JN7GDWkJvDerwtYI=
Date: Tue, 05 Nov 2024 17:14:26 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch removed from -mm tree
Message-Id: <20241106011426.9E7F4C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert metadata aops from writepage to writepages
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert metadata aops from writepage to writepages
Date: Thu, 24 Oct 2024 18:25:46 +0900

By implementing ->writepages instead of ->writepage, we remove a layer of
indirect function calls from the writeback path and the last use of struct
page in nilfs2.

[konishi.ryusuke@gmail.com: fixed panic by using buffer_migrate_folio_norefs]
Link: https://lkml.kernel.org/r/20241002150036.1339475-5-willy@infradead.org
Link: https://lkml.kernel.org/r/20241024092602.13395-13-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-convert-metadata-aops-from-writepage-to-writepages
+++ a/fs/nilfs2/mdt.c
@@ -399,10 +399,9 @@ int nilfs_mdt_fetch_dirty(struct inode *
 	return test_bit(NILFS_I_DIRTY, &ii->i_state);
 }
 
-static int
-nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
+static int nilfs_mdt_write_folio(struct folio *folio,
+		struct writeback_control *wbc)
 {
-	struct folio *folio = page_folio(page);
 	struct inode *inode = folio->mapping->host;
 	struct super_block *sb;
 	int err = 0;
@@ -435,11 +434,23 @@ nilfs_mdt_write_page(struct page *page,
 	return err;
 }
 
+static int nilfs_mdt_writeback(struct address_space *mapping,
+		struct writeback_control *wbc)
+{
+	struct folio *folio = NULL;
+	int error;
+
+	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
+		error = nilfs_mdt_write_folio(folio, wbc);
+
+	return error;
+}
 
 static const struct address_space_operations def_mdt_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.invalidate_folio	= block_invalidate_folio,
-	.writepage		= nilfs_mdt_write_page,
+	.writepages		= nilfs_mdt_writeback,
+	.migrate_folio		= buffer_migrate_folio_norefs,
 };
 
 static const struct inode_operations def_mdt_iops;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

