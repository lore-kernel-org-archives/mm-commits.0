Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24CB28B4FD
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334129; cv=none; b=LBoZfYi7e81LIsY69s6dMfK6RKo5S3x6CuD5y6dn1RjYwAcfo2wGrEhvWUS5YsKnV1HPgyGnW/VrE1PasqXF5r5jLp+LsMDn5Hk92uV0X0ILHrohUAdoBttWOsg3HVQGnsnDpiZlw84U8SDCqOni8Kx77S/de7Iy3Yx4UUc2HPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334129; c=relaxed/simple;
	bh=pwpYZWngjc5tNfwVjrvb4vs63brr4j8uG2vEMhaZTLk=;
	h=Date:To:From:Subject:Message-Id; b=r1QDmNDsPizVKY8FSeU+nOQLECFvqeshIja3LX1ig3jEgN0mLaPq0nwoI7tP32rFqQz+8e3Waeb+WYZ97X+sBphSGEVXigsrWBgvcn6nFa052Ctssube2Wf4HbZiURZv2LS1JKrfb5rA/3KIgP53Vhb343oGeN5nyzPJB25h8Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=01Z/Zvbk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="01Z/Zvbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E18C1F0089C;
	Wed,  7 Oct 2026 00:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334128;
	bh=tAKaCA7adrOJWXGuTiKn3xxrUt+p7ppo4NtBvyOtmF0=;
	h=Date:To:From:Subject;
	b=01Z/Zvbk5zXs+siGDQHJJtJ+EwTPnE3r+/UKYjqoB/rt/kHdE0vnjJBd30R0LbEP4
	 eE0WKqgcr0T5+rjd2sK4SBfWS27lhfaY5E2SQ+vkZugWO/QdDSL3/07QwB4IXSXTZ3
	 IQFHVaHznER54FyRDsKWRtXQfZLRrtkZSFxgMDsE=
Date: Tue, 06 Oct 2026 17:48:47 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,suleiman@google.com,steven@liquorix.net,shakeel.butt@linux.dev,oleksandr@natalenko.name,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,heftig@archlinux.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch removed from -mm tree
Message-Id: <20261007004848.5E18C1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: preserve inactive placement when enabling MGLRU
has been removed from the -mm tree.  Its filename was
     mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Barry Song <baohua@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Assisted-by: Claude:claude-opus-4-8
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

mm-page_counter-avoid-integer-overflow-in-effective_protection.patch
mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim.patch
mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

