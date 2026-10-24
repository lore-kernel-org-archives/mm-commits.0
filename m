Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832506;
	b=LZ0D1EOo5dP+q4nARsLdLQ5Ybmc5mCWT2mckItl2lslA+1r0xzZLkIQuUeQsiGmF1TpF
	 rWMFtHtPHkYPHcwPox06/m/gg41HUB5mj2bRo9MlhTFRnVUv5BDE2/vOl+PCIQmxsMYoI
	 bTh/uiYj9MzSPaD1HFr6CGfYBGcpUD2ceW+WuqCsyo4WItqd2Fkol6RgRjJ7Gz5+kr9Yd
	 q7/m3SRvzbJ0ez+jwnXAGrMNoetg8NsEZHTO0J6hFwO55hXJYAPLxSqvl/DMDMj4pL+HP
	 bv5uC4osK1XIQCxezEg8VYJXPvHJhMdx4YPnzet6ja0I/XFRZ1ILs3H36SgWqOcg2qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832506;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+5+FYMUkOmyQy0k+6IsO9/ULiOW4+7UjEXNn3Vx4ZpI=;
	b=hYsbcOobTbuhOrgkScT0biIEfopBf+/YClsHDCLS8J7x/ndqnzVXBS1W9LpBl4C6cVgt
	 eBO2ja7Xwt3QIF5tpcAiG0ZSlv2YBvPPOzWzrQzVaHIBWl/+nAlf3rHzkFpMB1rXgL53c
	 DzM/ldR6JmpLMRqQr/sirUFKFXfYbxI5l5IDOOzq/ilnRYpiRjIsmX5oSjkdJmU3HNBRc
	 Zim5WNrswScxcomvoXn0TI0Rw6V4CLb4AdVfil2R5kJ21uOuCZOUisX5HVvN0640dymq1
	 trT8cDioyDJVQGMn9HfE8psvzAYvk+rcg4/vo98GP3Ugzr1kT6lmM5OyESV/GzpoyzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WjPGoix5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68741606A329;
	Sat, 24 Oct 2026 09:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WjPGoix5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3229E1F01825;
	Sat, 24 Oct 2026 09:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832506;
	bh=+5+FYMUkOmyQy0k+6IsO9/ULiOW4+7UjEXNn3Vx4ZpI=;
	h=Date:To:From:Subject;
	b=WjPGoix5O8bE88ex07os5VBil7NVHhcRNPRxQcQiTJ9ygOj1cYr9bAkCpqGGinlTo
	 O9/5AtWXbsO8Fwk1V1CtyXBImEZQr45zANETNTs6y3cppaVS88ml6b0bvKovAGTVsb
	 IGRSpgu0lFkrxcBXLweZLOlniXgRFNGTi64aQmsU=
Date: Sat, 24 Oct 2026 02:01:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,stable@vger.kernel.org,sj@kernel.org,samarth.colleges@gmail.com,minchan@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-atomically-clear-the-young-bit-on-thp-madv_cold.patch removed from -mm tree
Message-Id: <20261024090146.3229E1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/madvise: atomically clear the young bit on THP MADV_COLD
has been removed from the -mm tree.  Its filename was
     mm-madvise-atomically-clear-the-young-bit-on-thp-madv_cold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm/madvise: atomically clear the young bit on THP MADV_COLD
Date: Tue, 13 Oct 2026 20:17:19 +0100

As-is, madvise_cold_or_pageout_pte_range() discards the hardware young bit
by invalidating the PMD, doing pmd_mkold() and subsequently writing to the
pmd again.  However, it does so in a racy manner, looking at a
possibly-stale snapshot.  It's entirely possible that a write elsewhere
set the hardware D bit, which this logic now loses.

Fix it by using pmdp_test_and_clear_young().  This is an atomic
modification of the PMD entry, and thus safe against any possible racing
writes.  As a (nice) side-effect, this elides one non-required TLB flush
in pmdp_invalidate().

This bug can interact with the swapping system in complicated ways,
leading to data loss.  For instance, if a folio is marked lazyfree, but
was later read from, and then MADV_COLD'd while racing a write to that
same THP, dropping the dirty bit may lead to data loss as
reclaim/MADV_PAGEOUT drops the "clean" anon folio:

T0                                T1
================================================================
MADV_FREE(thp)			|
  folio marked lazyfree		|
read(thp)			|
  PMD marked young by hardware	|
				| MADV_COLD(thp)
write(thp)			|   if (pmd_young(pmd)) {
  PMD marked dirty by hardware	|     set(pmdp, pmd_mkold(pmd));
MADV_PAGEOUT/reclaim		|
  dirty bit may or may not be   |
  set				|
    reclaim/pageout may drop    |
    the folio			|

Link: https://lore.kernel.org/20261013191719.95502-1-pfalcato@suse.de
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Samarth Narang <samarth.colleges@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/madvise.c~mm-madvise-atomically-clear-the-young-bit-on-thp-madv_cold
+++ a/mm/madvise.c
@@ -430,10 +430,7 @@ static int madvise_cold_or_pageout_pte_r
 		}
 
 		if (!pageout && pmd_young(orig_pmd)) {
-			pmdp_invalidate(vma, addr, pmd);
-			orig_pmd = pmd_mkold(orig_pmd);
-
-			set_pmd_at(mm, addr, pmd, orig_pmd);
+			pmdp_test_and_clear_young(vma, addr, pmd);
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
_

Patches currently in -mm which might be from pfalcato@suse.de are


