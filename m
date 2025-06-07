Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02658EEDE;
	Sat,  7 Jun 2025 23:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749337610; cv=none; b=FZ9VOTLpHm7ey+s4nKNDJLj7SEHVdYrLilCZsFhQypT9maEiNN/x+oqFq/YuhPCc/z4pKhgWW9L0RrXd7S0olMeFJpL11iN2KtwV7oVNLk75dlsx/dreUzsFPjx9wcVpojooR+mRhWv9EDe3v5dtCJURWx8MNIi+umILi5Dc+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749337610; c=relaxed/simple;
	bh=Elhqgyv0nGJsyO5TEHZhORq0Ar7gBk6gYDIVUIQQCso=;
	h=Date:To:From:Subject:Message-Id; b=SyN+kEvo/JgrSHMQpApfKFRFdz/n1m6JVrN3BqljdAOBUuswXqdUnlYAisvi0ylcWHZ5xCv6SsSk/tAWjWJOWeoStWbhaLMBAsm2vjyNLFBnHSOo8BwWlcX7jQDQAET6FQteotHNQCzr8oubWjj3Zbub4QXEuTDiS1Jxvc/Psv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Y8mh5rU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Y8mh5rU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F317AC4CEE4;
	Sat,  7 Jun 2025 23:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749337609;
	bh=Elhqgyv0nGJsyO5TEHZhORq0Ar7gBk6gYDIVUIQQCso=;
	h=Date:To:From:Subject:From;
	b=0Y8mh5rUDNaZJCovly6krUCYqFzI1BBc8zK++A7+z21hFUBMidyal5Z6fvFRaQQ4I
	 sgS6LjRL6rDCqKhUoVG3wLxDrk6h7iH3jtbavYVZKO8oxnW/FC3H8qkJweMb7n6Gnq
	 3Yn3PZhFiT4lOCFFb5mMoc8gClRZdXtdAsbVaRVE=
Date: Sat, 07 Jun 2025 16:06:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch added to mm-hotfixes-unstable branch
Message-Id: <20250607230648.F317AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: close theoretical race where stale TLB entries could linger
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: close theoretical race where stale TLB entries could linger
Date: Fri, 6 Jun 2025 10:28:07 +0100

Commit 3ea277194daa ("mm, mprotect: flush TLB if potentially racing with a
parallel reclaim leaving stale TLB entries") described a theoretical race
as such:


"""
Nadav Amit identified a theoretical race between page reclaim and mprotect
due to TLB flushes being batched outside of the PTL being held.

He described the race as follows:

	CPU0                            CPU1
	----                            ----
					user accesses memory using RW PTE
					[PTE now cached in TLB]
	try_to_unmap_one()
	==> ptep_get_and_clear()
	==> set_tlb_ubc_flush_pending()
					mprotect(addr, PROT_READ)
					==> change_pte_range()
					==> [ PTE non-present - no flush ]

					user writes using cached RW PTE
	...

	try_to_unmap_flush()

The same type of race exists for reads when protecting for PROT_NONE and
also exists for operations that can leave an old TLB entry behind such as
munmap, mremap and madvise.
"""

The solution was to introduce flush_tlb_batched_pending() and call it
under the PTL from mprotect/madvise/munmap/mremap to complete any pending
tlb flushes.

However, while madvise_free_pte_range() and
madvise_cold_or_pageout_pte_range() were both retro-fitted to call
flush_tlb_batched_pending() immediately after initially acquiring the PTL,
they both temporarily release the PTL to split a large folio if they
stumble upon one.  In this case, where re-acquiring the PTL
flush_tlb_batched_pending() must be called again, but it previously was
not.  Let's fix that.

There are 2 Fixes: tags here: the first is the commit that fixed
madvise_free_pte_range().  The second is the commit that added
madvise_cold_or_pageout_pte_range(), which looks like it copy/pasted the
faulty pattern from madvise_free_pte_range().

This is a theoretical bug discovered during code review.

Link: https://lkml.kernel.org/r/20250606092809.4194056-1-ryan.roberts@arm.com
Fixes: 3ea277194daa ("mm, mprotect: flush TLB if potentially racing with a parallel reclaim leaving stale TLB entries")
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/madvise.c~mm-close-theoretical-race-where-stale-tlb-entries-could-linger
+++ a/mm/madvise.c
@@ -508,6 +508,7 @@ restart:
 					pte_offset_map_lock(mm, pmd, addr, &ptl);
 				if (!start_pte)
 					break;
+				flush_tlb_batched_pending(mm);
 				arch_enter_lazy_mmu_mode();
 				if (!err)
 					nr = 0;
@@ -741,6 +742,7 @@ static int madvise_free_pte_range(pmd_t
 				start_pte = pte;
 				if (!start_pte)
 					break;
+				flush_tlb_batched_pending(mm);
 				arch_enter_lazy_mmu_mode();
 				if (!err)
 					nr = 0;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch

