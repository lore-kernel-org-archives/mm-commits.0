Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3E5231845
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343231; cv=none; b=NOFnrEF8sFRQsTa9egxDDMUhEvJeJOD3oa+fLLfSbsOFcp5HscjjjnyeT+BMyd7NASvYD1fojHVMKP+7pOOpxfvGuqHSD1iK3kiTLsB29JbLZh5krSwh4Qd4LW8gNio8w+jwjz0MQ9d0tZS6pYlzvqpQ+XPEVdXcgUGGnp78W7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343231; c=relaxed/simple;
	bh=ICG8IH12e5EZ5OliOMfvAKpYnZSEtRGFTepKnrgk+ck=;
	h=Date:To:From:Subject:Message-Id; b=CylrsVsv8zHYIrZOwJlj0zC1ZtEEWJCPqoP21HasqRlRNVcBsUbDKWIivHg2YwQ9L8tXK/hWzRhVeN7FaVjsMirmFJ2tPtASQ2u+O79xoU/UIc50TT77pRvsSEkHCHX2AM0hI4mxdi9Zu474XEYleQHEPiRc4qcT1v4qksYNyds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sLf/Vve8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sLf/Vve8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E53C19423;
	Mon, 17 Nov 2025 01:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343231;
	bh=ICG8IH12e5EZ5OliOMfvAKpYnZSEtRGFTepKnrgk+ck=;
	h=Date:To:From:Subject:From;
	b=sLf/Vve8pKZI7Nn3MQd/4rDDMNZ/ikIp/J0Q5fmyFxd+OfLvihu2A/fNhCCaJDMbp
	 Enhfqziyg6H00MTkh+dkP3E9lNtQh8WZtND6PNUxHFgMqMgMxWYdsUQOptyUgX1iVg
	 4oE6CV7b92Kvu9QdTGPm7nb0Jmb8Lft57Mx6fV2o=
Date: Sun, 16 Nov 2025 17:33:50 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch removed from -mm tree
Message-Id: <20251117013351.37E53C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: optimize old_order derivation during folio splitting
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: optimize old_order derivation during folio splitting
Date: Tue, 21 Oct 2025 21:21:42 +0000

Folio splitting requires both the folio's original order (@old_order) and
the new target order (@split_order).

In the current implementation, @old_order is repeatedly retrieved using
folio_order().

However, for every iteration after the first, the folio being split is the
result of the previous split, meaning its order is already known to be
equal to the previous iteration's @split_order.

This commit optimizes the logic:

  * Instead of calling folio_order(), we now set @old_order directly to
    the value of @split_order from the previous iteration.

This change avoids unnecessary function calls and simplifies the loop
setup.

Also it removes a check for non-existent case, since for uniform splitting
we only do split when @split_order == @new_order.

Link: https://lkml.kernel.org/r/20251021212142.25766-5-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-optimize-old_order-derivation-during-folio-splitting
+++ a/mm/huge_memory.c
@@ -3402,8 +3402,8 @@ static int __split_unmapped_folio(struct
 		struct address_space *mapping, bool uniform_split)
 {
 	const bool is_anon = folio_test_anon(folio);
-	int order = folio_order(folio);
-	int start_order = uniform_split ? new_order : order - 1;
+	int old_order = folio_order(folio);
+	int start_order = uniform_split ? new_order : old_order - 1;
 	int split_order;
 
 	/*
@@ -3413,14 +3413,11 @@ static int __split_unmapped_folio(struct
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		int old_order = folio_order(folio);
 		int nr_new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
-		if (uniform_split && split_order != new_order)
-			continue;
 
 		if (mapping) {
 			/*
@@ -3447,7 +3444,13 @@ static int __split_unmapped_folio(struct
 			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
 			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
 		}
+		/*
+		 * If uniform split, the process is complete.
+		 * If non-uniform, continue splitting the folio at @split_at
+		 * as long as the next @split_order is >= @new_order.
+		 */
 		folio = page_folio(split_at);
+		old_order = split_order;
 	}
 
 	return 0;
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

