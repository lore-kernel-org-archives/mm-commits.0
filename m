Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2D119BA6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957038; cv=none; b=oSUa8l21W/hXiuxAfXfjhlvbyfYoBdLU23fiD9IS/vd/Xdsi2BoHoJY2AWjW3O0rJnkq/9uOAzLpNNprMrKCFjwRoLfNl44PtzhzkJRgpWcUXpkEQJd5ZcWjSfMPcAaUYngImiEcJcHZ9Tj8UBs1SgEX51qNCbYMp3pIB7x0v6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957038; c=relaxed/simple;
	bh=udZT8beTOS3HCWqBbLr9lk1V0JeQLk2tID/nLaMlgKk=;
	h=Date:To:From:Subject:Message-Id; b=IADBStw6q6aHL+sW15V0un+4doW2sZ54YOPmdboYbPb1H1mwGtT6Q2epO4A3NMcsejfK7GjpLtyZ1K+XG84uKsRRu3PtSO3+NIu4irfccFpYoiTQYOYXpa4w6yAtmmZXqvDYgBS7FKisK87906rTmi6/Cut/7oywenBvpRtkDn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WkpwtQ+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WkpwtQ+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036F8C113CC;
	Mon,  6 May 2024 00:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957038;
	bh=udZT8beTOS3HCWqBbLr9lk1V0JeQLk2tID/nLaMlgKk=;
	h=Date:To:From:Subject:From;
	b=WkpwtQ+C6QQYPsaT2Gy4r2PfOvPuMfpyH7KaPeMUTOTOHrSIh7Ri5+DV2JcYQ8GAz
	 i2uFXBMJDOdWCgZ/DOvouA7m13psx4+QAhn/H2z+pQqwW2QF7VINxsF6zJnuUz3hI9
	 PItxPzm7luFtMm3hhKIZoaKwLGXda/mUrVfTIKFE=
Date: Sun, 05 May 2024 17:57:17 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch removed from -mm tree
Message-Id: <20240506005718.036F8C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add per-order mTHP anon_fault_alloc and anon_fault_fallback counters
has been removed from the -mm tree.  Its filename was
     mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: add per-order mTHP anon_fault_alloc and anon_fault_fallback counters
Date: Fri, 12 Apr 2024 23:48:55 +1200

Patch series "mm: add per-order mTHP alloc and swpout counters", v6.

The patchset introduces a framework to facilitate mTHP counters, starting
with the allocation and swap-out counters.  Currently, only four new nodes
are appended to the stats directory for each mTHP size.

/sys/kernel/mm/transparent_hugepage/hugepages-<size>/stats
	anon_fault_alloc
	anon_fault_fallback
	anon_fault_fallback_charge
	anon_swpout
	anon_swpout_fallback

These nodes are crucial for us to monitor the fragmentation levels of both
the buddy system and the swap partitions.  In the future, we may consider
adding additional nodes for further insights.


This patch (of 4):

Profiling a system blindly with mTHP has become challenging due to the
lack of visibility into its operations.  Presenting the success rate of
mTHP allocations appears to be pressing need.

Recently, I've been experiencing significant difficulty debugging
performance improvements and regressions without these figures.  It's
crucial for us to understand the true effectiveness of mTHP in real-world
scenarios, especially in systems with fragmented memory.

This patch establishes the framework for per-order mTHP counters.  It
begins by introducing the anon_fault_alloc and anon_fault_fallback
counters.  Additionally, to maintain consistency with
thp_fault_fallback_charge in /proc/vmstat, this patch also tracks
anon_fault_fallback_charge when mem_cgroup_charge fails for mTHP. 
Incorporating additional counters should now be straightforward as well.

Link: https://lkml.kernel.org/r/20240412114858.407208-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240412114858.407208-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   21 +++++++++++++++
 mm/huge_memory.c        |   52 ++++++++++++++++++++++++++++++++++++++
 mm/memory.c             |    5 +++
 3 files changed, 78 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters
+++ a/include/linux/huge_mm.h
@@ -264,6 +264,27 @@ unsigned long thp_vma_allowable_orders(s
 					  enforce_sysfs, orders);
 }
 
