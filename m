Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F1313D251
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291563; cv=none; b=IscxjdIzG+of2PIqXZLbXxWk8CBnQDw/adjQ3s37VUOrRT0AgvwgOZ23Hz1dll/5MAv+v4509dirO6sYXKyR+45vgfa84rXaADVL+9sWKd9c8ZeBDK33KrhIo4AZ5T2bEVgV8imfgU4kwkaQcy57qlXPZh8QtppS44xebX6AycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291563; c=relaxed/simple;
	bh=hG/FkqHpdgjosTeyQLVVkhrSdpeOvWLtVoc8Mc2wzM4=;
	h=Date:To:From:Subject:Message-Id; b=ojgUMkWZc688zkUVK5eSozanTXIm+GigHHlZFeynfUyyhEM/E9eioc7J+qEDBG235xbbo+K/mxsz10bGnhcOoiWMS8aDpq0gVZoptxSfuT0ya7DkD0vlH1OMe+v/xGnXM4Xi5r2to2otjdy0AiO8y/9FU/Lw4pIGze8LbD3GB4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Phj/tw5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Phj/tw5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65595C32782;
	Tue, 25 Jun 2024 04:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291563;
	bh=hG/FkqHpdgjosTeyQLVVkhrSdpeOvWLtVoc8Mc2wzM4=;
	h=Date:To:From:Subject:From;
	b=Phj/tw5cIQm8Lhfn2MnPdBRKiH1I11YJDDjyx8JBWfoP53nzEO49SuthqDow3RbzU
	 qOCsyIboadAdn7t4BaEVFMm7J2yD9tuXfx9Vv+iX8RUVs6Q7Pj3Yex7N8IgEpFTCsF
	 nGjwvPnNzqlu97kktFD+lV9NbNe4+hTyH13L66Hc=
Date: Mon, 24 Jun 2024 21:59:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-setclearhpage-macros.patch removed from -mm tree
Message-Id: <20240625045923.65595C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove {Set,Clear}Hpage macros
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-setclearhpage-macros.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: remove {Set,Clear}Hpage macros
Date: Mon, 20 May 2024 15:44:07 -0700

All users have been converted to use the folio version of these macros, we
can safely remove the page based interface.

Link: https://lkml.kernel.org/r/20240520224407.110062-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-remove-setclearhpage-macros
+++ a/include/linux/hugetlb.h
@@ -625,18 +625,14 @@ static __always_inline						\
 void folio_set_hugetlb_##flname(struct folio *folio)		\
 	{	void *private = &folio->private;		\
 		set_bit(HPG_##flname, private);			\
-	}							\
-static inline void SetHPage##uname(struct page *page)		\
-	{ set_bit(HPG_##flname, &(page->private)); }
+	}
 
 #define CLEARHPAGEFLAG(uname, flname)				\
 static __always_inline						\
 void folio_clear_hugetlb_##flname(struct folio *folio)		\
 	{	void *private = &folio->private;		\
 		clear_bit(HPG_##flname, private);		\
-	}							\
-static inline void ClearHPage##uname(struct page *page)		\
-	{ clear_bit(HPG_##flname, &(page->private)); }
+	}
 #else
 #define TESTHPAGEFLAG(uname, flname)				\
 static inline bool						\
@@ -648,15 +644,11 @@ static inline int HPage##uname(struct pa
 #define SETHPAGEFLAG(uname, flname)				\
 static inline void						\
 folio_set_hugetlb_##flname(struct folio *folio) 		\
-	{ }							\
-static inline void SetHPage##uname(struct page *page)		\
 	{ }
 
 #define CLEARHPAGEFLAG(uname, flname)				\
 static inline void						\
 folio_clear_hugetlb_##flname(struct folio *folio)		\
-	{ }							\
-static inline void ClearHPage##uname(struct page *page)		\
 	{ }
 #endif
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-use-mas_store_gfp-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-mas_wr_append.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch
tools-testing-radix-tree-add-missing-module_description-definition.patch

