Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D71E4A988
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CXg3uSa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB55AC433C8;
	Wed, 20 Dec 2023 22:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703111970;
	bh=f1PDSbpcfcWLh9+Yt81YcXgO2lFKbTWYsaZLlZB8Iak=;
	h=Date:To:From:Subject:From;
	b=CXg3uSa6N4ebExIM6kVuUhTtLZojw4dn6K384enRxAtfpcRRowVpiZ4X4Tsa800LG
	 14fVNvSq2eb+qdKz3VoaSNdCtRBR2nTib4mgZ0gxyzmWHHC02tPHLtYU3IjX1lONKn
	 WAU9rv+7QBK5hdyao0HgmOe9guXxkEP0nndGOYDg=
Date: Wed, 20 Dec 2023 14:39:30 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,vbabka@suse.cz,shy828301@gmail.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch removed from -mm tree
Message-Id: <20231220223930.DB55AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: resolve some multi-size THP review nits
has been removed from the -mm tree.  Its filename was
     mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch

This patch was dropped because it was folded into mm-thp-support-allocation-of-anonymous-multi-size-thp.patch

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: resolve some multi-size THP review nits
Date: Thu, 14 Dec 2023 16:02:51 +0000

Tidy code based on review feedback for final version of multi-size THP:

 - Comment added to explain alloc_anon_folio() error protocol
 - ifdefery simplified for alloc_anon_folio()

Link: https://lkml.kernel.org/r/20231214160251.3574571-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-thp-support-allocation-of-anonymous-multi-size-thp-fix
+++ a/mm/memory.c
@@ -4137,9 +4137,9 @@ static bool pte_range_none(pte_t *pte, i
 	return true;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long orders;
 	struct folio *folio;
@@ -4199,12 +4199,9 @@ static struct folio *alloc_anon_folio(st
 	}
 
 fallback:
-	return vma_alloc_zeroed_movable_folio(vma, vmf->address);
-}
-#else
-#define alloc_anon_folio(vmf) \
-		vma_alloc_zeroed_movable_folio((vmf)->vma, (vmf)->address)
 #endif
+	return vma_alloc_zeroed_movable_folio(vmf->vma, vmf->address);
+}
 
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
@@ -4260,6 +4257,7 @@ static vm_fault_t do_anonymous_page(stru
 	/* Allocate our own private page. */
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
+	/* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the fault */
 	folio = alloc_anon_folio(vmf);
 	if (IS_ERR(folio))
 		return 0;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch
selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

