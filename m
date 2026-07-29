Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C2F1F7916
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298530; cv=none; b=uN/SMNHPDty1xkO7FJI6QAHbYG7rrx8B7jQcVUFFhS2ArW+6ltYln6/ywBidKWDHyd+Ui1o9HtrWR0ADkVE2VLYHhYG3kPny3EhCRLj/OWUPQkzFJ38SQ4+MH8IpkxSMlP5MP96OKmhDDd8B+ZqvUSHSL0cXXamFbl1lpHKdTrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298530; c=relaxed/simple;
	bh=jgo6OUZFfRZeghLXxEG+TxW7v9JdxVGILquqknCGy5U=;
	h=Date:To:From:Subject:Message-Id; b=o0yF7bPz5rxy0bjUp1LfZ8/c0h2/9N5LseUDv60zVVlPV41Orhm+iBNaXpPIXAW5hTB/HvwN4GHMcuPiJp6WrcwhLAdCNp2r7mGaHAyfM7sPyzCmYbyYTwVkdHljPIY69MZi5vRAsOGkhiZ3sDAXztgtZKNXkUlNdkxcUFx9LQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W6kJdfrF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W6kJdfrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1C61F000E9;
	Wed, 29 Jul 2026 04:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298528;
	bh=0QdGfsb/QUzTLgGjGNrbbUZQb6Tf2roVD+btQflsi6M=;
	h=Date:To:From:Subject;
	b=W6kJdfrF2WQaxCaZMd412kd0ZLiIH+qkQMpuKp++MuywZ4qAUuMXx2tu02E3RXqLU
	 LhIq4hVYztQZj4oU4si80ZtqPe4czmlGQDAArPK2G5MQWsEdwibMpPEwpzNxGHDX1W
	 1gOgM3qfTRH4mk2ugRjxMJcV4heWBeyeXmDkK+rA=
Date: Tue, 28 Jul 2026 21:15:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,davem@davemloft.net,andreas@gaisler.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-drop-custom-pte_clear_not_present_full.patch removed from -mm tree
Message-Id: <20260729041528.AD1C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc/mm: drop custom pte_clear_not_present_full()
has been removed from the -mm tree.  Its filename was
     sparc-mm-drop-custom-pte_clear_not_present_full.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

