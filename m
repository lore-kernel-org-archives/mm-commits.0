Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22335CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957007; cv=none; b=pNL3rKFn2DiG8YmN9eJtOJGF0CrVP5rKv+IwC4oUmwxqn27906Qa0HYIPe1vxFCnUJwjDicd7iUTm0+dy5xNtFCOTXO+nlp5PDHnSI69YRMc3XhQbcDkSgarbSQMN/vVipGhykvwBL8YvMDKgg+CGj0avPKxFgwew/NY7pGQ02I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957007; c=relaxed/simple;
	bh=2LzdNaD5d4HrnGgVzomBwNenplUJr4AKYj53cfsZDkM=;
	h=Date:To:From:Subject:Message-Id; b=HM8B2stEVdtxCwHQpFzKz0NvsOOXrRZ15Hg7E7Gp5nzoarS4CPZBkBOpJc21/yQ2i03fWd5c8FQvUXbpdGmcipD0CPEtA0jVzq8oOCNM4XyFSbjLr/kWWIZeHL80h/2dKFPe0HNY1wCDuf95HCrYBz3djZImzPFLpEqGyMb8cJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cn9YLRVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cn9YLRVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86526C113CC;
	Mon,  6 May 2024 00:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957007;
	bh=2LzdNaD5d4HrnGgVzomBwNenplUJr4AKYj53cfsZDkM=;
	h=Date:To:From:Subject:From;
	b=Cn9YLRVyFBiVYW5aZFIgLR6YmgQxk5/ZRgYXEWhN0m3q8eWHyCq5OkVXFn0KtQkl0
	 0L0nWe/viCccDdya83k5BLNT7emEai38NsRrLfk+DdN/5KlyO7/O5Go0TnxXZZgJ29
	 vG/6hsL4rRuaF+DsdWc9vip4vQD20iYMV32CS43M=
Date: Sun, 05 May 2024 17:56:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch removed from -mm tree
Message-Id: <20240506005647.86526C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: use folio_mapped() in __alloc_contig_migrate_range()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: use folio_mapped() in __alloc_contig_migrate_range()
Date: Tue, 9 Apr 2024 21:22:53 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.

For tracing purposes, we use page_mapcount() in
__alloc_contig_migrate_range().  Adding that mapcount to total_mapped
sounds strange: total_migrated and total_reclaimed would count each page
only once, not multiple times.

But then, isolate_migratepages_range() adds each folio only once to the
list.  So for large folios, we would query the mapcount of the first page
of the folio, which doesn't make too much sense for large folios.

Let's simply use folio_mapped() * folio_nr_pages(), which makes more sense
as nr_migratepages is also incremented by the number of pages in the folio
in case of successful migration.

Link: https://lkml.kernel.org/r/20240409192301.907377-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range
+++ a/mm/page_alloc.c
@@ -6347,8 +6347,12 @@ int __alloc_contig_migrate_range(struct
 
 		if (trace_mm_alloc_contig_migrate_range_info_enabled()) {
 			total_reclaimed += nr_reclaimed;
-			list_for_each_entry(page, &cc->migratepages, lru)
-				total_mapped += page_mapcount(page);
+			list_for_each_entry(page, &cc->migratepages, lru) {
+				struct folio *folio = page_folio(page);
+
+				total_mapped += folio_mapped(folio) *
+						folio_nr_pages(folio);
+			}
 		}
 
 		ret = migrate_pages(&cc->migratepages, alloc_migration_target,
_

Patches currently in -mm which might be from david@redhat.com are


