Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974312C683
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 23:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712963294; cv=none; b=SYIAwM7W4Zoi7Gw5fHohOSi1bQYnMnERLfD78Em1HXpvUqOTpbsP88Tt4Qg5bRylUmN4//tIwVvIrXdfQBNTtcgobhqO0buONlYRjq0Do0o3cbL1TewLpGjch00/wB+8ebblnnTP7uZIVHNsCozO2SRkb261fOjjH2FQNHNYSDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712963294; c=relaxed/simple;
	bh=OFQuI1QJcHUvPzNqV8M4OLoq5qhcptEdWElqIbdXtYU=;
	h=Date:To:From:Subject:Message-Id; b=DDgQQYVdyYNKXyTFnpn/N/Q3L/ngS2S52v9jeJ8r5rZMTO79QPSBupMBGH8tTx2/C/cIjKqCij4UCqBUxak7nuhPXY3wAv9xJ27pZERaKlz4dGvh97l/zHvDliv42TtOemlXfFTWGB5vwFoinSSBpNfnbiZ8Wh0ou5/YJohjT/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ptO5e9Wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ptO5e9Wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB79C113CC;
	Fri, 12 Apr 2024 23:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712963294;
	bh=OFQuI1QJcHUvPzNqV8M4OLoq5qhcptEdWElqIbdXtYU=;
	h=Date:To:From:Subject:From;
	b=ptO5e9WjW5QwL43cSvp42M0mmb7bmHCct/j0WgXxbmoZBPLtrfeplv3G2JH6DiEDP
	 p0+oHXHfPraHhTQdCwIKiFjbJE47saUN1LncYWR+lxMuIorDaeGxz3rEH+LWEVIMNF
	 KN8veqPwV8RZGpU5devsqxsYePgbEqd0WgrhUk0k=
Date: Fri, 12 Apr 2024 16:08:13 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch added to mm-unstable branch
Message-Id: <20240412230813.EBB79C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add per-order mTHP anon_fault_alloc and anon_fault_fallback counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch

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
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
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

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch
mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

