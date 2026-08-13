Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA97A37F320
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 20:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654142; cv=none; b=s1nq+rybTBF0H1ghJQKDDC42xOpAFVGnUBSfZGOWC9Xn227fQRub2p6uXLcDYkD4ztrdXyTWlAtmsyUWzX422hiQxYrUEQGOoWvsv6ockbYl67n8q9o54TGFVXPII+Gr9Ooi9AJPQw9ginITZugQhQ6MdsKLovV+lePEAncqFg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654142; c=relaxed/simple;
	bh=zCfxwFoOYLfpO1ZaT8oRwmIKMVpBl2X6OLt342LV2mE=;
	h=Date:To:From:Subject:Message-Id; b=vCvQr9Y6sKMuI6eS9kEHdDQXQMsAMqds9U+GnKA8PbP9efe78+pSdzlQxuT4LRi7DPS+7mhgkBvMIkkp52On7ybUuWosG4AlbQNfgtx1eZzaiFBPUucXkp7EFXO6A7emjIZ5DejyIcCNx4sXekwwpHU/kT3udjtREf87tSA81fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wz8Znjq1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wz8Znjq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014D21F000E9;
	Thu, 13 Aug 2026 20:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786654140;
	bh=pwJPoIbrz6JQUDnwxms5+L8BGudwStA20QdZthLbAAc=;
	h=Date:To:From:Subject;
	b=Wz8Znjq13f0OSlTvGwStYxfjtM3MQ1mU82DPOlLc/Ns2/r5tLzyac/l4/SR0lcpz6
	 I6/oDYjQx0GBg1G++R6fQu9m4SVji/CsPK724F+cguvnlMWNiidkUO0d8lKGHIDFn+
	 mhV+49eyUBdh8dACDcoa6ejjfkqb3nxAw4OC9J4I=
Date: Thu, 13 Aug 2026 13:48:59 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-young-counter-undercount-for-large-folios.patch added to mm-unstable branch
Message-Id: <20260813204900.014D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix young counter undercount for large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-fix-young-counter-undercount-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-young-counter-undercount-for-large-folios.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/mglru: fix young counter undercount for large folios
Date: Wed, 12 Aug 2026 14:59:33 +0800

lru_gen_look_around() feeds its local 'young' counter into
suitable_to_scan(), which decides whether the current PMD is added to
the bloom filter and checked again on the next aging round.

The folio triggering the look-around is processed at function entry:
test_and_clear_young_ptes_notify() clears the accessed bits of the nr PTEs
it maps, and the function bails out if none of them is young.  The loop
that follows therefore never recounts this folio, since its accessed bits
are already cleared.  Every other young folio the loop finds is accounted
as a batch (young += nr), where nr is the number of consecutive PTEs it
maps.  The triggering folio, however, still contributes a fixed young = 1
regardless of its size -- a leftover from before PTE batching.  A large
triggering folio is thus accounted inconsistently with the rest of the
window.

Initialize young to nr so the triggering folio is accounted the same way
as any other young folio batch in the loop.

Note this is a deliberate overestimate, not a measured value.  The
test-and-clear helper only reports whether any of the nr PTEs is young,
not how many were accessed, so the true number of accessed PTEs in a large
folio is unknown and can be smaller than nr.  Counting the full batch is
intentional: the mm core tracks accessed/dirty state per folio, not per
page, so a per-page count is neither obtainable nor meaningful.  The only
consumer is suitable_to_scan(), and the bloom filter it feeds tolerates
error.  Overestimating is also the safe direction: at worst a PMD that saw
little access is rescanned, whereas underestimating could skip rescanning
a PMD whose folios are still hot and reclaim them incorrectly.  (nr here
is the PTE batch size, not necessarily folio_nr_pages().)

Link: https://lore.kernel.org/20260813061019.49806-1-hui.zhu@linux.dev
Link: https://lore.kernel.org/20260812065933.103627-1-hui.zhu@linux.dev
Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag for MGLRU")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-fix-young-counter-undercount-for-large-folios
+++ a/mm/vmscan.c
@@ -4261,7 +4261,7 @@ bool lru_gen_look_around(struct page_vma
 	unsigned long end;
 	struct lru_gen_mm_walk *walk;
 	struct folio *last = NULL;
-	int young = 1;
+	int young = nr;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-mglru-fix-young-counter-undercount-for-large-folios.patch

