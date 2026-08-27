Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD9D231C91
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 03:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787801041; cv=none; b=td12Omz0E6qO/aHvHO4dkf/pNm2FyXKITVNDF0nAC8DI7vGtqC220TJouDuq4O0wyCd6Zcr8jsoWrsy1QRQtgU7AU3xsTjolSXOxA41fIVwV2HbEFFkrLSuXMRS9hPmgg9/lLBQzyLpM1xxS70yjBIX7lrNcCyLP72yQO26Hp2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787801041; c=relaxed/simple;
	bh=zUaxnajILwZOvMUlgC7dat0WWUJhijgwKlpvv1Muz3k=;
	h=Date:To:From:Subject:Message-Id; b=nSlxtiXKqZ5IE3H+ti4/8DHg7DG4yVV/HEN9y4ZRjd6KIR2ggVAjaUZQaWJ0yGZz0laAf3DuS84RzcTH78wNtpKJFmh/roXvsJY/KgDKzXjKvoECnUyxFE0IwYOyzvQbhAPusWb4B5xxt906y7Y9tQRj6TKSIJmEHaN04OfHSL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZRDjgkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZRDjgkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C2A1F000E9;
	Thu, 27 Aug 2026 03:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787801039;
	bh=jp6RDGYDVpgj+alX8LAp6GqvIxZ0ASgQGvFOvkWjzWg=;
	h=Date:To:From:Subject;
	b=mZRDjgkciUW1M/ZAweRNEC8CTJu+DRSivMWEKkKVyPsBSeKRRPqmoaPVRvzmYKHbO
	 Wl3Idzsqgjc8NfGp7UOTdVOG6yhWYSSQbLqsYBUoUQZp6YL5gG78i0sXv/gECC1jAC
	 eOsEybdhsFm9t0BageysSQDmo3AYp0QVlFx9UKrY=
Date: Wed, 26 Aug 2026 20:23:59 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,suleiman@google.com,steven@liquorix.net,shakeel.butt@linux.dev,oleksandr@natalenko.name,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,heftig@archlinux.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch added to mm-new branch
Message-Id: <20260827032359.86C2A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: preserve inactive placement when enabling MGLRU
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch

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
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/mglru: preserve inactive placement when enabling MGLRU
Date: Fri, 21 Aug 2026 10:16:06 +0800

When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
enabled), fill_evictable() re-inserts every folio via
lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
inactive anonymous folio (no PG_active, not in the swapcache) takes the
"gen = MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at seq =
max_seq - 1, which lru_gen_is_active() treats as active.  Its inactive
placement is lost and NR_INACTIVE_ANON is folded into NR_ACTIVE_ANON.

Pass reclaiming=!active so a folio from an inactive list is seeded into an
older generation.  Folios from the active list carry PG_active and hit the
first branch either way, so they are unchanged.

Reclaiming also selects the insertion end in lru_gen_add_folio():
list_add_tail() for inactive folios, list_add() for active ones.  Both the
legacy LRU and a MGLRU generation keep the hottest folios at the head and
the coldest at the tail, and reclaim takes from the tail.  To preserve
that order the folio must be taken from the end matching the insertion
end, so take inactive folios from the head and active folios from the
tail; otherwise hot/cold would be reversed within the generation.

Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed onto
the inactive list before enabling MGLRU:

                         Active(anon)  Inactive(anon)
  before switch (legacy)        2952         1548792   kB
  after `echo y`, unpatched  1552052               0   kB
  after `echo y`, patched      15144         1536636   kB

Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
preserved).

Link: https://lore.kernel.org/20260821021606.877330-1-ridong.chen@linux.dev
Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Suggested-by: Barry Song <baohua@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Acked-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-preserve-inactive-placement-when-enabling-mglru
+++ a/mm/vmscan.c
@@ -5307,7 +5307,17 @@ static bool fill_evictable(struct lruvec
 
 		while (!list_empty(head)) {
 			bool success;
-			struct folio *folio = lru_to_folio(head);
+			struct folio *folio;
+
+			/*
+			 * lru_gen_add_folio() uses list_add_tail() rather
+			 * than list_add() when reclaiming is true.  Match
+			 * its ordering to avoid cold/hot inversion.
+			 */
+			if (active)
+				folio = lru_to_folio(head);
+			else
+				folio = list_first_entry(head, struct folio, lru);
 
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio) != active, folio);
@@ -5315,7 +5325,11 @@ static bool fill_evictable(struct lruvec
 			VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
 
 			lruvec_del_folio(lruvec, folio);
-			success = lru_gen_add_folio(lruvec, folio, false);
+			/*
+			 * Borrow reclaiming=true to place inactive folios in
+			 * the older gens.
+			 */
+			success = lru_gen_add_folio(lruvec, folio, !active);
 			VM_WARN_ON_ONCE(!success);
 
 			if (!--remaining)
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-drop-the-combined-limit-gate-in-__node_reclaim.patch
mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch

