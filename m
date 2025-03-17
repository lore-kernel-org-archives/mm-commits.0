Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A3C215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188346; cv=none; b=Q70ESUCBMQiHq0T+0VoigEUxWLjz4VIyuUlHrQWxUpfB5IuW9CAaM04gnfhkVBSHxMdlxFp3sZ1S2T1C4bQPfE2j3KeihMdqpwNmNWDPhZgiO7WUQ2kSAXPwkbmOXq70UbVJ7NRPYkIGVaMihR8mWoYOwsPjN1Jcb+m+4haKYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188346; c=relaxed/simple;
	bh=Ri7D7vmBmH70oB8AgFtdFXK/7bVLl4s8rQJ+TuF4SuI=;
	h=Date:To:From:Subject:Message-Id; b=PeCENGrIOZhgOXVnm2KBRMILyzUfU2QUhTsp1f76vlUGNCOx2sNZGQK2zA+9Lxg5fy5fFvR5fHUGAEUXrpg3jMsigGX4giVt6qH6g/7N36x7xOl8WF1AfwSXGNfHoHVDHfBxEqSPc/sfYDfx1SKO0mM440Dl5n+V6T656iXT8rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MSlcXjUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MSlcXjUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F65C4CEEC;
	Mon, 17 Mar 2025 05:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188346;
	bh=Ri7D7vmBmH70oB8AgFtdFXK/7bVLl4s8rQJ+TuF4SuI=;
	h=Date:To:From:Subject:From;
	b=MSlcXjUNzmL/A2JKHP4oL5pe5eJ6mDdY4w6oKNSWGz47ZOi/to6LshYdYaXx2du8N
	 rwT8U/cNdajKa83SLJIOikPDP69LXYdq03mH8Haybu4LiGLC0bY/NqpJZYF8JwUMh2
	 mxRF+z0olqjOt/MhMFetDa8VVy8PFLUNqEOUt/ro=
Date: Sun, 16 Mar 2025 22:12:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-remove-folio_file_mapping.patch removed from -mm tree
Message-Id: <20250317051225.E3F65C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: remove folio_file_mapping()
has been removed from the -mm tree.  Its filename was
     fs-remove-folio_file_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: remove folio_file_mapping()
Date: Mon, 17 Feb 2025 19:20:08 +0000

No callers of this function remain as filesystems no longer see swapfile
pages through their normal read/write paths.

Link: https://lkml.kernel.org/r/20250217192009.437916-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/include/linux/pagemap.h~fs-remove-folio_file_mapping
+++ a/include/linux/pagemap.h
@@ -536,26 +536,6 @@ struct address_space *folio_mapping(stru
 struct address_space *swapcache_mapping(struct folio *);
 
 /**
- * folio_file_mapping - Find the mapping this folio belongs to.
- * @folio: The folio.
- *
- * For folios which are in the page cache, return the mapping that this
- * page belongs to.  Folios in the swap cache return the mapping of the
- * swap file or swap device where the data is stored.  This is different
- * from the mapping returned by folio_mapping().  The only reason to
- * use it is if, like NFS, you return 0 from ->activate_swapfile.
- *
- * Do not call this for folios which aren't in the page cache or swap cache.
- */
-static inline struct address_space *folio_file_mapping(struct folio *folio)
-{
-	if (unlikely(folio_test_swapcache(folio)))
-		return swapcache_mapping(folio);
-
-	return folio->mapping;
-}
-
-/**
  * folio_flush_mapping - Find the file mapping this folio belongs to.
  * @folio: The folio.
  *
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

