Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1498F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560076; cv=none; b=YoqcFMNTzu4qWtoGq5qw12VlPzygjGai8PIhc8DXUBiRlaiueyfDKxF7vHBQ5RRPF0Ta7zWtw+Vr42SHu7QS5YkWsCmkokpxsY135+aUrdxGOBjEwaH6NsUbKC47o+dh6qWkcAEPkbFHKoKlxdiw/EfAVwqoCx5PTvGf61CZxLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560076; c=relaxed/simple;
	bh=4IebiGXfW636BxT5k5Zwp1On01EZwxipDqdzmVqvoa8=;
	h=Date:To:From:Subject:Message-Id; b=hkVIAY0WRtHQKg3l2XbCJKRmvP6h/kaOO8B/uuKcVAIWWR+VljQ29XlLQaSvcZxKi+jT7HNusSU7OKBQxD+oNMJxVTTQiflgK1zM4+OPMRwLU4+uByvuZp+AJkj6PMna7K9XzJX0PCPPWJzh2vHF9RhyoFeFKbrr9rzyQoLI/zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nJwPxOzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nJwPxOzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39303C43399;
	Thu, 22 Feb 2024 00:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560076;
	bh=4IebiGXfW636BxT5k5Zwp1On01EZwxipDqdzmVqvoa8=;
	h=Date:To:From:Subject:From;
	b=nJwPxOzJVNkn+E+oY8ivQ8lH7Ovyyo8cB5GPcsZxZtozLLeuxIjYKvif9YO32BcPd
	 YfCb/jFBBTAj06uuimNJHUiBZ1srcT8/0Vcp3qxhquZ+3Rr8G6sKRMF7aaiubZM/1I
	 5xs4QyzZi5F0jaqp9q14OMzX0r+e82MQNNZ9Xvx0=
Date: Wed, 21 Feb 2024 16:01:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch removed from -mm tree
Message-Id: <20240222000116.39303C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390: use pfn_swap_entry_folio() in ptep_zap_swap_entry()
has been removed from the -mm tree.  Its filename was
     s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: s390: use pfn_swap_entry_folio() in ptep_zap_swap_entry()
Date: Thu, 11 Jan 2024 15:24:23 +0000

Call pfn_swap_entry_folio() in ptep_zap_swap_entry() as preparation for
converting mm counter functions to take a folio.

Link: https://lkml.kernel.org/r/20240111152429.3374566-5-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/pgtable.c~s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry
+++ a/arch/s390/mm/pgtable.c
@@ -721,9 +721,9 @@ static void ptep_zap_swap_entry(struct m
 	if (!non_swap_entry(entry))
 		dec_mm_counter(mm, MM_SWAPENTS);
 	else if (is_migration_entry(entry)) {
-		struct page *page = pfn_swap_entry_to_page(entry);
+		struct folio *folio = pfn_swap_entry_folio(entry);
 
-		dec_mm_counter(mm, mm_counter(page));
+		dec_mm_counter(mm, mm_counter(&folio->page));
 	}
 	free_swap_and_cache(entry);
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-early-termination-in-compact_nodes.patch

