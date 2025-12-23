Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1C32F9984
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 18:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766514557; cv=none; b=c3qKVDUy3MuCv4t/wNUI5gqdZAQvNI2x6cIL3eDg88CGr4P5MBuKJulYGEyw0Ek5esR0hHEmvGVm4s77Iy1FQ3QaLs2/XA5/r6eL874NYNnCbAmCoRbYead4E3qlQ2+i15SfUKgzlaAgYO3DHxDifrCvwob6A4PuexwvZsC+vRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766514557; c=relaxed/simple;
	bh=KnMTxtXZ0kSsLh+YDEJvrik7uRmIjB6mpjCyPo5YwOY=;
	h=Date:To:From:Subject:Message-Id; b=tVVrniTFZtqwUXJQlKDVUE22TNk/ERwoekC5VMHL/NWrrzi+3x0TkVgsvAtU0q4wUEQMai+b7P5Z0xZ8heP62jfKqh7NBKghw7hU0I8DJTungg7ro5TueAEkCV5W/pJQelcYlH34rCEJVfGxyTXfnfdK0ild3LZGqqns7V2/vb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QjH2Wzw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QjH2Wzw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BF5C113D0;
	Tue, 23 Dec 2025 18:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766514557;
	bh=KnMTxtXZ0kSsLh+YDEJvrik7uRmIjB6mpjCyPo5YwOY=;
	h=Date:To:From:Subject:From;
	b=QjH2Wzw6DbFn6n8UL04/Yg/XfgUomGwK0XSAV4YhqRBY4lP4ipxd9ocWqolqoBtoB
	 FsgFzndKt4tz/qGIt9dxOC1ImtWCjoBNI3nEgt+CIkIroJOq+G0+v6lxlOmVQeskfG
	 8XgYAT4ChbEHUidfsuge9PNflK7RnGLEEY97H7SA=
Date: Tue, 23 Dec 2025 10:29:16 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch removed from -mm tree
Message-Id: <20251223182916.E9BF5C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: consolidate order-related checks into folio_check_splittable()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: consolidate order-related checks into folio_check_splittable()
Date: Tue, 23 Dec 2025 12:25:39 +0000

The primary goal of the folio_check_splittable() function is to validate
whether a folio is suitable for splitting and to bail out early if it is
not.

Currently, some order-related checks are scattered throughout the calling
code rather than being centralized in folio_check_splittable().

This commit moves all remaining order-related validation logic into
folio_check_splittable().  This consolidation ensures that the function
serves its intended purpose as a single point of failure and improves the
clarity and maintainability of the surrounding code.

Link: https://lkml.kernel.org/r/20251223122539.10726-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   63 +++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable
+++ a/mm/huge_memory.c
@@ -3700,6 +3700,10 @@ int folio_check_splittable(struct folio
 			   enum split_type split_type)
 {
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	if (new_order >= folio_order(folio))
+		return -EINVAL;
+
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
 	 * caller that there was a race.
@@ -3714,28 +3718,33 @@ int folio_check_splittable(struct folio
 		/* order-1 is not supported for anonymous THP. */
 		if (new_order == 1)
 			return -EINVAL;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
-			return -EINVAL;
+	} else {
+		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
+			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+			    !mapping_large_folio_support(folio->mapping)) {
+				/*
+				 * We can always split a folio down to a
+				 * single page (new_order == 0) uniformly.
+				 *
+				 * For any other scenario
+				 *   a) uniform split targeting a large folio
+				 *      (new_order > 0)
+				 *   b) any non-uniform split
+				 * we must confirm that the file system
+				 * supports large folios.
+				 *
+				 * Note that we might still have THPs in such
+				 * mappings, which is created from khugepaged
+				 * when CONFIG_READ_ONLY_THP_FOR_FS is
+				 * enabled. But in that case, the mapping does
+				 * not actually support large folios properly.
+				 */
+				return -EINVAL;
+			}
 		}
+
+		if (new_order < mapping_min_folio_order(folio->mapping))
+			return -EINVAL;
 	}
 
 	/*
@@ -3956,11 +3965,6 @@ static int __folio_split(struct folio *f
 		goto out;
 	}
 
-	if (new_order >= old_order) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
@@ -3984,16 +3988,9 @@ static int __folio_split(struct folio *f
 		anon_vma_lock_write(anon_vma);
 		mapping = NULL;
 	} else {
-		unsigned int min_order;
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(folio->mapping);
-		if (new_order < min_order) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
 							GFP_RECLAIM_MASK);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


