Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4367F2FD1D5;
	Mon, 24 Nov 2025 23:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025810; cv=none; b=IGeVnjF6hHtHZujHtxmWRXxDsWoACcSQuv0mRaVYE0w2BOmGhj/j6leIQZCD0OQSRH9v3z5NJV8BGeOSHSuUhR6UPE2t8ias1WpTIuQLoMFAjZDUebLBTwX0r2TAEXyvtRMdIc03LKt3yl7ILAL3++YjKc3n6fYdJMfPzXNNQN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025810; c=relaxed/simple;
	bh=vwUGrbnLwzrS4LRve4fWZSddR/D/sPnwGQ+MQ3Pg490=;
	h=Date:To:From:Subject:Message-Id; b=F4RGrD0YwhuYOPVySzHAGldJ+5mvZvY10fZum9HKRyVUR138ju5oKatKUoMlYXJGSGKNjBfrMzDIsg91AVpOKN0RjNc/X6aAj0H6Gcp5/tvdb4oSkmVAfaAVnA9XzhpbPw5ojM0UgQP7K++zTrrNnhiQYxn+HGcBoBvYkx+lRzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QhYrPITn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QhYrPITn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA455C4CEF1;
	Mon, 24 Nov 2025 23:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025809;
	bh=vwUGrbnLwzrS4LRve4fWZSddR/D/sPnwGQ+MQ3Pg490=;
	h=Date:To:From:Subject:From;
	b=QhYrPITn7dLFdkhLf4Cqi7SLpLjVxfdL/lXXawXlZb6Pbt7IoLISDxf+UdtIGfA/o
	 tAPprD8/I8FlM+zOodMPNnzA9RRNllDi07ORa7Jtah9jMPGdADYUjdQSHJRrtFrhCv
	 qYrTiRdzS6iUJJ5DNljOIDXpbSzhOzjV8xeEnqD4=
Date: Mon, 24 Nov 2025 15:10:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch removed from -mm tree
Message-Id: <20251124231009.BA455C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: merge uniform_split_supported() and non_uniform_split_supported()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: merge uniform_split_supported() and non_uniform_split_supported()
Date: Thu, 6 Nov 2025 03:41:55 +0000

uniform_split_supported() and non_uniform_split_supported() share
significantly similar logic.

The only functional difference is that uniform_split_supported() includes
an additional check on the requested @new_order.

The reason for this check comes from the following two aspects:

  * some file system or swap cache just supports order-0 folio
  * the behavioral difference between uniform/non-uniform split

The behavioral difference between uniform split and non-uniform:

  * uniform split splits folio directly to @new_order
  * non-uniform split creates after-split folios with orders from
    folio_order(folio) - 1 to new_order.

This means for non-uniform split or !new_order split we should check the
file system and swap cache respectively.

This commit unifies the logic and merge the two functions into a single
combined helper, removing redundant code and simplifying the split
support checking mechanism.

Link: https://lkml.kernel.org/r/20251106034155.21398-3-richard.weiyang@gmail.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    8 +---
 mm/huge_memory.c        |   71 ++++++++++++++++----------------------
 2 files changed, 33 insertions(+), 46 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported
+++ a/include/linux/huge_mm.h
@@ -374,10 +374,8 @@ int __split_huge_page_to_list_to_order(s
 		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns);
-bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns);
+bool folio_split_supported(struct folio *folio, unsigned int new_order,
+		enum split_type split_type, bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -408,7 +406,7 @@ static inline int split_huge_page_to_ord
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
+	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
--- a/mm/huge_memory.c~mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported
+++ a/mm/huge_memory.c
@@ -3593,8 +3593,8 @@ static int __split_unmapped_folio(struct
 	return 0;
 }
 
-bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns)
+bool folio_split_supported(struct folio *folio, unsigned int new_order,
+		enum split_type split_type, bool warns)
 {
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
@@ -3602,48 +3602,41 @@ bool non_uniform_split_supported(struct
 				"Cannot split to order-1 folio");
 		if (new_order == 1)
 			return false;
-	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    !mapping_large_folio_support(folio->mapping)) {
-		/*
-		 * No split if the file system does not support large folio.
-		 * Note that we might still have THPs in such mappings due to
-		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
-		 * does not actually support large folios properly.
-		 */
-		VM_WARN_ONCE(warns,
-			"Cannot split file folio to non-0 order");
-		return false;
-	}
-
-	/* Only swapping a whole PMD-mapped folio is supported */
-	if (folio_test_swapcache(folio)) {
-		VM_WARN_ONCE(warns,
-			"Cannot split swapcache folio to non-0 order");
-		return false;
-	}
-
-	return true;
-}
-
-/* See comments in non_uniform_split_supported() */
-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns)
-{
-	if (folio_test_anon(folio)) {
-		VM_WARN_ONCE(warns && new_order == 1,
-				"Cannot split to order-1 folio");
-		if (new_order == 1)
-			return false;
-	} else  if (new_order) {
+	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
+			/*
+			 * We can always split a folio down to a single page
+			 * (new_order == 0) uniformly.
+			 *
+			 * For any other scenario
+			 *   a) uniform split targeting a large folio
+			 *      (new_order > 0)
+			 *   b) any non-uniform split
+			 * we must confirm that the file system supports large
+			 * folios.
+			 *
+			 * Note that we might still have THPs in such
+			 * mappings, which is created from khugepaged when
+			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
+			 * case, the mapping does not actually support large
+			 * folios properly.
+			 */
 			VM_WARN_ONCE(warns,
 				"Cannot split file folio to non-0 order");
 			return false;
 		}
 	}
 
-	if (new_order && folio_test_swapcache(folio)) {
+	/*
+	 * swapcache folio could only be split to order 0
+	 *
+	 * non-uniform split creates after-split folios with orders from
+	 * folio_order(folio) - 1 to new_order, making it not suitable for any
+	 * swapcache folio split. Only uniform split to order-0 can be used
+	 * here.
+	 */
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
 		VM_WARN_ONCE(warns,
 			"Cannot split swapcache folio to non-0 order");
 		return false;
@@ -3711,11 +3704,7 @@ static int __folio_split(struct folio *f
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (split_type == SPLIT_TYPE_UNIFORM && !uniform_split_supported(folio, new_order, true))
-		return -EINVAL;
-
-	if (split_type == SPLIT_TYPE_NON_UNIFORM &&
-	    !non_uniform_split_supported(folio, new_order, true))
+	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
 		return -EINVAL;
 
 	is_hzp = is_huge_zero_folio(folio);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


