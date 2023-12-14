Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933FF6979A
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="chMXJ06d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA68AC433C7;
	Thu, 14 Dec 2023 19:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702582539;
	bh=7p5zIQfvXzRtYx2u5ZjOUTIjdzbJTkKi6E8nsE6x2XE=;
	h=Date:To:From:Subject:From;
	b=chMXJ06dH0j+Tm+V+h2sx8QVDypLvV8DxcYXzR/dwCgEZ533WDrGc3J78tAeuDKkR
	 7UbNOU0peihRT6i1oxkDnTgrB91QcU8SrbE/ZvruWN6o6svmiSDy4j1ka+A7ZAawpK
	 zYVYeGeDjV6MkGczAIzYmzAi7cPPQ9UtafE6J9oA=
Date: Thu, 14 Dec 2023 11:35:38 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,vbabka@suse.cz,shy828301@gmail.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch added to mm-unstable branch
Message-Id: <20231214193538.DA68AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: resolve some multi-size THP review nits
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch

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
mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch
selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