+enum mthp_stat_item {
+	MTHP_STAT_ANON_FAULT_ALLOC,
+	MTHP_STAT_ANON_FAULT_FALLBACK,
+	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
+	__MTHP_STAT_COUNT
+};
+
+struct mthp_stat {
+	unsigned long stats[ilog2(MAX_PTRS_PER_PTE) + 1][__MTHP_STAT_COUNT];
+};
+
+DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
+
+static inline void count_mthp_stat(int order, enum mthp_stat_item item)
+{
+	if (order <= 0 || order > PMD_ORDER)
+		return;
+
+	this_cpu_inc(mthp_stats.stats[order][item]);
+}
+
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
--- a/mm/huge_memory.c~mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters
+++ a/mm/huge_memory.c
@@ -526,6 +526,48 @@ static const struct kobj_type thpsize_kt
 	.sysfs_ops = &kobj_sysfs_ops,
 };
 
+DEFINE_PER_CPU(struct mthp_stat, mthp_stats) = {{{0}}};
+
+static unsigned long sum_mthp_stat(int order, enum mthp_stat_item item)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct mthp_stat *this = &per_cpu(mthp_stats, cpu);
+
+		sum += this->stats[order][item];
+	}
+
+	return sum;
+}
+
+#define DEFINE_MTHP_STAT_ATTR(_name, _index)				\
+static ssize_t _name##_show(struct kobject *kobj,			\
+			struct kobj_attribute *attr, char *buf)		\
+{									\
+	int order = to_thpsize(kobj)->order;				\
+									\
+	return sysfs_emit(buf, "%lu\n", sum_mthp_stat(order, _index));	\
+}									\
+static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
+DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+
+static struct attribute *stats_attrs[] = {
+	&anon_fault_alloc_attr.attr,
+	&anon_fault_fallback_attr.attr,
+	&anon_fault_fallback_charge_attr.attr,
+	NULL,
+};
+
+static struct attribute_group stats_attr_group = {
+	.name = "stats",
+	.attrs = stats_attrs,
+};
+
 static struct thpsize *thpsize_create(int order, struct kobject *parent)
 {
 	unsigned long size = (PAGE_SIZE << order) / SZ_1K;
@@ -549,6 +591,12 @@ static struct thpsize *thpsize_create(in
 		return ERR_PTR(ret);
 	}
 
+	ret = sysfs_create_group(&thpsize->kobj, &stats_attr_group);
+	if (ret) {
+		kobject_put(&thpsize->kobj);
+		return ERR_PTR(ret);
+	}
+
 	thpsize->order = order;
 	return thpsize;
 }
@@ -880,6 +928,8 @@ static vm_fault_t __do_huge_pmd_anonymou
 		folio_put(folio);
 		count_vm_event(THP_FAULT_FALLBACK);
 		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 		return VM_FAULT_FALLBACK;
 	}
 	folio_throttle_swaprate(folio, gfp);
@@ -929,6 +979,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
 	}
 
@@ -1050,6 +1101,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 	folio = vma_alloc_folio(gfp, HPAGE_PMD_ORDER, vma, haddr, true);
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
 	return __do_huge_pmd_anonymous_page(vmf, &folio->page, gfp);
--- a/mm/memory.c~mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters
+++ a/mm/memory.c
@@ -4368,6 +4368,7 @@ static struct folio *alloc_anon_folio(st
 		folio = vma_alloc_folio(gfp, order, vma, addr, true);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 				folio_put(folio);
 				goto next;
 			}
@@ -4376,6 +4377,7 @@ static struct folio *alloc_anon_folio(st
 			return folio;
 		}
 next:
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
 		order = next_order(&orders, order);
 	}
 
@@ -4485,6 +4487,9 @@ static vm_fault_t do_anonymous_page(stru
 
 	folio_ref_add(folio, nr_pages - 1);
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
+#endif
 	folio_add_new_anon_rmap(folio, vma, addr);
 	folio_add_lru_vma(folio, vma);
 setpte:
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


