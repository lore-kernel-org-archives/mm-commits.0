Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE2B1FC0E9
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 03:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733886570; cv=none; b=IVAUKuDwzv+9WC/9Cdllo7SZjevoQMR/9XOFfdkqR51BQvv75JiY5VBEuse7OZS/1tIkn/urcN+XleEEtDR6K+cUPe8oATXqMKKNRnKOhMoT2FmrG6VEEgMO90B1uzypJL+IQMHvk3XMnNElLQCq9k48jOkpat/LbRbPLP0yRa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733886570; c=relaxed/simple;
	bh=uPjvHdki1Cxn1h0+H+2/U6qxD5KrzRON94bzNpoelWs=;
	h=Date:To:From:Subject:Message-Id; b=eqTWDVLC4lY+bmFChU+YwrNGS5nbpZ4T51ojA2CHAi/URkaxdhmlP32MLdHaO3y8tI27jky4S0WVirthvnNtIqnFLQ80o+4iUFkJkHlvhsLrAkTsrFu2wndp7G5WHfBvlmV0luv+Jpsh90/YGrZib4W37BClkJKtZ+ghDyty+Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wTgVA8rC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wTgVA8rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEC8C4CED6;
	Wed, 11 Dec 2024 03:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733886569;
	bh=uPjvHdki1Cxn1h0+H+2/U6qxD5KrzRON94bzNpoelWs=;
	h=Date:To:From:Subject:From;
	b=wTgVA8rCOKBASiJit7Dxt9BtF159drc5jte3hBb7H4n/24CKOkhaTENY5X0IVwS0O
	 S9f6KrCKiRaQO5AJcLlg3FrJ6z0VSKPNsZiD+h7WQPflxr5kJsRL5gvrQ4kWFX55aJ
	 IIG50zC9MIMhbQjMYQ4ob+s30IRcKx8SmwXDRSdI=
Date: Tue, 10 Dec 2024 19:09:29 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch added to mm-unstable branch
Message-Id: <20241211030929.CEEC8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch

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
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
mm-pgtable-make-ptlock-be-freed-by-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch

