Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0AF8F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560077; cv=none; b=WHvcqx/oa3h7iNjG6qiubyGhnIbjfkmmFA0Dxj3o8KmYun83OZnyaQRIMFoE5lCzjWYOU7YSVSnLAqBODoQod4KjK8UUPQM+ismyBOwepCVT9CW02jdZPhh0h6NLrwSp0/GRnf7QgP2MUG93GFFTzH0juIYuXtefwp4/0CobafA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560077; c=relaxed/simple;
	bh=13oZFoir2dnEcPTWffprpgBMSuppL0Z2FiOkPfAdgI4=;
	h=Date:To:From:Subject:Message-Id; b=jNjo4/LcKR48/UjqFqcTPqKb48OSzLE7dg5UPpdABsThbDubQYVxns1gyOQYIus49TdVI5MxsxfRP4kW+uB6AQvHJyu2Cv0Mi47fZQahnkc4lqb4FzoVYyatp8ERWYxms4RL2cu9W6MDKLY/vdo5HmVokhKPRuKZkfqY57E5TvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Er//rPE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Er//rPE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1D7C43394;
	Thu, 22 Feb 2024 00:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560077;
	bh=13oZFoir2dnEcPTWffprpgBMSuppL0Z2FiOkPfAdgI4=;
	h=Date:To:From:Subject:From;
	b=Er//rPE+tUjDaMwrNjE2bz4x1DTUp+W81rYQ88UnvnwU8FXwH02hLnUTirIbsc2g/
	 TleEBEG7RtfTT3SsRzfNujD5x4TUIcpxctIPAobmtafdEbu6cLOhFSKUj0VSGHRKaY
	 Z6Tqqf/+zaV7/46E55EpWIekKrn0pGVkBPoBDTw4=
Date: Wed, 21 Feb 2024 16:01:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch removed from -mm tree
Message-Id: <20240222000117.1C1D7C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use pfn_swap_entry_folio() in __split_huge_pmd_locked()
has been removed from the -mm tree.  Its filename was
     mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use pfn_swap_entry_folio() in __split_huge_pmd_locked()
Date: Thu, 11 Jan 2024 15:24:24 +0000

Call pfn_swap_entry_folio() in __split_huge_pmd_locked() as preparation
for converting mm counter functions to take a folio.

Link: https://lkml.kernel.org/r/20240111152429.3374566-6-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -2442,7 +2442,7 @@ static void __split_huge_pmd_locked(stru
 			swp_entry_t entry;
 
 			entry = pmd_to_swp_entry(old_pmd);
-			page = pfn_swap_entry_to_page(entry);
+			folio = pfn_swap_entry_folio(entry);
 		} else {
 			page = pmd_page(old_pmd);
 			folio = page_folio(page);
@@ -2453,7 +2453,7 @@ static void __split_huge_pmd_locked(stru
 			folio_remove_rmap_pmd(folio, page, vma);
 			folio_put(folio);
 		}
-		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
+		add_mm_counter(mm, mm_counter_file(&folio->page), -HPAGE_PMD_NR);
 		return;
 	}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-early-termination-in-compact_nodes.patch

