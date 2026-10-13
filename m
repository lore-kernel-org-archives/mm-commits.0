Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38D054B1DB;
	Tue, 13 Oct 2026 21:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791928778; cv=none; b=eBZBqZSHrwtqygjbuqmTVrR9JxlaQTB4WzfzkXS/MFqQmey5h5AVSN2cPbtJAQbsCgJffeVlmj7M90lz95VanBxzA++RkEiqL8QnMk+9OZsoGzHZP84QwFywaT1wb8OYWsCSKriDqV7ivzFWkR6pIxXyMSgcZEpMYqe4N0b0EDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791928778; c=relaxed/simple;
	bh=0MmfTw0rqjIcVHo7nKLcdaNqIsaJEPfH65XL75d7eJc=;
	h=Date:To:From:Subject:Message-Id; b=rOYtnjT0hrXmNFl7cVwp4ZfosN5msCY7GEg8IsKBzKjVwWf6DlfdvaHp92RDuUpAv2i3KWG2rJ7fYiTyYcr1PZ9kIh/hPZX0ATRm9eJ4prgurWJ4uDiLgzoe+2oMk2xg3T+jT0W+tTsDLIeiUOYlWTfFMHp+/88Tu+KMoK9Ixms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O4+z5swK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O4+z5swK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6DA1F000FF;
	Tue, 13 Oct 2026 21:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791928776;
	bh=NZSxhaQqGrdSOf00mdC5Ac1S3qCd0cvRtlQoqmCVYs0=;
	h=Date:To:From:Subject;
	b=O4+z5swKm/shqTqJ+PjM314WFQdN+WPjsGN9ITbpTP9c+vmEGMTmPsamkjM88OYzm
	 f7Sbi8sVSHCHRlIFrKvWNE7Unp+/cp8oUg3VtlmU3SrPyGK2wJXXDauuwb3B+u0AS4
	 7LCJrZx4v7OIC+QTjNnnBx9EqrmBHuC4Uw//GOVs=
Date: Tue, 13 Oct 2026 14:59:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,samarth.colleges@gmail.com,minchan@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-atomically-clear-the-young-bit-on-thp-madv_cold.patch added to mm-new branch
Message-Id: <20261013215936.4C6DA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: atomically clear the young bit on THP MADV_COLD
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-atomically-clear-the-young-bit-on-thp-madv_cold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-atomically-clear-the-young-bit-on-thp-madv_cold.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
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

mm-madvise-atomically-clear-the-young-bit-on-thp-madv_cold.patch

