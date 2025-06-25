Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E3314A8E
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 00:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750809715; cv=none; b=GBkFLyKVMQyPaj6wxoRMBNKEYOjAZUGPm7mIDFeyiiW//mNsbh3zKM61aK+lu8iENzz0ghERrb381yTZa8AgNulTlcpX9k9rGfWdKRBUx+vMwkKYzlkuUuU9MS/IYYOG1RpLb9bUPj1EPfqU9EAmb6HckMYSaTCR2RQnxUiOMKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750809715; c=relaxed/simple;
	bh=rbY7BxzARqfrTo08825d56rsTtIbxVc51oWShnzZnXI=;
	h=Date:To:From:Subject:Message-Id; b=NxHIQ4f/lKnIYz7shWjsSdAdCQ8rFRQn1CBNsvJjLXEaBxlFAyL3Zo73r5PZTpbVqmHXAykYIIzQ/DOtNV5umKXQjg7WLhTFTEpitBr5NfoquTfH411JBjtiaicYqBpaFyljZ8DvC3NR8OBrNot3bylwLjo2wYvw8gZ1e8Xknz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PkNpOoWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PkNpOoWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D08C4CEE3;
	Wed, 25 Jun 2025 00:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750809715;
	bh=rbY7BxzARqfrTo08825d56rsTtIbxVc51oWShnzZnXI=;
	h=Date:To:From:Subject:From;
	b=PkNpOoWwTraLf6KYcLCkSUA3Pw5oiAJf/WYh6cCV5VVBsbETLyziABZHmPREdAKF8
	 B94/lQbF6KCw541ubvlh1vHg0/YnPT+8zT5eRDpDVVAJ/kxVmKyKsDoeYJT2CdTMBn
	 Owr4oRu6MN0scXIqi4zvrsyCjpsUWWeww64nYDN4=
Date: Tue, 24 Jun 2025 17:01:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shivankg@amd.com,pankaj.gupta@amd.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] filemap-add-__filemap_get_folio_mpol.patch removed from -mm tree
Message-Id: <20250625000155.62D08C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: add __filemap_get_folio_mpol()
has been removed from the -mm tree.  Its filename was
     filemap-add-__filemap_get_folio_mpol.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: add __filemap_get_folio_mpol()
Date: Fri, 20 Jun 2025 15:34:47 +0100

This allows guest_memfd to pass in a memory policy.

[akpm@linux-foundation.org: fix EXPORT_SYMBOL()]
Link: https://lkml.kernel.org/r/20250620143502.3055777-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   10 ++++++++--
 mm/filemap.c            |   12 +++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/include/linux/pagemap.h~filemap-add-__filemap_get_folio_mpol
+++ a/include/linux/pagemap.h
@@ -745,11 +745,17 @@ static inline fgf_t fgf_set_order(size_t
 }
 
 void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
-struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
-		fgf_t fgp_flags, gfp_t gfp);
+struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
+		pgoff_t index, fgf_t fgf_flags, gfp_t gfp, struct mempolicy *);
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
 		fgf_t fgp_flags, gfp_t gfp);
 
+static inline struct folio *__filemap_get_folio(struct address_space *mapping,
+		pgoff_t index, fgf_t fgf_flags, gfp_t gfp)
+{
+	return __filemap_get_folio_mpol(mapping, index, fgf_flags, gfp, NULL);
+}
+
 /**
  * filemap_get_folio - Find and get a folio.
  * @mapping: The address_space to search.
--- a/mm/filemap.c~filemap-add-__filemap_get_folio_mpol
+++ a/mm/filemap.c
@@ -1897,11 +1897,12 @@ out:
 }
 
 /**
- * __filemap_get_folio - Find and get a reference to a folio.
+ * __filemap_get_folio_mpol - Find and get a reference to a folio.
  * @mapping: The address_space to search.
  * @index: The page index.
  * @fgp_flags: %FGP flags modify how the folio is returned.
  * @gfp: Memory allocation flags to use if %FGP_CREAT is specified.
+ * @policy: NUMA memory allocation policy to follow.
  *
  * Looks up the page cache entry at @mapping & @index.
  *
@@ -1912,8 +1913,9 @@ out:
  *
  * Return: The found folio or an ERR_PTR() otherwise.
  */
-struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
-		fgf_t fgp_flags, gfp_t gfp)
+struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
+		pgoff_t index, fgf_t fgp_flags, gfp_t gfp,
+		struct mempolicy *policy)
 {
 	struct folio *folio;
 
@@ -1983,7 +1985,7 @@ no_page:
 			err = -ENOMEM;
 			if (order > min_order)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
-			folio = filemap_alloc_folio(alloc_gfp, order, NULL);
+			folio = filemap_alloc_folio(alloc_gfp, order, policy);
 			if (!folio)
 				continue;
 
@@ -2030,7 +2032,7 @@ no_page:
 		folio_clear_dropbehind(folio);
 	return folio;
 }
-EXPORT_SYMBOL(__filemap_get_folio);
+EXPORT_SYMBOL(__filemap_get_folio_mpol);
 
 static inline struct folio *find_get_entry(struct xa_state *xas, pgoff_t max,
 		xa_mark_t mark)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch
bio-use-memzero_page-in-bio_truncate.patch
null_blk-use-memzero_page.patch
direct-io-use-memzero_page.patch
ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch
mm-remove-zero_user.patch
secretmem-remove-uses-of-struct-page.patch
highmem-remove-a-use-of-folio-page.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

