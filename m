Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A820D1A9F96;
	Tue,  4 Aug 2026 01:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785807050; cv=none; b=t2J66Yr+LFyV0l0ooXKOfabF/XH/NfxZBpadT1Znvhm5lj5mbgkfVCwDnhHPgbFcXqvu4Fa6520EkIPNQnBrnuQPZScZ/uyf25ssr333e0rU73RzwZtppTMpW4t/8ylY6ztqPOzMCux3hpqH6FN5epQ7Q3eHgnXvf0CCmNZfZpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785807050; c=relaxed/simple;
	bh=LHRVsMSi1wbq5/N1GL4pFcFNU2EE6Nd0EDP+aSE9L/k=;
	h=Date:To:From:Subject:Message-Id; b=hyX8qeciGupwLzHPCgaH3quglq1zbVNPPhKato4XCmj0EYi4CIF9TZoBHcbnrCB29+sRaE6Z47Wv7AT2HcvXuZ4U+2/knVeHq0T7VzurVJGRKsEI0o1oxZh0NXeIVarXcUdYNAAt+09WthVFu7KdXO27T+XMr28d8yOSHP/5WiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sJLNNBdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sJLNNBdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272CD1F000E9;
	Tue,  4 Aug 2026 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785807049;
	bh=6VUnyydCuoBofwR3BkbnDQwaxoFo6U0taj4O5J2lVDQ=;
	h=Date:To:From:Subject;
	b=sJLNNBdJWHcxQCtWKLvcXWTIpL693G0j1nrplnOS7nLriN/H96FoPXKLnKdRzqR9C
	 x+jQ39qnW364drhWPcoPfr0IMrZ66IKXKUVAhOgtYVGk9VMqqKzNhberCS8MNAqRBg
	 XnFRagk0xp4tSgs+N+WvonHDbxf/Kks8vv3UvVM0=
Date: Mon, 03 Aug 2026 18:30:48 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,liam.howlett@oracle.com,david@kernel.org,luto@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-incorrect-flush-address-in-direct-page-table-reclaim.patch added to mm-hotfixes-unstable branch
Message-Id: <20260804013049.272CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix incorrect flush address in direct page table reclaim
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fix-incorrect-flush-address-in-direct-page-table-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-incorrect-flush-address-in-direct-page-table-reclaim.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andy Lutomirski <luto@kernel.org>
Subject: mm: fix incorrect flush address in direct page table reclaim
Date: Mon, 3 Aug 2026 17:37:08 -0700

When zap_pte_range reclaims a page table, it does:

    pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);

and this is unconditionally wrong: if this code executes, addr *always*
points one past the end of the range covered by the table.  The addr
parameter is used to flush the TLB (really the paging-structure-cache) to
drop references to the to-be-freed table, and any architecture that cares
about the parameter will flush the wrong address.  (But they'll still free
the correct page).

I think it's worth contemplating why the kernel works at all.

If we hit the offending line of code, we will first clear the PMD entry
(line 1954, zap_empty_pte_table), then we will issue pending flushes if
force_flush is set (tlb_flush_mmu_tlbonly(tlb)), then we will skip the
retry on line 1979 (phew!), and then we will do the offending pte_free_tlb
call.  *Or* we will clear the PMD entry immediately before pte_free_tlb
(line 1983, zap_pte_table_if_empty).

If we have any pending flushes (i.e.  we actually zapped any last-level
entries) at the time we clear the PMD entry, then the flush really ought
to flush all references to the table (Linus certainly seems to think it
will on all architectures [0]).

The condition under which we have no accumulated flushes at the time of
the clear is very complex (the whole zap_pte_range function has absurdly
complex control flow).  If we do hit the bad case, then we will end up
clearing the PMD entry after the last time the range is flushed, and any
CPU is free to cache a reference to the (empty) page table.  If this
happens due to an ordinary read or write, it would segfault, so it would
be rare.  But the cache could be speculatively filled as well.  Then we'll
flush the wrong address and then free and possibly reuse the table.

On x86, even flushing the wrong address works on non-KPTI Intel systems
because INVLPG flushes *all* paging-structure-caches, not just the ones
for the target address.  But INVPCID does not, and flush_tlb_one_user will
use INVPCID if it's available.  And then we're toast.  AMD systems are
more susceptible: we set the EFER.TCE bit, which makes even INVLPG only
flush the target address.

P.S.  IMO zap_pte_range is a mess.  The control flow is excessively
complex.  The direct_reclaim variable itself has a confused meaning -- for
the first part of the function it means, approximately, "we should free
the table if can_reclaim_pt".  But, later on, it means "we ALREADY
reclaimed the table".  And the goto retry on line 1979 is IMO just asking
for trouble if the condition ever changes such that it might happen after
clearing the PMD.

I think this might fix an issue in ripgrep reported here [1]:

Link: https://lore.kernel.org/20260804003708.49830-1-luto@kernel.org
Link: https://lore.kernel.org/all/CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com/T/#u [0]
Link: https://github.com/BurntSushi/ripgrep/issues/3494 [1]
Link: https://github.com/dfoxfranke/ripgrep-3494-analysis
Fixes: 4c640eb4181c ("mm: move pte table reclaim code to memory.c")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~fix-incorrect-flush-address-in-direct-page-table-reclaim
+++ a/mm/memory.c
@@ -1981,7 +1981,7 @@ retry:
 
 	if (can_reclaim_pt) {
 		if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
-			pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
+			pte_free_tlb(tlb, pmd_pgtable(pmdval), start);
 			mm_dec_nr_ptes(mm);
 		}
 	}
_

Patches currently in -mm which might be from luto@kernel.org are

fix-incorrect-flush-address-in-direct-page-table-reclaim.patch

