Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F102B76408
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102953; cv=none; b=Qi6OeZf9wQDMLPW4O5e6ADB6g7sRPavAPiz9Gfcuu/Q8c07rX6zVnY3vBXUNaC1F2JxHHyEBHUGEf6vwo+P+LPvsJLtxFneZKozhSwXaRz113w1un9Hfbco3r8gkOG1W4Mbg6FySO7rMH70I5LHojfW9TtE+41JSVXdITcZaHKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102953; c=relaxed/simple;
	bh=PkcuhpTgAX53wNEm3GXeqigiAY3Js/RAeaXqBuI4wfE=;
	h=Date:To:From:Subject:Message-Id; b=s8+bVtsBsx5pQRNd75Osu7xZDVtZmU47Mc/Le8Yt9ATobGyDNMsT1eLOhpDeFAEMibO/bnuGKqOgcVtTNRGq7bxbDt/EcavrO182II+z4wBykWTMXdYvghKRfY3kSvNJLdkU1aG1Z0EL+W9b19N5ILrvLSQORFgxrJoAkCwZHNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s92G4weF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s92G4weF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792C0C113CD;
	Fri, 26 Apr 2024 03:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102952;
	bh=PkcuhpTgAX53wNEm3GXeqigiAY3Js/RAeaXqBuI4wfE=;
	h=Date:To:From:Subject:From;
	b=s92G4weF4mShLUBCOvZDAApuCCnGj3QguXi4Pz69vw036DDlTxMpdRLTvy/0Q3I4G
	 gtOMligY7NpEmdQ8oKqUdDuqLH8/kXU9SxaFq6VNK5pbg9LL3Ki5wtoan77CGyeujj
	 AyzG3LndAFCVtXaptoZJarPHxVN6hfUJwc/3no0Y=
Date: Thu, 25 Apr 2024 20:42:31 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,ioworker0@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2.patch removed from -mm tree
Message-Id: <20240426034232.792C0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2.patch

This patch was dropped because it was folded into mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2
Date: Mon, 22 Apr 2024 15:33:43 +0800

check the THP earlier in case the folio is split, per Lance

Link: https://lkml.kernel.org/r/b99f8cb14bc85fdb6ab43721d1331cb5ebed2581.1713771041.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2
+++ a/mm/huge_memory.c
@@ -2934,6 +2934,7 @@ int split_huge_page_to_list_to_order(str
 	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_order);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	bool is_thp = folio_test_pmd_mappable(folio);
 	int extra_pins, ret;
 	pgoff_t end;
 	bool is_hzp;
@@ -3112,7 +3113,7 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (folio_test_pmd_mappable(folio))
+	if (is_thp)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch
mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch
mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

