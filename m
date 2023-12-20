Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD934C627
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V/dSuc04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DB6C433C7;
	Wed, 20 Dec 2023 22:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112546;
	bh=5Zq6mRlmCk/YVEIs90ZbUtYiyy3/cvmy/fHTjMfE4RY=;
	h=Date:To:From:Subject:From;
	b=V/dSuc0450jIUSa6iouCRfx1f4m7aeH2rNOVns3cHVGAsEsrt9P22EmqNU2sUygFT
	 Jf8XH9hiprLvabQZBZnH8jbsfROVl9KwhAXhOO+jToNQQVmFoWJhIAZHgvbtRipA9T
	 hB+h6mCBU0tzxlNDtuW0+X52winIKoFXKs2SiCXI=
Date: Wed, 20 Dec 2023 14:49:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,vbabka@suse.cz,shy828301@gmail.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch removed from -mm tree
Message-Id: <20231220224906.14DB6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
Date: Thu, 7 Dec 2023 16:12:03 +0000

In preparation for supporting anonymous multi-size THP, improve
folio_add_new_anon_rmap() to allow a non-pmd-mappable, large folio to be
passed to it.  In this case, all contained pages are accounted using the
order-0 folio (or base page) scheme.

Link: https://lkml.kernel.org/r/20231207161211.2374093-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/mm/rmap.c~mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -1305,32 +1305,44 @@ void page_add_anon_rmap(struct page *pag
  * This means the inc-and-test can be bypassed.
  * The folio does not have to be locked.
  *
- * If the folio is large, it is accounted as a THP.  As the folio
+ * If the folio is pmd-mappable, it is accounted as a THP.  As the folio
  * is new, it's assumed to be mapped exclusively by a single process.
  */
 void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		unsigned long address)
 {
-	int nr;
+	int nr = folio_nr_pages(folio);
 
-	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
+	VM_BUG_ON_VMA(address < vma->vm_start ||
+			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
 	__folio_set_swapbacked(folio);
+	__folio_set_anon(folio, vma, address, true);
 
-	if (likely(!folio_test_pmd_mappable(folio))) {
+	if (likely(!folio_test_large(folio))) {
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_mapcount, 0);
-		nr = 1;
+		SetPageAnonExclusive(&folio->page);
+	} else if (!folio_test_pmd_mappable(folio)) {
+		int i;
+
+		for (i = 0; i < nr; i++) {
+			struct page *page = folio_page(folio, i);
+
+			/* increment count (starts at -1) */
+			atomic_set(&page->_mapcount, 0);
+			SetPageAnonExclusive(page);
+		}
+
+		atomic_set(&folio->_nr_pages_mapped, nr);
 	} else {
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_entire_mapcount, 0);
 		atomic_set(&folio->_nr_pages_mapped, COMPOUND_MAPPED);
-		nr = folio_nr_pages(folio);
+		SetPageAnonExclusive(&folio->page);
 		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr);
 	}
 
 	__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
-	__folio_set_anon(folio, vma, address, true);
-	SetPageAnonExclusive(&folio->page);
 }
 
 /**
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

