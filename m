Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B643023C700
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837002; cv=none; b=qzY78DMrPwnlk+h23fXgW7rnSrqbm5RKQUUmSGzE7+GSA/Zlslr7RGjehRt9ddvgAx5OV6tmV/f+qJUbaCcD/nPUuAScqGfipQSZJzshSsMNrSLhmidpHtYO70DN2TetcEGs4LQD5zi8J7IAep9aRSspr83QtaNjIxwYguSnQ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837002; c=relaxed/simple;
	bh=EI/AN5K9D6pVJLlpj85pYepjV3v9hxleu/pHom96u6M=;
	h=Date:To:From:Subject:Message-Id; b=LRPTC+dC5OsFXOhyCVoxi+8/uC1Kvq/RrML8zSO9fTko61V6ZgAFlETvbqedMLXlZ9vaz7UFkPcUeaUsylDudSQSuzq6NA7TmSo7PZoKtAode6rxvfhjzRrLs1lC4MPRgVpc+0asmpsR1r5uT+fpDbc06Ihs9jgQeujgTg2WD68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hMrrcmYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hMrrcmYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB3CC4CEDD;
	Tue, 14 Jan 2025 06:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837002;
	bh=EI/AN5K9D6pVJLlpj85pYepjV3v9hxleu/pHom96u6M=;
	h=Date:To:From:Subject:From;
	b=hMrrcmYW20obFN2EQZpyYdxnQL+lqN4y4rRpSU75nRUztHUuquzd+VBg+NGU1tJxA
	 EyjKb7+BPL1oOYJGySjCdZEYyhyfg25CnjtwYziNdZHcCq27tQC+d40/a05qSu2YqB
	 ijaWhJ4xz7ueldTZCtxrvo43WhZIYU2oWQUgLRj8=
Date: Mon, 13 Jan 2025 22:43:21 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch removed from -mm tree
Message-Id: <20250114064322.4EB3CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: skip over all consecutive none ptes in do_zap_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Dan Carpenter <dan.carpenter@linaro.org>
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


