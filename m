Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640691F543F
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352787; cv=none; b=SDvdsZXgU2JJWQosy+4oLph91r4VbVcfIxX90FYB/+7x+UZlf5ZS7MN0n1EmVW41vBycL6u+hxZxw/kQeRpJ1wwAus1YPOyll58So3ek50xIMp7GirhwqAHOiL0AYG5lQ/PUpdQ8pSWAG2R8L1Fc36dc4CwUDfhsaNTF6ef20uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352787; c=relaxed/simple;
	bh=ozdWmTGgU2ar66sxx+80OSIY6ndtwBesKjSUGsdwjOk=;
	h=Date:To:From:Subject:Message-Id; b=ia5IcUlC6yHF7acSMHqmwqB1l1th1+jKz7YaGZ3nKB4Xa8Baj+i+x0Iv5DvUm6VQZsUFq3ESRuN0+lM0fJV9onwBUYfmf6P0LLvUsn+3A/yBEeILGXqKcJoV+0Ku8MI2n1YzilpjNFC9Xngz9/PCT/PJuXkY3r1bP0k7zprbVwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYA5sfxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYA5sfxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8A9C4CECD;
	Wed,  4 Dec 2024 22:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352787;
	bh=ozdWmTGgU2ar66sxx+80OSIY6ndtwBesKjSUGsdwjOk=;
	h=Date:To:From:Subject:From;
	b=EYA5sfxk59wQ00XvMp/oNxcxZihPbV/l8kil7VjO7QMACOjlN3WkfGU9wyKEasXMu
	 tTjhvTOQ8BV/K7sxzRy/zJsRQGhFSOXStfFlm8csqgMLHlyBE2tqJcUf82fQ7P2/DO
	 n7DiiI071EYH9CtsW3jD7P3/dyvTIf0ArxXqvjEU=
Date: Wed, 04 Dec 2024 14:53:06 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch added to mm-unstable branch
Message-Id: <20241204225307.2C8A9C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: skip over all consecutive none ptes in do_zap_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch

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
Subject: mm: skip over all consecutive none ptes in do_zap_pte_range()
Date: Wed, 4 Dec 2024 19:09:45 +0800

Skip over all consecutive none ptes in do_zap_pte_range(), which helps
optimize away need_resched() + force_break + incremental pte/addr
increments etc.

Link: https://lkml.kernel.org/r/8ecffbf990afd1c8ccc195a2ec321d55f0923908.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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

 mm/memory.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range
+++ a/mm/memory.c
@@ -1665,17 +1665,30 @@ static inline int do_zap_pte_range(struc
 {
 	pte_t ptent = ptep_get(pte);
 	int max_nr = (end - addr) / PAGE_SIZE;
+	int nr = 0;
 
-	if (pte_none(ptent))
-		return 1;
+	/* Skip all consecutive none ptes */
+	if (pte_none(ptent)) {
+		for (nr = 1; nr < max_nr; nr++) {
+			ptent = ptep_get(pte + nr);
+			if (!pte_none(ptent))
+				break;
+		}
+		max_nr -= nr;
+		if (!max_nr)
+			return nr;
+		pte += nr;
+		addr += nr * PAGE_SIZE;
+	}
 
 	if (pte_present(ptent))
-		return zap_present_ptes(tlb, vma, pte, ptent, max_nr,
-					addr, details, rss, force_flush,
-					force_break);
+		nr += zap_present_ptes(tlb, vma, pte, ptent, max_nr, addr,
+				       details, rss, force_flush, force_break);
+	else
+		nr += zap_nonpresent_ptes(tlb, vma, pte, ptent, max_nr, addr,
+					  details, rss);
 
-	return zap_nonpresent_ptes(tlb, vma, pte, ptent, max_nr, addr,
-					 details, rss);
+	return nr;
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
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

