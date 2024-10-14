Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD96E17BD3
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 23:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728948417; cv=none; b=oqrCmXVh5fcY21chLrwCjGuxVOw+XI5wPUSaIQnrU4eX4a4cg1puQzABwNLQz7JVdYeGfZMzKKVswf80xUAgmCtDZ+S0EFLUtBHIeR6o2jN1A0uJ2Y97Sat2g1bKX/IjZLujXmDF7b+LEx5FoSfeyNCv8faFIgUErHwb6gbKyYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728948417; c=relaxed/simple;
	bh=NR06lYttAqnjqJnGPnwhdrV2NQoGNaodOfOflxgvMec=;
	h=Date:To:From:Subject:Message-Id; b=qBQzy7UIlwcFBlaRtiDvMCGpdYZYW+bq9SS2zLTHnzseHlE5r6R5B9PIOS4LJtS739pYlv6qX9cX3iOWqEJNVpyajM0yOZNmvDMEwf2qkby0botgiX3Gyu5ABV+jtEwen2DjUEOAiBQtgptpcv8eHSYpsBDnvV+iIRmd4vFbMKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EWcfb1IX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EWcfb1IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648DBC4CEC3;
	Mon, 14 Oct 2024 23:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728948417;
	bh=NR06lYttAqnjqJnGPnwhdrV2NQoGNaodOfOflxgvMec=;
	h=Date:To:From:Subject:From;
	b=EWcfb1IXE8kga1YunsQz293paJsAWyPFgTMN1TJpymsk7FOolSJKK9xJoJL9nZeR9
	 kYQtFFRWRfb5ZNmQaNmKYXVYdNvFEcwAzpB2uHouxmJXQHfrONRZmPRgmz6ld5aEPQ
	 cj+gvT81id83WpSeg0uXQx/P95DN7F5RkP71bkv8=
Date: Mon, 14 Oct 2024 16:26:56 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,suleiman@google.com,heftig@archlinux.org,bgeffon@google.com,axelrasmussen@google.com,weixugc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-reset-page-lru-tier-bits-when-activating.patch added to mm-unstable branch
Message-Id: <20241014232657.648DBC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: reset page lru tier bits when activating
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-reset-page-lru-tier-bits-when-activating.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-reset-page-lru-tier-bits-when-activating.patch

This patch will later appear in the mm-unstable branch at
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
mm-mglru-reset-page-lru-tier-bits-when-activating.patch

