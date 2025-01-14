Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9BA22F11
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736835911; cv=none; b=a3mZJ8nek4+0XzQ0ECjY/eD+s97PA+taWONSK00RMWZWCM/cvcFvKHKMAMi9X/6vh94YHAHvz/QfWvRSNUaq0V8dVI3G78FreJCSFDTU31tfQT14rl2xJEAoGbAEQFHPqA8vJucrk1R438Ih4PD39MSm7965BQNrMQCR5a67SLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736835911; c=relaxed/simple;
	bh=9XmTgjbEjbE2yNh2uUkdozgEY4UekTDoUrkvdwH63gE=;
	h=Date:To:From:Subject:Message-Id; b=RJzZncfRAZKkRvUJ12zhjVJu+RzrjOh2O4Abkren58WKGwWwdWNuvyUaORHOsIpMydUc7sUHWhjMS5ejJPcY4Z0fOkFmg00ZoVzziOXSOHd0yQIZ3T9dyxufTpSkKbtDvrnZxCRq2H+wzKZN3SYcczQI9NfUBTPHh7meUfMxY+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I+2Yx7Ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I+2Yx7Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F94CC4CEDD;
	Tue, 14 Jan 2025 06:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736835911;
	bh=9XmTgjbEjbE2yNh2uUkdozgEY4UekTDoUrkvdwH63gE=;
	h=Date:To:From:Subject:From;
	b=I+2Yx7CkjMrw1ECpW6rOFGgUioxyV+zt5lvxC3Qwgnbn5ELpQ0JwWOJ9LzyuLN9my
	 +5garl/OZ+pT55ZU4UErn36GEh4T9nTClvJ07/3NAUdfg+scgXpXW4yr3VPWh9PI4o
	 RGcbN+R+znthPh02ornKLNehYcwyoyDd8l5SEW9E=
Date: Mon, 13 Jan 2025 22:25:10 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch removed from -mm tree
Message-Id: <20250114062511.0F94CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix
has been removed from the -mm tree.  Its filename was
     mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch

This patch was dropped because it was folded into mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix
Date: Fri, 6 Dec 2024 19:23:48 +0800

Dan Carpenter reported the following warning:

Commit e3aafd2d3551 ("mm: pgtable: reclaim empty PTE page in
madvise(MADV_DONTNEED)") from Dec 4, 2024 (linux-next), leads to the
following Smatch static checker warning:

	mm/pt_reclaim.c:69 try_to_free_pte()
	error: uninitialized symbol 'ptl'.

To fix it, assign an initial value of NULL to the ptl.

Link: https://lkml.kernel.org/r/20241206112348.51570-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-mm/224e6a4e-43b5-4080-bdd8-b0a6fb2f0853@stanley.mountain/
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 mm/pt_reclaim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pt_reclaim.c~mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix
+++ a/mm/pt_reclaim.c
@@ -36,7 +36,7 @@ void try_to_free_pte(struct mm_struct *m
 		     struct mmu_gather *tlb)
 {
 	pmd_t pmdval;
-	spinlock_t *pml, *ptl;
+	spinlock_t *pml, *ptl = NULL;
 	pte_t *start_pte, *pte;
 	int i;
 
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

