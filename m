Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECBE18732A
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729119365; cv=none; b=PyWwMl6pK87DdKwUpd6b5Bai0xOoSUl173YAil6v38AaptVkLoDJ6WFTlV5sbxYm3eB0DBwPwz6k6ZEtcTDIgzD9vLN6lBxtOKsdj/xwKCl6SJMidE23ncBeqQEGbthiSZaXJEkjXEgvJrHBYjVmpD9pNBNg+/XWzMDbcKluWeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729119365; c=relaxed/simple;
	bh=Z6ryGgJgB1tT8VNzA8aKCDdSwmapMAdm9cGbPzIXLco=;
	h=Date:To:From:Subject:Message-Id; b=NVhHyj023X+7EKvuGQptiAps7gJwWAZIlPb92s52u+4/aZi2Br+WRXSFNx5Xp1IkhHwYa1H+Fxistr2EqW877GNVvSQLW9tcCkge9j6FIKJcGpoawqZVGIF7i9zGKUjN/HjMdr3/lMfO/px6J023kBv9+GsfIfZ/wOnsOjwPASc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2CXRcrks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2CXRcrks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DE8C4CEC5;
	Wed, 16 Oct 2024 22:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729119365;
	bh=Z6ryGgJgB1tT8VNzA8aKCDdSwmapMAdm9cGbPzIXLco=;
	h=Date:To:From:Subject:From;
	b=2CXRcrks/ALIYDMF0F2wDjRqemNcYRh6zfivM0W0WeL/Bw9ifQd/Fy6AghZtwnx1O
	 uy2eSLnJBI0gp4VN9BCcIAvgvTbWtAdNW3pFvocO8sqXACF3zmwzFXZk9AJmykB1HT
	 ACIthOzPm/V+mE8knWspy6Ll4v2LHcbYeQcBn6u0=
Date: Wed, 16 Oct 2024 15:56:04 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,suleiman@google.com,heftig@archlinux.org,bgeffon@google.com,axelrasmussen@google.com,weixugc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-reset-page-lru-tier-bits-when-activating.patch removed from -mm tree
Message-Id: <20241016225605.43DE8C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: reset page lru tier bits when activating
has been removed from the -mm tree.  Its filename was
     mm-mglru-reset-page-lru-tier-bits-when-activating.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Xu <weixugc@google.com>
Subject: mm/mglru: reset page lru tier bits when activating
Date: Mon, 14 Oct 2024 22:12:31 +0000

folio_activate() calls lru_gen_add_folio() to move the folio to the
youngest generation.  But unlike folio_update_gen()/folio_inc_gen(),
lru_gen_add_folio() doesn't reset the folio lru tier bits (LRU_REFS_MASK |
LRU_REFS_FLAGS).  Fix this inconsistency in lru_gen_add_folio() when
activating a folio.

Link: https://lkml.kernel.org/r/20241014221231.832959-1-weixugc@google.com
Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
Signed-off-by: Wei Xu <weixugc@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens <heftig@archlinux.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    5 ++++-
 include/linux/mmzone.h    |    2 ++
 mm/vmscan.c               |    2 --
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-reset-page-lru-tier-bits-when-activating
+++ a/include/linux/mm_inline.h
@@ -222,6 +222,7 @@ static inline bool lru_gen_add_folio(str
 {
 	unsigned long seq;
 	unsigned long flags;
+	unsigned long mask;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -257,7 +258,9 @@ static inline bool lru_gen_add_folio(str
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags, LRU_GEN_MASK | BIT(PG_active), flags);
+	mask = LRU_GEN_MASK | BIT(PG_active);
+	mask |= folio_test_active(folio) ? (LRU_REFS_MASK | LRU_REFS_FLAGS) : 0;
+	set_mask_bits(&folio->flags, mask, flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
--- a/include/linux/mmzone.h~mm-mglru-reset-page-lru-tier-bits-when-activating
+++ a/include/linux/mmzone.h
@@ -403,6 +403,8 @@ enum {
 	NR_LRU_GEN_CAPS
 };
 
+#define LRU_REFS_FLAGS		(BIT(PG_referenced) | BIT(PG_workingset))
+
 #define MIN_LRU_BATCH		BITS_PER_LONG
 #define MAX_LRU_BATCH		(MIN_LRU_BATCH * 64)
 
--- a/mm/vmscan.c~mm-mglru-reset-page-lru-tier-bits-when-activating
+++ a/mm/vmscan.c
@@ -2607,8 +2607,6 @@ static bool should_clear_pmd_young(void)
  *                          shorthand helpers
  ******************************************************************************/
 
-#define LRU_REFS_FLAGS	(BIT(PG_referenced) | BIT(PG_workingset))
-
 #define DEFINE_MAX_SEQ(lruvec)						\
 	unsigned long max_seq = READ_ONCE((lruvec)->lrugen.max_seq)
 
_

Patches currently in -mm which might be from weixugc@google.com are

mm-mglru-only-clear-kswapd_failures-if-reclaimable.patch

