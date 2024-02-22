Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3B98F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560075; cv=none; b=FF6KDtqh7S++t+FojblJVjLsVPINzU+uFwkVoTy59uRcH+yEXzixGm+vM3/wqmon0rnncTzMa/lQ3S3lXZ+j92spocg9UgTLiCE/4tvhMB8628z7GPkHXLHRrqLXzYr737IHF+9OzaFkRRRNVVAr5V/ejbyKPi4pqzLw4fYuzWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560075; c=relaxed/simple;
	bh=J1ImISoaQcl8SZ2Gp6AWaf3oqKsZblWtIDZojBrLLX4=;
	h=Date:To:From:Subject:Message-Id; b=ZA4d62LKGW7QAJZV5jZ7Bh3VbQ99E3nBX0QzvxIvGcGYiDnAtGqHApjwgaxGNIdycsHbhWtMhQ3Qmfgzfqxo2aqxd5VdOA/b1rZjNP0UZBJKXP1Youb3vwDgctP+791mT57sebBEWhvddk41cLuA+YX6V6HnQ4RQilOupJEJmEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtWSEsxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtWSEsxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC91C433A6;
	Thu, 22 Feb 2024 00:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560075;
	bh=J1ImISoaQcl8SZ2Gp6AWaf3oqKsZblWtIDZojBrLLX4=;
	h=Date:To:From:Subject:From;
	b=rtWSEsxD3VAgwBRz/AB70eczrJWcgX4ripl+qiFm00OOnSP3WmFhUlsBVHVKnCiqB
	 ppX2YuOMj8uquhnTGKPokLFDUWbTOvdVsoYyuwBObcLlR5Qt842AiibfkHyk267I2p
	 5MhQUv9+6MbV+h1JSEz6KhJQHfV8fJiSNKO0pY/c=
Date: Wed, 21 Feb 2024 16:01:14 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mprotect-use-pfn_swap_entry_folio.patch removed from -mm tree
Message-Id: <20240222000115.4FC91C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mprotect: use pfn_swap_entry_folio
has been removed from the -mm tree.  Its filename was
     mprotect-use-pfn_swap_entry_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mprotect: use pfn_swap_entry_folio
Date: Thu, 11 Jan 2024 15:24:22 +0000

We only want to know whether the folio is anonymous, so use
pfn_swap_entry_folio() and save a call to compound_head().

Link: https://lkml.kernel.org/r/20240111152429.3374566-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mprotect.c~mprotect-use-pfn_swap_entry_folio
+++ a/mm/mprotect.c
@@ -198,13 +198,13 @@ static long change_pte_range(struct mmu_
 			pte_t newpte;
 
 			if (is_writable_migration_entry(entry)) {
-				struct page *page = pfn_swap_entry_to_page(entry);
+				struct folio *folio = pfn_swap_entry_folio(entry);
 
 				/*
 				 * A protection check is difficult so
 				 * just be safe and disable write
 				 */
-				if (PageAnon(page))
+				if (folio_test_anon(folio))
 					entry = make_readable_exclusive_migration_entry(
 							     swp_offset(entry));
 				else
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

