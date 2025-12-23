Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797152E6CD0
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766508660; cv=none; b=mC+SHIsGJAp0T2aj1SrFtnsu7hOKi8dIhwPWZCS/t7P62r4AC+2Ow0RQ8oGxw7XOSW8oQhpB8JMxPIQ23wsLZeORLhDCF/2/0gMKaGNbn+kLXTBRf56n8II62Dkxftilh2zBYybwE7bWhUP4cmlKtEVw0gP4jRh7pY39GykU0PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766508660; c=relaxed/simple;
	bh=f7F2SEjK9rMltxq5Ycxjj57Osg0nXNZgIsjVsnBpML0=;
	h=Date:To:From:Subject:Message-Id; b=h0RXUBjbqKExKvW89aaWo5lcV5Zo/3KmF65oumkKyZNz86fW3A+fiRuF1Dve7vOCcikZSmlJdoFcurOwmKWy4BrsdqmaQD2I+/HYyjJBL8MKtwOJtglF8ctvLkjnAsTU6b+r2ZiVU2Cxs+f7C7b5ijNmQ7rSA1/coz52OqWO15E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=do+3c9pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="do+3c9pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB29C116D0;
	Tue, 23 Dec 2025 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766508658;
	bh=f7F2SEjK9rMltxq5Ycxjj57Osg0nXNZgIsjVsnBpML0=;
	h=Date:To:From:Subject:From;
	b=do+3c9pqmqM7EoarhrXPjXUCsCYnbWJZ5L+WYgMYsMMWV9zKkKlOB5weoeKFK1V9o
	 mONfgqD61frOV+W5AAZAdj0zWj0B0aFx8mWWNTNKGe6aSs/frcy2gcuW7ab9usHFhC
	 LNsLxSicE/9kKb2gSEYichd0gS9Wqukrk/LP9exk=
Date: Tue, 23 Dec 2025 08:50:57 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch added to mm-new branch
Message-Id: <20251223165057.EBB29C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: consolidate order-related checks into folio_check_splittable()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch

