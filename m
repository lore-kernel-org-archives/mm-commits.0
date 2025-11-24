Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD74938D;
	Mon, 24 Nov 2025 22:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023166; cv=none; b=G9sn/zF3PDjKT9nWhr+oHkj4Rjiuf1tIaq9X2887kFhpjQ6Bqr9MArVQLHZbxxtVr57Z2ym+tNx3Qxds1nI4wdCYtE2HblUSSj1KV9U7qTU4FE/euOkvGjdQBI5954mr1xYrhHsxDRuBWy1jw9HJS+h9Mq0V24+z2knbNOfhAwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023166; c=relaxed/simple;
	bh=To/vzHh+1qqeWteYZ2ek7LMdf07fu3XalIcDP4wGZs0=;
	h=Date:To:From:Subject:Message-Id; b=hneZ/ASynRhlAcpH9imoSqn6LRwx+iPyduFbTSyJjhS3D5D5zzZM/RDuBiIQc4kdv+ZtTzUPabhWi4mjL0Q1rKKEEpX0EMdFiq1GGlbfTBvX2DTrSrxFcGrZhQhCqTc46qOTNwDQ8rOcTM3kQQ8ACpr/uKxAa+zsgWI+feawhgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BTVvDtMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BTVvDtMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A089EC16AAE;
	Mon, 24 Nov 2025 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023166;
	bh=To/vzHh+1qqeWteYZ2ek7LMdf07fu3XalIcDP4wGZs0=;
	h=Date:To:From:Subject:From;
	b=BTVvDtMAgDY5yslP4usSWa1l0QEday3A5IWuPHBkxUNFx3XAKgDTBAYJt2yvxK6OB
	 4V/SgWHiLcXlbxHnN5S+gp0h7SgdWCLMC3nUBrME0kuwFHBxRgxi3mX8A+Ky+ahhZ+
	 gi4cgyQub+aCFuta35taeSwIpan+GJYLI2562m2Y=
Date: Mon, 24 Nov 2025 14:26:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-fix-null-pointer-deference-when-splitting-folio.patch removed from -mm tree
Message-Id: <20251124222606.A089EC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix NULL pointer deference when splitting folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-null-pointer-deference-when-splitting-folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: fix NULL pointer deference when splitting folio
Date: Wed, 19 Nov 2025 23:53:02 +0000

Commit c010d47f107f ("mm: thp: split huge page to any lower order pages")
introduced an early check on the folio's order via mapping->flags before
proceeding with the split work.

This check introduced a bug: for shmem folios in the swap cache and
truncated folios, the mapping pointer can be NULL.  Accessing
mapping->flags in this state leads directly to a NULL pointer dereference.

This commit fixes the issue by moving the check for mapping != NULL before
any attempt to access mapping->flags.

Link: https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-null-pointer-deference-when-splitting-folio
+++ a/mm/huge_memory.c
@@ -3619,6 +3619,16 @@ static int __folio_split(struct folio *f
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse shmem folios that are in the
+	 * swapcache.
+	 */
+	if (!is_anon && !folio->mapping)
+		return -EBUSY;
+
 	if (new_order >= folio_order(folio))
 		return -EINVAL;
 
@@ -3659,18 +3669,6 @@ static int __folio_split(struct folio *f
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-
-		/* Truncated ? */
-		/*
-		 * TODO: add support for large shmem folio in swap cache.
-		 * When shmem is in swap cache, mapping is NULL and
-		 * folio_test_swapcache() is true.
-		 */
-		if (!mapping) {
-			ret = -EBUSY;
-			goto out;
-		}
-
 		min_order = mapping_min_folio_order(folio->mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch
mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch
mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch
mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch

