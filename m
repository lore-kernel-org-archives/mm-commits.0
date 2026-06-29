Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EE3379C26
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782753767; cv=none; b=Gnp2WZdjyp1mLiBuwLmxbS+p7KLAZ9KxTNGT3nS1x9ODDMblB3kN5ympb6kraDlQhz9wVlsvCm2PW/AVi+g8uG2GMON5EklitmgpfEO7d9+3aRhZTH/oVXrwUA5XS8SM782HesWuZxs/z+tSqymrESMQkTOVBN4lJo1GLIEHKiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782753767; c=relaxed/simple;
	bh=HKMGRRWOA/OrEDgbRBEK4Bc9cLoGK1ACUb4mvKo3sXo=;
	h=Date:To:From:Subject:Message-Id; b=styeeuxo68FRlV1wjL8ipac8onJ6bzAgww4Ao5TIOiJcB1kzFK7j40fbUyk5z4/ku8o5O/Q+zyN/mCSoosfRINF7buw7nt/ojsv9aY1tkGg8NTgr31IqEPa78a1GWPqDisRqGShXjrq7nYbihTtRWo4dYcPkpDFT0NE9ckJxm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GWJCcpav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GWJCcpav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9573F1F000E9;
	Mon, 29 Jun 2026 17:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782753765;
	bh=SC3I5kcO+PveLEW+jjD3hz9HIabi1O9B7tuZjt/AARA=;
	h=Date:To:From:Subject;
	b=GWJCcpavR3ptQ22RXmJRqdqLLrqDtdJi9sCUX+SNUSzIOjWqq7QS7s89i51qGUUjq
	 TCHP/NA0bzvjNB+AA4X8X/RiR3eY9COSQzeLeqFC4MkUkgxi4RJIMefLFP7Fhe46qi
	 b2rZ6+cvQrky6I5i9b1vAeFGZQ/ZuJHX/ZvyRR8g=
Date: Mon, 29 Jun 2026 10:22:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,davem@davemloft.net,andreas@gaisler.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-drop-custom-pte_clear_not_present_full.patch added to mm-new branch
Message-Id: <20260629172245.9573F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc/mm: drop custom pte_clear_not_present_full()
has been added to the -mm mm-new branch.  Its filename is
     sparc-mm-drop-custom-pte_clear_not_present_full.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-drop-custom-pte_clear_not_present_full.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: sparc/mm: drop custom pte_clear_not_present_full()
Date: Mon, 29 Jun 2026 15:49:47 +0200

Patch series "mm: cleanup clear_not_present_full_ptes()", v2.

While doing some review, I stumbled over clear_not_present_full_ptes() and
concluded that it needs some love.

Let's remove pte_clear_not_present_full() and cleanup
clear_not_present_full_ptes(), renaming it to clear_non_present_ptes().


This patch (of 3):

On sparc64, pte_clear_not_present_full() nowadays does a simple
__set_pte_at().  In __set_pte_at() -> maybe_tlb_batch_add(), we check
pte_accessible() to see whether to call tlb_batch_add().

However, non-present PTEs are surely not accessible, so tlb_batch_add() is
never called and the "full" parameter is irrelevant.

Let's drop the helper and just let common code do a pte_clear().

pte_clear() on sparc64 maps to set_pte_at()->set_ptes()->__set_pte_at()
... so it ends up calling the same function, just with "full=0".

Given that "full" is irrelevant, there is no change.

We added pte_clear_not_present_full() for sparc64 in commit 90f08e399d05
("sparc: mmu_gather rework"), and I suspect that it was already not
required back then.

Link: https://lore.kernel.org/20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org
Link: https://lore.kernel.org/20260629-clear_not_present_full_ptes-v2-1-96089871a1e7@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h~sparc-mm-drop-custom-pte_clear_not_present_full
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -945,10 +945,6 @@ static inline void set_ptes(struct mm_st
 #define pte_clear(mm,addr,ptep)		\
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
-#define __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-#define pte_clear_not_present_full(mm,addr,ptep,fullmm)	\
-	__set_pte_at((mm), (addr), (ptep), __pte(0UL), (fullmm))
-
 #ifdef DCACHE_ALIASING_POSSIBLE
 #define __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, old_addr, new_addr)				\
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch

