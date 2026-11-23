Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465417;
	b=MyXad0kwMcnxiYa9jeMUHSMv9xUUPJUVDtnowOJtQ9dt2Z7yjrSk3M/U+HL45pyJVo/1
	 JEtSH9Hk8HDKQEswB6/ZGWn8mJNkunPqB7AHx4PKuCsFUNhtJ46B4d4aO3wYyDsmHgYY2
	 fzb6vt0wSWJRdm+yd4TlSYEd1y/MkBCsGJSD07wlOdcMFi4rqHn1uDpLLpcEv/l7RM3sG
	 xX22p0sbpvvF5sG/gafA34t8s+QbDtuYHXCkksOuu8+CNm/eQtGuU2yAZAikYV74drPcV
	 4vV3R+RMVRMC7t1D1cNnCJgTC9LuqCyQSQYCl67Iwi4fxTA0TYzPcf4ZiRy529BC83Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465417;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=fMe906Jyh0523HR9+HxPnKYkqbRFRtAg5r+ybh7EhbE=;
	b=e5GaDSSQ3GM+0uPsdEScTT2Y0n9FN6jZyRZyHhE1QpkoCXO1t6U3t8A46dvBj5O5O4eS
	 1mL327Gaw1YiB5TTzQvbarlNMq2ofWwNXq7i8kMl1eQ1IWCOwcNugIqJbYStoXTZnZjNh
	 Iwry2BuhjXJ74Jjrb7vaqLSDJ5fA+M03bWptOtkYFlSrt+NRVhD9RLd84OMlC6AQY3X6o
	 KmH0tUcX8dHGjZfVrxl+dDJK6vBybH3jaY9JuPqz1vFrj8/8eVAZt55gQFDgwmjCS0jF8
	 3j8tV1XIVtzTnb+RJ2/Glgv/eKf4w3cE57U5moCU9n/ucGvCSQzmOU4aRPvz5vElEDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vmSFFGKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE59C606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 20:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vmSFFGKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4E61F000CA;
	Mon, 23 Nov 2026 20:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465417;
	bh=fMe906Jyh0523HR9+HxPnKYkqbRFRtAg5r+ybh7EhbE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=vmSFFGKpkoMp/Vx2Sa3aV93+kVTwqT8htUp+ynURMMIK5cZ+KZuPkpRVWxYdp3dPv
	 U9DqF4z9I8EhzHNFZ5R70Q1MRNnCr7pvtk8tsc4bPqte+PK1N0B6Mu4OOMPYFgiY4k
	 lsDK0n2kmMPpjwcBG+D+Ap2PG+Cxup5yTfwJnOR8=
Date: Mon, 23 Nov 2026 12:23:36 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-16-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-16-8ffea39934a6@tencent.com>
Subject: + mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch added to mm-new branch
Message-Id: <20261123202337.4C4E61F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: make PG_workingset helpers work based on folio LRU refs
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: make PG_workingset helpers work based on folio LRU refs
Date: Tue, 24 Nov 2026 02:53:08 +0800

folio_test_workingset() currently tests the PG_workingset bit, which
is only the second lowest access bit of the folio LRU refs count now.
Folios with refs 4 or 5 carry it in the LRU_REFS_MASK field
and no longer have PG_workingset set, so the bit test misses them.

folio_set_workingset() currently sets the PG_workingset bit with a
plain set_bit(), which also over-promotes folios at a higher refs
count: e.g. a folio at refs 4 is bumped to refs 6, advancing it
toward LRU_REFS_MAX and an earlier generation promotion.

Move both helpers into mm_inline.h, the test as an inline helper based
on folio_lru_refs(), checking refs >= LRU_REFS_WORKINGSET.

The set stays reserved for the classical LRU, as under MGLRU the refs
count is maintained by folio_inc_lru_refs(): it now warns when the folio
is on a gen list, where the raw bit would corrupt its refs count.

MADV_COLD, the one caller that runs on an on-list folio, sets the
count with folio_set_lru_refs() instead. The one PageWorkingset() user
in erofs is converted to the folio helper.

There is no behavior change for the classical LRU: it does not maintain
the refs count, so for a folio that was never on a gen list the test is
equivalent to the PG_workingset bit test.

