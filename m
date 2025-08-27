Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA6B30F94E
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 23:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756337288; cv=none; b=NZMNpqvZnj8FOg+y9ytu4pwyfakl62GfCV21UqjEv4VQ+wV4vbdNEoTX/3jvXNEFWXkM/1/uFk+ln+zHAKtA6TvoSsUoVXjR3FtPXVDGvVAZvRlIiHTrrLHcufhAJW4mAHjkby2CUzYz6cANG+1V/0E+GbIueNC020G9Fc2AT7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756337288; c=relaxed/simple;
	bh=kv+c3mu1oM9KykPNL6Jbtgu7tgoRRzp/D6/tCMWqQnA=;
	h=Date:To:From:Subject:Message-Id; b=lZ5gK4WmvE3G3WiMf7xOfWo7eH0OsF2+EAWVn7boBtdY4vR+YboqnzjF2juO0wEJi78eqs9NBvR4vO0t6EEHcWNS54zEvu864vGj4BUw5v/OYWYIOYs1hPKojvMzmlqpunmoUSbaD3R4Bg6fN21pV+ngPV+mFq1R4lD+UopB1HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YcWSETIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YcWSETIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F58C4CEEB;
	Wed, 27 Aug 2025 23:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756337287;
	bh=kv+c3mu1oM9KykPNL6Jbtgu7tgoRRzp/D6/tCMWqQnA=;
	h=Date:To:From:Subject:From;
	b=YcWSETIbv7UN1jHzgp6KiSOsujP4jhXHWoLAe1G46ZeHWilgnWlTym+GYRxB5MEJC
	 5D+hoQffQzwXwf/ND8izh2EIPcW1Pby2D4hqDHP2ME9uuOipjt1tmfcLkUtKdoPf/5
	 G7Qx2+1gSC79QpCRk05KF/HNlZMKqBcXB0yN6u9Y=
Date: Wed, 27 Aug 2025 16:28:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,lorenzo.stoakes@oracle.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch added to mm-new branch
Message-Id: <20250827232807.96F58C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end
has been added to the -mm mm-new branch.  Its filename is
     mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end
Date: Wed, 27 Aug 2025 07:01:05 +0000

enum pageblock_bits defines the meaning of pageblock bits.  Currently
PB_migratetype_bits says the lowest 3 bits represents migratetype and
PB_migrate_end/MIGRATETYPE_MASK's definition rely on it with magical
computation.

Remove the definition of PB_migratetype_bits/PB_migrate_end.  Use
PB_migrate_[0|1|2] to represent lowest bits for migratetype.  Then we can
simplify related definition.

Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.  Use
MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
cleaner.

No functional change intended.

Link: https://lkml.kernel.org/r/20250827070105.16864-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |   12 +++++-------
 mm/page_alloc.c                 |    4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end
+++ a/include/linux/pageblock-flags.h
@@ -13,12 +13,11 @@
 
 #include <linux/types.h>
 
-#define PB_migratetype_bits 3
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
-	PB_migrate,
-	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
-			/* 3 bits required for migrate types */
+	PB_migrate_0,
+	PB_migrate_1,
+	PB_migrate_2,
 	PB_compact_skip,/* If set the block is skipped by compaction */
 
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -37,11 +36,10 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
+#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK \
-	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
+#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
 #else
 #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
 #endif
--- a/mm/page_alloc.c~mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end
+++ a/mm/page_alloc.c
@@ -355,7 +355,7 @@ static inline int pfn_to_bitidx(const st
 
 static __always_inline bool is_standalone_pb_bit(enum pageblock_bits pb_bit)
 {
-	return pb_bit > PB_migrate_end && pb_bit < __NR_PAGEBLOCK_BITS;
+	return pb_bit >= PB_compact_skip && pb_bit < __NR_PAGEBLOCK_BITS;
 }
 
 static __always_inline void
@@ -370,7 +370,7 @@ get_pfnblock_bitmap_bitidx(const struct
 #else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
-	BUILD_BUG_ON(__MIGRATE_TYPE_END >= (1 << PB_migratetype_bits));
+	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch
mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch

