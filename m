Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E028C171E42
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 20:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712348012; cv=none; b=lIq9ftBB7w92a5lIygvuGa74xZ4/G5ASuBgFOiRN/msy7CUaFRpGDIZAa2np+GyBd5ptz/1dKJpT3+/RyGzwFox3fUYklp7bAjOKDi6QiztXJLMZARaBq09yMyqa6jr2O00Sw3Ugbpf1r3xqGYTS0QrOYXgx2WHO6kpPP93EiMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712348012; c=relaxed/simple;
	bh=rOAFmps2OQB1+g9MhnOWf+4b50xn1a8EovoiYl+2KH4=;
	h=Date:To:From:Subject:Message-Id; b=hcXYTUG48n5YnskWTJEkoAL3snNprNCVbY2YLzSWzPcVBNRyei0g+XMwA42ksq3L/crqAORifUB8uL0DN6DJTdo1O4SxQGUIcQUd7TghqoV5dcoJ3i4mtKaegzCH6+urG5WL1FICBlh5HOQ5kIjOM4RMzsCGfTp4OMa6GbeQlUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VqbEgtlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VqbEgtlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C005C433C7;
	Fri,  5 Apr 2024 20:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712348011;
	bh=rOAFmps2OQB1+g9MhnOWf+4b50xn1a8EovoiYl+2KH4=;
	h=Date:To:From:Subject:From;
	b=VqbEgtlqoCgAL6xbOKaK68vS52qlFOj94V33vIOlUEkeBVpvlquleeoHvlmOj+EwH
	 15DwHH/laSSXNGJ8akmwm1Hva7wckb+D1JAFgRl7KdBcweObeWH7gz51hLyvWlGMxB
	 aZ1CsGK0vYWx0gq6DGHwoi5VXqhtqlDq0nvOdgIA=
Date: Fri, 05 Apr 2024 13:13:30 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters.patch added to mm-unstable branch
Message-Id: <20240405201331.5C005C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add per-order mTHP anon_alloc and anon_alloc_fallback counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters.patch

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
Subject: mm: add per-order mTHP anon_alloc and anon_alloc_fallback counters
Date: Fri, 5 Apr 2024 23:27:03 +1300

Patch series "mm: add per-order mTHP alloc and swpout counters", v4.

The patchset introduces a framework to facilitate mTHP counters, starting
with the allocation and swap-out counters.  Currently, only four new nodes
are appended to the stats directory for each mTHP size.

/sys/kernel/mm/transparent_hugepage/hugepages-<size>/stats
	anon_alloc
	anon_alloc_fallback
	anon_swpout
	anon_swpout_fallback

These four nodes are crucial for us to monitor the fragmentation levels of
both the buddy system and the swapfile.  In the future, we may consider
adding additional nodes for further insights.


This patch (of 2):

Profiling a system blindly with mTHP has become challenging due to the
lack of visibility into its operations.  Presenting the success rate of
mTHP allocations appears to be pressing need.

Recently, I've been experiencing significant difficulty debugging
performance improvements and regressions without these figures.  It's
crucial for us to understand the true effectiveness of mTHP in real-world
scenarios, especially in systems with fragmented memory.

This patch sets up the framework for per-order mTHP counters, starting
with the introduction of anon_alloc and anon_alloc_fallback counters. 
Incorporating additional counters should now be straightforward as well.

Link: https://lkml.kernel.org/r/20240405102704.77559-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240405102704.77559-2-21cnbao@gmail.com
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   19 +++++++++++++++
 mm/huge_memory.c        |   48 ++++++++++++++++++++++++++++++++++++++
 mm/memory.c             |    2 +
 3 files changed, 69 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters
+++ a/include/linux/huge_mm.h
@@ -264,6 +264,25 @@ unsigned long thp_vma_allowable_orders(s
 					  enforce_sysfs, orders);
 }
 
+enum mthp_stat_item {
+	MTHP_STAT_ANON_ALLOC,
+	MTHP_STAT_ANON_ALLOC_FALLBACK,
+	__MTHP_STAT_COUNT
+};
+
+struct mthp_stat {
+	unsigned long stats[PMD_ORDER + 1][__MTHP_STAT_COUNT];
+};
+
+DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
+
+static inline void count_mthp_stat(int order, enum mthp_stat_item item)
+{
+	if (unlikely(order > PMD_ORDER))
+		return;
+	this_cpu_inc(mthp_stats.stats[order][item]);
+}
+
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
--- a/mm/huge_memory.c~mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters
+++ a/mm/huge_memory.c
@@ -526,6 +526,46 @@ static const struct kobj_type thpsize_kt
 	.sysfs_ops = &kobj_sysfs_ops,
 };
 
+DEFINE_PER_CPU(struct mthp_stat, mthp_stats) = {{{0}}};
+
+static unsigned long sum_mthp_stat(int order, enum mthp_stat_item item)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		struct mthp_stat *this = &per_cpu(mthp_stats, cpu);
+
+		sum += this->stats[order][item];
+	}
+
+	return sum;
+}
+
+#define DEFINE_MTHP_STAT_ATTR(_name, _index)					\
+static ssize_t _name##_show(struct kobject *kobj,			\
+			struct kobj_attribute *attr, char *buf)		\
+{									\
+	int order = to_thpsize(kobj)->order;				\
+									\
+	return sysfs_emit(buf, "%lu\n", sum_mthp_stat(order, _index));	\
+}									\
+static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+DEFINE_MTHP_STAT_ATTR(anon_alloc, MTHP_STAT_ANON_ALLOC);
+DEFINE_MTHP_STAT_ATTR(anon_alloc_fallback, MTHP_STAT_ANON_ALLOC_FALLBACK);
+
+static struct attribute *stats_attrs[] = {
+	&anon_alloc_attr.attr,
+	&anon_alloc_fallback_attr.attr,
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
@@ -549,6 +589,12 @@ static struct thpsize *thpsize_create(in
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
@@ -1050,8 +1096,10 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 	folio = vma_alloc_folio(gfp, HPAGE_PMD_ORDER, vma, haddr, true);
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_ALLOC_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
+	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_ALLOC);
 	return __do_huge_pmd_anonymous_page(vmf, &folio->page, gfp);
 }
 
--- a/mm/memory.c~mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters
+++ a/mm/memory.c
@@ -4374,8 +4374,10 @@ static struct folio *alloc_anon_folio(st
 			}
 			folio_throttle_swaprate(folio, gfp);
 			clear_huge_page(&folio->page, vmf->address, 1 << order);
+			count_mthp_stat(order, MTHP_STAT_ANON_ALLOC);
 			return folio;
 		}
+		count_mthp_stat(order, MTHP_STAT_ANON_ALLOC_FALLBACK);
 next:
 		order = next_order(&orders, order);
 	}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch

