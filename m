Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0482C58128
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYcHRc8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1D8C43390;
	Thu, 11 Jan 2024 20:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705005155;
	bh=HdJIO1KcUFQWVob/4yq/O2+EGw5rRNPQnd3cmX9C9X4=;
	h=Date:To:From:Subject:From;
	b=IYcHRc8SyhQwBYreZvhafRtd/IWk2VWv/On5xxAnFe7k40eGdNZUMfM3sLiXwf5NY
	 TB2/ZwS9ZRSmzZMsBY55azXG+SCB0DgGfhZla7YRGeIDhljjU32wSkERPJY/pXkPT0
	 +vn7X2cENfthghDO+k6Z5f5tlsFJK84olmDasLdk=
Date: Thu, 11 Jan 2024 12:32:35 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mprotect-use-pfn_swap_entry_folio.patch added to mm-unstable branch
Message-Id: <20240111203235.BF1D8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mprotect: use pfn_swap_entry_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mprotect-use-pfn_swap_entry_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mprotect-use-pfn_swap_entry_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
mm-add-pfn_swap_entry_folio.patch
proc-use-pfn_swap_entry_folio-where-obvious.patch
mprotect-use-pfn_swap_entry_folio.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

