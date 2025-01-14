Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB2122F11
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736835858; cv=none; b=nd4aV3eEs3pi7IMOwRu3pxm5UM0hnazmfv1G02ntX7TyI/c6pEI3r90Tp2KSpyY3ZCOvx1zgRGCtkA/W0N+XK9S2p0BQiFHVWDaNnC+JvJY5YvqyCISQN31Jd3IfmBbcIDoe4jsLLQJXgMIPVTvtjkyfle2H8iCcB5nfHDxruYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736835858; c=relaxed/simple;
	bh=PUyA/hHgT0VeSkhK95IGIwP6RC3PLJeXxxEzmsWP3dI=;
	h=Date:To:From:Subject:Message-Id; b=DW8i9MQHr3ECLFqLCRA9oB2EJUN9OLZVyrt21igRh5XmibJWj2WwUs13LvGV0Itg/53Nlxr336iJnvkorL7fXFbAHzDsTp9m98ZjyecGGF+Niv4B+cadyM3lLlHnl0rf3wa06a3JM1MD2DQEeFF2sPDvEyX8TH90x+MQhBnGqW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xenh6T7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xenh6T7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C887FC4CEDD;
	Tue, 14 Jan 2025 06:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736835856;
	bh=PUyA/hHgT0VeSkhK95IGIwP6RC3PLJeXxxEzmsWP3dI=;
	h=Date:To:From:Subject:From;
	b=xenh6T7EwvayTgppQaTVxJMLwjbPBo9lLaBYjVh6h4tcNhkpSfmh9LzKh9FP5INN7
	 0Ir8NOQyIRlGF39JFiIOQ4xwB3QcBRKedkEifnT0oXZgO8sESkVod1Hjb4xTh7VKLf
	 tEWkn1yK4TqmzZP2rdjIN6LupFcorHU6CpH7QLO4=
Date: Mon, 13 Jan 2025 22:24:16 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch removed from -mm tree
Message-Id: <20250114062416.C887FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch

This patch was dropped because it was folded into mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix
Date: Tue, 10 Dec 2024 16:41:56 +0800

The following WARN_ON_ONCE()s can also be expected to be triggered, so
remove them as well.

if (WARN_ON_ONCE(pmd_none(*dst_pmd)) ||  WARN_ON_ONCE(pmd_none(*src_pmd)) ||
    WARN_ON_ONCE(pmd_trans_huge(*dst_pmd)) || WARN_ON_ONCE(pmd_trans_huge(*src_pmd))

Link: https://lkml.kernel.org/r/20241210084156.89877-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix
+++ a/mm/userfaultfd.c
@@ -1193,8 +1193,8 @@ retry:
 	}
 
 	/* Sanity checks before the operation */
-	if (WARN_ON_ONCE(pmd_none(*dst_pmd)) ||	WARN_ON_ONCE(pmd_none(*src_pmd)) ||
-	    WARN_ON_ONCE(pmd_trans_huge(*dst_pmd)) || WARN_ON_ONCE(pmd_trans_huge(*src_pmd))) {
+	if (pmd_none(*dst_pmd) || pmd_none(*src_pmd) ||
+	    pmd_trans_huge(*dst_pmd) || pmd_trans_huge(*src_pmd)) {
 		err = -EINVAL;
 		goto out;
 	}
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch
mm-pgtable-add-statistics-for-p4d-level-page-table.patch
arm64-pgtable-use-mmu-gather-to-free-p4d-level-page-table.patch
s390-pgtable-add-statistics-for-pud-and-p4d-level-page-table.patch
mm-pgtable-introduce-pagetable_dtor.patch
arm-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
arm64-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
riscv-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
x86-pgtable-convert-__tlb_remove_table-to-use-struct-ptdesc.patch
x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
s390-pgtable-consolidate-pxd-and-pte-tlb-free-paths.patch
mm-pgtable-introduce-generic-__tlb_remove_table.patch
mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table.patch
mm-pgtable-move-__tlb_remove_table_one-in-x86-to-generic-file.patch
mm-pgtable-introduce-generic-pagetable_dtor_free.patch