This prepares the convention for follow up MGLRU change.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-16-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 fs/btrfs/compression.c     |    1 +
 fs/erofs/zdata.c           |    3 ++-
 include/linux/mm_inline.h  |   30 ++++++++++++++++++++++++++++++
 include/linux/page-flags.h |    2 --
 mm/filemap.c               |    1 +
 mm/madvise.c               |    2 +-
 mm/page_io.c               |    1 +
 7 files changed, 36 insertions(+), 4 deletions(-)

--- a/fs/btrfs/compression.c~mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs
+++ a/fs/btrfs/compression.c
@@ -8,6 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/mm_inline.h>
 #include <linux/folio_batch.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
--- a/fs/erofs/zdata.c~mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs
+++ a/fs/erofs/zdata.c
@@ -6,6 +6,7 @@
  */
 #include "compress.h"
 #include <linux/psi.h>
+#include <linux/mm_inline.h>
 #include <linux/cpuhotplug.h>
 #include <trace/events/erofs.h>
 
@@ -1713,7 +1714,7 @@ drain_io:
 				DBG_BUGON(bvec.bv_len < sb->s_blocksize);
 			}
 
-			if (unlikely(PageWorkingset(bvec.bv_page)) &&
+			if (unlikely(folio_test_workingset(page_folio(bvec.bv_page))) &&
 			    !memstall) {
 				psi_memstall_enter(&pflags);
 				memstall = 1;
--- a/include/linux/mm_inline.h~mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs
+++ a/include/linux/mm_inline.h
@@ -283,6 +283,21 @@ static inline void folio_migrate_lru_ref
 	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 
+/**
+ * folio_test_workingset - Test if a folio is in the workingset.
+ * @folio: the folio
+ *
+ * A folio is workingset when its LRU refs count reaches
+ * LRU_REFS_WORKINGSET. Under the classical LRU flag encoding,
+ * this is just testing the PG_workingset bit.
+ *
+ * Return: true if the folio is workingset.
+ */
+static __always_inline bool folio_test_workingset(const struct folio *folio)
+{
+	return lru_refs_is_workingset(folio_lru_refs(folio));
+}
+
 #ifdef CONFIG_LRU_GEN
 static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
 {
@@ -544,6 +559,21 @@ static inline void folio_clear_lru_refs(
 		folio_clear_referenced(folio);
 }
 
+/*
+ * For the classical LRU or isolated folios only: with MGLRU the PG_workingset
+ * bit is part of the folio refs count maintained by folio_inc_lru_refs(),
+ * a raw set would corrupt it.  The warning below catches folios still on a
+ * gen list, the classical paths in the switching window only see off-list ones.
+ */
+static __always_inline void folio_set_workingset(struct folio *folio)
+{
+	unsigned long flags;
+
+	flags = set_mask_bits(folio_flags(folio, 0), BIT(PG_workingset),
+			      BIT(PG_workingset));
+	VM_WARN_ON_ONCE(lru_get_gen_flags(flags) != -1);
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
--- a/include/linux/page-flags.h~mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs
+++ a/include/linux/page-flags.h
@@ -549,8 +549,6 @@ PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEF
 FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
-PAGEFLAG(Workingset, workingset, PF_HEAD)
-	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
 
 /* Xen */
--- a/mm/filemap.c~mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs
+++ a/mm/filemap.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
+#include <linux/mm_inline.h>
 #include <linux/leafops.h>
 #include <linux/syscalls.h>
 #include <linux/mman.h>
--- a/mm/madvise.c~mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs
+++ a/mm/madvise.c
@@ -378,7 +378,7 @@ static void madvise_cold_prep_folio(stru
 	if (!lru_gen_enabled()) {
 		folio_clear_lru_refs(folio);
 		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+			folio_set_lru_refs(folio, LRU_REFS_WORKINGSET);
 	}
 }
 
--- a/mm/page_io.c~mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs
+++ a/mm/page_io.c
@@ -16,6 +16,7 @@
 #include <linux/gfp.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/mm_inline.h>
 #include <linux/bio.h>
 #include <linux/swapops.h>
 #include <linux/writeback.h>
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch
mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch
mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats.patch
mm-mglru-make-generation-page-counters-atomic.patch
mm-memcg-add-folio-based-lruvec-live-helper.patch
mm-mglru-frequency-guided-workingset-promotion-mglru-fg.patch
mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch
mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch
mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch
mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru.patch
mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch
mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

