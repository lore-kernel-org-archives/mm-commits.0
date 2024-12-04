Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8DE1F542D
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352791; cv=none; b=N6SXTm3pXvsbTbYrdmO5MJhO7WCqaTu+galKgCZZFjkZwd2RP7n5jbwpSdD67R5UFYVVyujkavb5I9v4hiLJSt1JmMKDy0rw30A0W3AFc4/3G9woqMTyc3BW+ASbVnKujbcrp5KkOzFMWD7uVwqEhL8KAiVtzhv6e2/l7g6WicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352791; c=relaxed/simple;
	bh=Km0ZuPSSjcwyZosoGnfddXYZLkGIiB/4yL3P0lpTspM=;
	h=Date:To:From:Subject:Message-Id; b=aznqwQZvyjjsmdeSlp92xupvV1SyULdiiUbKvcCD+/Q2+EzRSJ8/X/sXpsinppdRD+2fGV4xF9lwKAOAY/lIcoJJJKD+5dLzN5ogAllMDM2mDuJqYKpkmsbaggY0CiamxHfBxPyv50/Aam1hbKj6S3QopNxk3Q1+qQ5GCWyKtwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HRtgsUFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HRtgsUFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9ACC4CECD;
	Wed,  4 Dec 2024 22:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352791;
	bh=Km0ZuPSSjcwyZosoGnfddXYZLkGIiB/4yL3P0lpTspM=;
	h=Date:To:From:Subject:From;
	b=HRtgsUFnxSSy1uEqe3OERb+b9WMssN+Iict6pISRH/Sc9x6aapzEZYQticqgtqW2a
	 AYfat5W5+BGdsl9LSqbJN2XE+gDROf+ADc5Im3yxBCzAScA/lD+47KAY7GgUs8mwpr
	 AtW2i+88EQ6Iwd6GmfYgxo19nhs8RMrazimaz+cE=
Date: Wed, 04 Dec 2024 14:53:10 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-zap_pte_range-handle-full-within-pmd-range.patch added to mm-unstable branch
Message-Id: <20241204225311.5D9ACC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make zap_pte_range() handle full within-PMD range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-zap_pte_range-handle-full-within-pmd-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-zap_pte_range-handle-full-within-pmd-range.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: make zap_pte_range() handle full within-PMD range
Date: Wed, 4 Dec 2024 19:09:48 +0800

In preparation for reclaiming empty PTE pages, this commit first makes
zap_pte_range() to handle the full within-PMD range, so that we can more
easily detect and free PTE pages in this function in subsequent commits.

Link: https://lkml.kernel.org/r/76c95ee641da7808cd66d642ab95841df4048295.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
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

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory.c~mm-make-zap_pte_range-handle-full-within-pmd-range
+++ a/mm/memory.c
@@ -1718,6 +1718,7 @@ static unsigned long zap_pte_range(struc
 	pte_t *pte;
 	int nr;
 
+retry:
 	tlb_change_page_size(tlb, PAGE_SIZE);
 	init_rss_vec(rss);
 	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
@@ -1757,6 +1758,13 @@ static unsigned long zap_pte_range(struc
 	if (force_flush)
 		tlb_flush_mmu(tlb);
 
+	if (addr != end) {
+		cond_resched();
+		force_flush = false;
+		force_break = false;
+		goto retry;
+	}
+
 	return addr;
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
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch

