Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F13199FBA;
	Mon, 10 Mar 2025 23:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741649442; cv=none; b=DUa2tjrfoLY7GqPbTgaABi5NPKL0fHz39aEPYsYQ8K8kFjwL6TTDgefCGDsAPJRySPZZ8rKPn2CGp5K+nhlJwTyClEeo6FNbDzjoh21+bYgBQ0jLZtB6djkYFAP/ikkB99w4tvUMrFG3TtTia1bO8jc9Afi3aBiAKwnWgru6Znc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741649442; c=relaxed/simple;
	bh=VW/yce6cO+8wFuBPmE5HUL0/Q1Zvaq8pJGaRAP71bUc=;
	h=Date:To:From:Subject:Message-Id; b=RfeluxWTcqwt/SRPSUSKbRs9Bo258aCdHT5djBybVJqMC9I4IeyzkLQa2GXPRnDKeh3tvme9ZyxHVcxFR6T2Hx9wuWbvWlnVxSyGrH35b/64j8YD4G9fOgtVUTp7hOAw/fllsmBAP0oOxTy2io4nBBLsevDusPUHLwfkuA8ugLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=doCY0vjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="doCY0vjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DF7C4CEE5;
	Mon, 10 Mar 2025 23:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741649442;
	bh=VW/yce6cO+8wFuBPmE5HUL0/Q1Zvaq8pJGaRAP71bUc=;
	h=Date:To:From:Subject:From;
	b=doCY0vjpe+/POupCmdS0dBTujAIExcPcNRy2cem7rrkuvFQGzRZ5z1K27YxpTzN98
	 yd6/C2XqaXv0Y1OnQEwUC+A6Jx68DogyrxrNw/GcSunERUFb0xiNqUI3t19tz0Fe2b
	 kj/Zkr327iCPFwLx7i+keEh/eGOD3t9m8xbF/HP4=
Date: Mon, 10 Mar 2025 16:30:41 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,ryan.roberts@arm.com,p.raghav@samsung.com,mcgrof@kernel.org,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs.patch added to mm-hotfixes-unstable branch
Message-Id: <20250310233042.11DF7C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: drop beyond-EOF folios with the right number of refs.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: drop beyond-EOF folios with the right number of refs.
Date: Mon, 10 Mar 2025 11:57:27 -0400

When an after-split folio is large and needs to be dropped due to EOF,
folio_put_refs(folio, folio_nr_pages(folio)) should be used to drop all
page cache refs.  Otherwise, the folio will not be freed, causing memory
leak.

This leak would happen on a filesystem with blocksize > page_size and a
truncate is performed, where the blocksize makes folios split to >0 order
ones, causing truncated folios not being freed.

Link: https://lkml.kernel.org/r/20250310155727.472846-1-ziy@nvidia.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Hugh Dickins <hughd@google.com>
Closes: https://lore.kernel.org/all/fcbadb7f-dd3e-21df-f9a7-2853b53183c4@google.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs
+++ a/mm/huge_memory.c
@@ -3304,7 +3304,7 @@ static void __split_huge_page(struct pag
 				folio_account_cleaned(tail,
 					inode_to_wb(folio->mapping->host));
 			__filemap_remove_folio(tail, NULL);
-			folio_put(tail);
+			folio_put_refs(tail, folio_nr_pages(tail));
 		} else if (!folio_test_anon(folio)) {
 			__xa_store(&folio->mapping->i_pages, tail->index,
 					tail, 0);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-fix-shmem-xarray-update-during-migration.patch
mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs.patch
selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

