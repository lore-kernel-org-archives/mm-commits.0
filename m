Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972667;
	b=cdUnBh3y9rWLkuBixpr053zyHUA3ZCJ+odhRGG9SOVwRv8C2AHOtFf+0q8Ki/39zHpvQ
	 jg2mfap4mgfOq+FaKWLIc7GNRq0QWoGQ7m3BGPsk5I0rTvmmvpS30zCCE9zSUQ/y67eFs
	 XlIvu8WtNrqaKhe+qJXDm0rnyK9/Wl6ik4s4DIXs8icXY+PLc096XEYT3Q6YfixiAU0xv
	 loohF1CMkUSzQ0JDIveiY4rpr6SPYN1wSfUHmsCfHM2wCA7kAuYHrhPu0x5F8iBBysj2n
	 OaNR0g+sj65NvhjO2cI74KMwKXoCgAU0S8RHbqMI+h+LkVvaza5G77juJpPoFLKqx9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972667;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Viu5cEbPA4xJ1Z653E4ZTjWn5epVjLtqpAyYtUCe4qw=;
	b=HjfAjs6NpSzN4y2LshrgdyOM0OAf/F6B2uGJq7kQDdvynVQR3MCa9L4gWEWn3irxYbSw
	 NG9kQJuvKFf3HT1D05P7NZkT8MZ7c+DBGQkR+J+5FMpjNhkRzVaillod8EKb6bgZhrglk
	 KwW+kbeNoc/K8J8so7twGvQl/gI8OVloobwuSehCAmTTlENBJWU/x6EPNkLZyb/M/sBSR
	 +anQtidVLslIL/MVxNX33M7W0fIldOyeUC4rlLhP/RHV8KQtthZVq7Q643bkKvz0N4Hxa
	 huN3WdB2UnHEE3Xvu7sieHeK0i9rRoR+sGSdyV4SX8d4eH9aGTd2eqejBN1fjkxxp/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Ks/JTL4y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C60606A333;
	Wed, 18 Nov 2026 03:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ks/JTL4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD451F000D2;
	Wed, 18 Nov 2026 03:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794972666;
	bh=Viu5cEbPA4xJ1Z653E4ZTjWn5epVjLtqpAyYtUCe4qw=;
	h=Date:To:From:Subject;
	b=Ks/JTL4y0VtMVDGouT1jZ5AKYP8Aj7hiz3qhb3Ja9NaHjrBtvYPt7P5HdTZuzJ56e
	 +E73r1JFEq3hLPIbP46wAqKYj0cm3ykI/iL3qFbHc+rvSjZEkqGRruMZnBc8MVFsFF
	 bk6e6kJ2OiIiYTmWmSJG2rurX9L5u1AXrMKhThOo=
Date: Tue, 17 Nov 2026 19:31:06 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,
	stable@vger.kernel.org,osalvador@suse.de,osalvador@kernel.org,
	muchun.song@linux.dev,lance.yang@linux.dev,fvdl@google.com,david@kernel.org,
	azpijr@gmail.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios.patch added to mm-new branch
Message-Id: <20261118033106.CDD451F000D2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
Date: Tue, 17 Nov 2026 17:33:58 +0800

Long-term pinning rejects HugeTLB folios explicitly allocated from CMA,
causing unnecessary migration or pinning failures.  These folios already
own their CMA memory and do not need to be migrated out for future CMA
allocations.

Add cma_folio_is_longterm_pinnable() to recognize these allocations
through HPG_cma.  Allow them to be pinned even in ZONE_MOVABLE, since
memory blocks overlapping boot-time CMA areas cannot be offlined. 
Ordinary movable allocations that borrow CMA memory remain unpinnable.

Link: https://lore.kernel.org/295af6601ce79f2c2b3dc4352a3279f0e6ac513e.1794907279.git.zhengqi.arch@bytedance.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>

 include/linux/cma.h |    3 +++
 include/linux/mm.h  |    9 ++++++---
 mm/cma.c            |   11 +++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

--- a/include/linux/cma.h~mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios
+++ a/include/linux/cma.h
@@ -21,6 +21,9 @@
 #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
 
 struct cma;
+struct folio;
+
+bool cma_folio_is_longterm_pinnable(struct folio *folio);
 
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
--- a/include/linux/mm.h~mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios
+++ a/include/linux/mm.h
@@ -38,6 +38,7 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
+#include <linux/cma.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -2984,15 +2985,18 @@ static inline bool is_zero_folio(const s
 	return is_zero_page(&folio->page);
 }
 
-/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
 #ifdef CONFIG_MIGRATION
+/*
+ * MIGRATE_CMA and ZONE_MOVABLE folios cannot normally be long-term pinned.
+ * CMA may allow pinning folios explicitly allocated from its areas.
+ */
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
 #ifdef CONFIG_CMA
 	int mt = folio_migratetype(folio);
 
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
-		return false;
+		return cma_folio_is_longterm_pinnable(folio);
 #endif
 	/* The zero page can be "pinned" but gets special handling. */
 	if (is_zero_folio(folio))
@@ -3011,7 +3015,6 @@ static inline bool folio_is_longterm_pin
 
 	/* Otherwise, non-movable zone folios can be pinned. */
 	return !folio_is_zone_movable(folio);
-
 }
 #else
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
--- a/mm/cma.c~mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios
+++ a/mm/cma.c
@@ -29,6 +29,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
+#include <linux/hugetlb.h>
 #include <trace/events/cma.h>
 
 #include "internal.h"
@@ -38,6 +39,16 @@
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
 
+bool cma_folio_is_longterm_pinnable(struct folio *folio)
+{
+	/*
+	 * Explicitly allocated CMA folios own their CMA memory and can be
+	 * pinned even in ZONE_MOVABLE, as CMA memory cannot be offlined.
+	 * For now, only HugeTLB tracks these allocations with a folio flag.
+	 */
+	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
+}
+
 phys_addr_t cma_get_base(const struct cma *cma)
 {
 	WARN_ON_ONCE(cma->nranges != 1);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

x86-hugetlb-disable-default-cma-reservations-on-32-bit-kernel.patch
mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios.patch
mm-hugetlb-fix-gfp-mask-propagation-to-cma.patch

