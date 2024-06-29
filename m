Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C1F3FC2
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628218; cv=none; b=EiZtEsuu3IVxN1x6CzeeB0YEKVmmmQqxKW2BRzMtTrxz4qpliIrXKMobZ5fCcUmVdR9hwDutlRwxg/9PI8csSN7LtwkH1dI1rvONaQMXq3JEHp4b/k3BJV2gisJCX+FfM3+yj88yF5h8dEaZ4L9T9A+mRDe2lQVALddSPbTl/N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628218; c=relaxed/simple;
	bh=Zqa8m6/mBkBNczWtqOAOinzU6QVITya8Z1UxWbf8x4c=;
	h=Date:To:From:Subject:Message-Id; b=lW/oMKlhMFE21E4jjrkEUuirRKdLf8BOoA+MxQ1oVgKJc8Gc03du7eBK9ylK+puiJIw0w+jJo5sSY17VeAjv1HuvvFuYZ5vSW0nAR+8kcutNOTuN6+4vb+KkXBWRtLHR6tsQeSSZXuu+a3BWtUQqW/oG+8DSz3k/yqE5nG1bkHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TaBjJrnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TaBjJrnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD771C116B1;
	Sat, 29 Jun 2024 02:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628217;
	bh=Zqa8m6/mBkBNczWtqOAOinzU6QVITya8Z1UxWbf8x4c=;
	h=Date:To:From:Subject:From;
	b=TaBjJrnviXj6JQELzFbBoA4TI+m5DQ3g208/jhYB3XIZpRB2Gk7xtmC15sBpgjp7T
	 qgxc53b5/pEIzYsVUY6FvCbK0QIN+G1gkd+Av77Z2za4ozlaY7fpqP7edrafsmURnn
	 eT7oN/gHVsgsnMrMgTp25kgCSgtUhwjSF8mHOkp4=
Date: Fri, 28 Jun 2024 19:30:17 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch removed from -mm tree
Message-Id: <20240629023017.AD771C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove folio_test_anon(folio)==false path in __folio_add_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: remove folio_test_anon(folio)==false path in __folio_add_anon_rmap()
Date: Tue, 18 Jun 2024 11:11:37 +1200

The folio_test_anon(folio)==false cases has been relocated to
folio_add_new_anon_rmap().  Additionally, four other callers consistently
pass anonymous folios.

stack 1:
remove_migration_pmd
   -> folio_add_anon_rmap_pmd
     -> __folio_add_anon_rmap

stack 2:
__split_huge_pmd_locked
   -> folio_add_anon_rmap_ptes
      -> __folio_add_anon_rmap

stack 3:
remove_migration_pmd
   -> folio_add_anon_rmap_pmd
      -> __folio_add_anon_rmap (RMAP_LEVEL_PMD)

stack 4:
try_to_merge_one_page
   -> replace_page
     -> folio_add_anon_rmap_pte
       -> __folio_add_anon_rmap

__folio_add_anon_rmap() only needs to handle the cases
folio_test_anon(folio)==true now.
We can remove the !folio_test_anon(folio)) path within
__folio_add_anon_rmap() now.

Link: https://lkml.kernel.org/r/20240617231137.80726-4-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: Shuai Yuan <yuanshuai@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/mm/rmap.c~mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap
+++ a/mm/rmap.c
@@ -1297,23 +1297,12 @@ static __always_inline void __folio_add_
 {
 	int i, nr, nr_pmdmapped = 0;
 
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
 	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
 
-	if (unlikely(!folio_test_anon(folio))) {
-		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
-		/*
-		 * For a PTE-mapped large folio, we only know that the single
-		 * PTE is exclusive. Further, __folio_set_anon() might not get
-		 * folio->index right when not given the address of the head
-		 * page.
-		 */
-		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
-				 level != RMAP_LEVEL_PMD, folio);
-		__folio_set_anon(folio, vma, address,
-				 !!(flags & RMAP_EXCLUSIVE));
-	} else if (likely(!folio_test_ksm(folio))) {
+	if (likely(!folio_test_ksm(folio)))
 		__page_check_anon_rmap(folio, page, vma, address);
-	}
 
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

