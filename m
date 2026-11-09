Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794199949;
	b=edJR/P7oYLqBCxLzbwBx7wosQw30GGsyIlVrxFz+DT5fhI5wkYjpYnY0MhUnp6xa705V
	 fi4K4r5fX5Y1MbDCYChgYVDuZnOu2yZPvapHhErH+7WG3Stw765nComAm35Q5sSsC0Kbd
	 U8F59AVPcabqFnQGGQOJS3bfAwK+M/RdE/+3VxVQZw/8MzaXT8FKK9xiuyjgJ6Phgkmj0
	 4taxyZwWjRQFrhcscGiPDrl4b0J8hn1rK+N9vIqUlVXpfvWiPrp5+gRgvwYQg/rYWHrPg
	 1mGcowgNXw68r+nRGOaBJEvLn3Fg4XWge37BdZ2QgngEWDtPJxCgliqEJhB9HTkw9Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794199949;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=57aNYzdL2Gq2iNQiwuHKZhp+Es0n1FEN9+34t9ZHYa4=;
	b=YP5DxfKQLobmoOJM1DHegP9gZC+6YFXhwlV9lvn53sBuJRCpNvNAmcANOiU7Cc2cTuV8
	 WL1qiYuap1VzeYdiy83A0BKIgKgp6tbF34+qSQBtq5Dfy7RL/9VCudxdI+MPxILqfYo9J
	 hbpcc38CP3GZashgeZHTlB9mf8yykgraiRRzKNwTqxPS/mPwNlxYUQRIjjWana1yHUWs0
	 bU/EWHyBlAK3+734B3A/wOyHC952QrNPGjYFZsfNoJrRwAGyx14Mmna3yXmd0Hfd2c6NC
	 IYZArtjEoMeELBpbe4EDzt7Png190mLMu/Iz/6PBSXT+pntDQr/kTkqIgIIEaL1k5Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BQVcgpio;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8209D606A31C;
	Mon,  9 Nov 2026 04:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BQVcgpio
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ECB1F0089F;
	Mon,  9 Nov 2026 04:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794199949;
	bh=57aNYzdL2Gq2iNQiwuHKZhp+Es0n1FEN9+34t9ZHYa4=;
	h=Date:To:From:Subject;
	b=BQVcgpioib9H61s/FWbavRbw+eTtamQa0ldXyhRbQNGIT/yaqVRdKq8LmW/xMSNYI
	 76qE8encDYNiwfiEYZAmkjUs3hypP9AxsQIAuA1gaW8OiM1bCoCzoNYd3OfLBw2YZv
	 ykE/zoAGg3JXzAAzARE9hsR89H5nTJPeprlEgxrk=
Date: Sun, 08 Nov 2026 20:52:28 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@kernel.org,
	surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,
	baohua@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree.patch added to mm-hotfixes-unstable branch
Message-Id: <20261109045228.F1ECB1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
Date: Mon,  9 Nov 2026 10:16:11 +0800

lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
clearing the refs or PG_workingset.

A MADV_FREE folio therefore keeps the state it had before madvise(2),
even though madvise_free_pte_range() has already cleared the accessed and
dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
younger, and PG_workingset puts it in the last tier, so sort_folio()
promotes and protects it instead of evicting it and charges it to
lrugen->protected[], which read_ctrl_pos() uses to balance anon against
file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
so this repeats every time the folio reaches the oldest generation.  If
the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
lru_gen_eviction() packs the stale state into the shadow entry, so a
later refault is promoted to the youngest generation.

Call lru_gen_clear_refs() while the folio is still on the generation
list, as deactivate_file_folio() and folio_deactivate() already do.  Its
return value only says whether the folio is in the oldest generation,
which lru_lazyfree() does not need because it re-adds the folio below.
Keep folio_clear_referenced() unconditional: the classic LRU needs it,
and it also covers the folios that lru_gen_clear_refs() skips.

Link: https://lore.kernel.org/20261109021611.22247-1-hui.zhu@linux.dev
Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: <stable@vger.kernel.org>
---

 mm/folio.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/folio.c~mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree
+++ a/mm/folio.c
@@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
+	lru_gen_clear_refs(folio);
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	if (lru_gen_enabled())
-		lru_gen_clear_refs(folio);
-	else
-		folio_clear_referenced(folio);
+	folio_clear_referenced(folio);
 	/*
 	 * Lazyfree folios are clean anonymous folios.  They have
 	 * the swapbacked flag cleared, to distinguish them from normal
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree.patch
mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch
mm-compaction-annotate-data-race-for-zone-free_areanr_free.patch

