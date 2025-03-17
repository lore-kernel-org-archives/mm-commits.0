Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B63101FF;
	Mon, 17 Mar 2025 00:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172080; cv=none; b=q34e8SaPU55KJaNazdFLc/UILWOb6xeDNp04cIOjfqwB9RRGotyMHHq9d1SYNGdCFrygHZ2zo4vuB7TN8wqjyXWAf4APdJEmqjIa6Ty9Py/4pGKe85bpenfsyNw2xu/3llfCOE3U6t2+ob5ERIH3JRy3sCtfJ2lkhGXK0+iGPZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172080; c=relaxed/simple;
	bh=bUduSwK0mhHk6Zcl4AIlFTdPtDHGWkTxhijQh3dbKPM=;
	h=Date:To:From:Subject:Message-Id; b=KuNDgytz4cUW2vs+xVlV74kan60Y49YytwFH8eMoGX3AaBQDWGOucQJObk7f7mFbjiB0lfrTTViQmj8d6jlUtHTFd/+4+J6cnVxKStJT5+20ZKqvf2QMJUhrSg2DtSxQUtsIKUpQLThDHm8tFHkC4IVN19gihB99ar/JY/GvSHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yHmcD8xS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yHmcD8xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D36C4CEDD;
	Mon, 17 Mar 2025 00:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172079;
	bh=bUduSwK0mhHk6Zcl4AIlFTdPtDHGWkTxhijQh3dbKPM=;
	h=Date:To:From:Subject:From;
	b=yHmcD8xS5hqcCuhrf71dAmh5fNSt9+g/oAOZJO1DhF+P4kDZx9cExzgPFh6W06PFQ
	 FqieKtGSFAW7LpsiFGDS6W6xI8FeurdpLPQhUO+kF0dpQSDkQnNcwrouWtSp0qorYr
	 +DpfQikZZndznjXsLJbiSkKf9EtVTGdDsgcVh2AM=
Date: Sun, 16 Mar 2025 17:41:19 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,ryan.roberts@arm.com,p.raghav@samsung.com,mcgrof@kernel.org,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs.patch removed from -mm tree
Message-Id: <20250317004119.A8D36C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: drop beyond-EOF folios with the right number of refs
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: drop beyond-EOF folios with the right number of refs
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

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

