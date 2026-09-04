Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463063B42C7
	for <mm-commits@vger.kernel.org>; Fri,  4 Sep 2026 04:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788496097; cv=none; b=CojavCaB1IdF+dPjv4DSXRfDbDTEqBGybyIbaRGVdHk1XdrjH51FTezzY6cxC6r2gBcMCAZxiGdEcnRWvLLiRGBQgeKtiOU47mdacPgVxjylDesxZtb8UiQ4isEW8FXqc6/Bp2tXAGnZw8NaIf4KXsupSOB2JOdQdA1Fwoi8NWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788496097; c=relaxed/simple;
	bh=ov01+lV5cFTJWOT80O6q0VlsuHElcuVkvR55BKVBuWs=;
	h=Date:To:From:Subject:Message-Id; b=RLiNQTLYDqMCpb9a55NS0sSGXpnyO2YACoYPLloFWKu+sJFC31JarH9YeoOZn4qjjEsVm9ma8ekB73JunsO/of3J2yYsKp9wUHHhzcH7AdyWd3f5GT6cTw7wB6FIbGNF+0Vwdv6ME9ie5x6zadPiVKYD4LMOXBFl8+4cc7tCmAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n9ySAMFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n9ySAMFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C5E1F00A3D;
	Fri,  4 Sep 2026 04:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788496095;
	bh=RqEcqGNQrqULVK44eHBV2xlGoQuJS8vkiU/GQO4DBZQ=;
	h=Date:To:From:Subject;
	b=n9ySAMFo4z50eA0VjilovF7qB8hfqeiXpOwA92AbofOHnE3ht9rC7IZ+BMSiulJsf
	 IZOQOvWOKq/XtmREgUj98e2Gz8j25rg/3Ldu+bf+tx8Ya5AQBRI0BLfzcZz5/QO9t+
	 wWMlq5cpT1upYVMi+Ex8gEqS6pzxJ+g+VnyTe/bs=
Date: Thu, 03 Sep 2026 21:28:15 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch added to mm-unstable branch
Message-Id: <20260904042815.B7C5E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Wed, 2 Sep 2026 07:24:20 +0800

For reclamation, it makes sense to reclaim folios from tail to head, as
folios near the head are relatively hot.  However, when moving folios from
the oldest generation to the second-oldest generation, using the
tail-to-head order would effectively cause a cold/hot inversion.

The impact of the added prefetching might be arch-dependent.  Some
architectures could benefit more from prefetching, while others might
see little to no impact.  In my x86 test, it shows a very slight
improvement:


***** no-prefetch:

agetest:
...
gen 100:  2.421 ms
gen 101:  2.424 ms
gen 102:  2.420 ms
gen 103:  2.413 ms

Total: 248.418 ms
Average: 2.460 ms

agetest:
...
gen 100:  2.393 ms
gen 101:  2.396 ms
gen 102:  2.395 ms
gen 103:  2.392 ms

Total: 245.627 ms
Average: 2.432 ms

agetest:
...
gen 100:  2.433 ms
gen 101:  2.427 ms
gen 102:  2.432 ms
gen 103:  2.450 ms

Total: 249.186 ms
Average: 2.467 ms

**** has-prefetch:

agetest:
....
gen 100:  2.314 ms
gen 101:  2.310 ms
gen 102:  2.321 ms
gen 103:  2.303 ms

Total: 237.619 ms
Average: 2.353 ms

agetest:
gen 100:  2.342 ms
gen 101:  2.343 ms
gen 102:  2.339 ms
gen 103:  2.335 ms

Total: 239.929 ms
Average: 2.376 ms

agetest:

gen 100:  2.344 ms
gen 101:  2.347 ms
gen 102:  2.352 ms
gen 103:  2.348 ms

Total: 241.188 ms
Average: 2.388 ms

Basically, its 2.3xx vs. 2.4xx, lower is better.

Link: https://lore.kernel.org/20260901232421.40157-7-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail
+++ a/mm/vmscan.c
@@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_fo
 		prefetchw(&prev->flags);
 	}
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+	if (folio->lru.next != base) {
+		struct folio *next;
+
+		next = list_entry(folio->lru.next, struct folio, lru);
+		prefetchw(&next->flags);
+	}
+}
 #else
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		struct list_head *base)
 {
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+}
 #endif
 
 /*
@@ -3943,10 +3959,11 @@ static bool inc_min_seq(struct lruvec *l
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		struct list_head *pos = head->next;
 		long delta = 0;
 
-		while (!list_empty(head)) {
-			struct folio *folio = lru_to_folio(head);
+		while (pos != head) {
+			struct folio *folio = list_entry(pos, struct folio, lru);
 			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
@@ -3957,6 +3974,8 @@ static bool inc_min_seq(struct lruvec *l
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
+			prefetchw_next_lru_folio(folio, head);
+			pos = pos->next;
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			/*
 			 * If gen_increased is false, this is a promotion. Put folios
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch
mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix.patch
mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch
mm-mglru-separate-folio-generation-update-from-lru-accounting.patch
mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq.patch
mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq.patch
mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch
mm-mglru-make-lru-folio-prefetch-helper-an-inline-function.patch
mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch
mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch

