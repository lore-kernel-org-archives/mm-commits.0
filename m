Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EA1171E42
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 20:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712348014; cv=none; b=jotmCbSc65W7wwgtOPzhwsU1k1Feo7YHUlzAwkndE53edHsdd95Sk4lSX3JQtDBlr95tDtUUN0Xu1D4hRVvv4/Bhf6kU+/XkJzqRd1Qo0Aa/ubNuRH1hkHglRGBjHUcJI93V8xgizMhclX2EKGz095B6JyNCf8q9OzJJIa1ugeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712348014; c=relaxed/simple;
	bh=6tQRk7AVG8YzqORb3Ch2/hpvWKM8haqaXUOwTPmZbiE=;
	h=Date:To:From:Subject:Message-Id; b=jBqzfL/3CfFX0O9XH2zktz3Q0vH7/v20sMiN4153NGPf+2j3o2nj16MZfCAZ0WPc2xpJZO+nvm/Hu4wUuBRH/VDMl99AmSrh64xzSRAUhW2EkKIR3tqSpbtGjqFO8aCvNa9N2qBwsK4zWrEWHPpnZRcj5nE9h+5pYC4EjQnOLk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0kOn9Zz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0kOn9Zz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21306C433C7;
	Fri,  5 Apr 2024 20:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712348014;
	bh=6tQRk7AVG8YzqORb3Ch2/hpvWKM8haqaXUOwTPmZbiE=;
	h=Date:To:From:Subject:From;
	b=0kOn9Zz1YvSmBC2ogf6FQUQfGxeijnVYEesOI5sTvJeAe7UVh4sjaTz3M8PdNEg1g
	 1eE7iY85TAnDK2O8ukuJlXLGWOQwQN8jY9cL1yzEBetkJSOc9u6COZhqLkdnFQUdka
	 F1vKatTMpGYVzm8gXIKlQtZ1QM4k4jL+kBjSQUrU=
Date: Fri, 05 Apr 2024 13:13:33 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch added to mm-unstable branch
Message-Id: <20240405201334.21306C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add per-order mTHP anon_swpout and anon_swpout_fallback counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch

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
Subject: mm: add per-order mTHP anon_swpout and anon_swpout_fallback counters
Date: Fri, 5 Apr 2024 23:27:04 +1300

This helps to display the fragmentation situation of the swapfile, knowing
the proportion of how much we haven't split large folios.  So far, we only
support non-split swapout for anon memory, with the possibility of
expanding to shmem in the future.  So, we add the "anon" prefix to the
counter names.

Link: https://lkml.kernel.org/r/20240405102704.77559-3-21cnbao@gmail.com
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

 include/linux/huge_mm.h |    2 ++
 mm/huge_memory.c        |    4 ++++
 mm/page_io.c            |    6 +++++-
 mm/vmscan.c             |    3 +++
 4 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/include/linux/huge_mm.h
@@ -267,6 +267,8 @@ unsigned long thp_vma_allowable_orders(s
 enum mthp_stat_item {
 	MTHP_STAT_ANON_ALLOC,
 	MTHP_STAT_ANON_ALLOC_FALLBACK,
+	MTHP_STAT_ANON_SWPOUT,
+	MTHP_STAT_ANON_SWPOUT_FALLBACK,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/huge_memory.c
@@ -554,10 +554,14 @@ static struct kobj_attribute _name##_att
 
 DEFINE_MTHP_STAT_ATTR(anon_alloc, MTHP_STAT_ANON_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_alloc_fallback, MTHP_STAT_ANON_ALLOC_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(anon_swpout, MTHP_STAT_ANON_SWPOUT);
+DEFINE_MTHP_STAT_ATTR(anon_swpout_fallback, MTHP_STAT_ANON_SWPOUT_FALLBACK);
 
 static struct attribute *stats_attrs[] = {
 	&anon_alloc_attr.attr,
 	&anon_alloc_fallback_attr.attr,
+	&anon_swpout_attr.attr,
+	&anon_swpout_fallback_attr.attr,
 	NULL,
 };
 
--- a/mm/page_io.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/page_io.c
@@ -212,13 +212,17 @@ int swap_writepage(struct page *page, st
 
 static inline void count_swpout_vm_event(struct folio *folio)
 {
+	long nr_pages = folio_nr_pages(folio);
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (unlikely(folio_test_pmd_mappable(folio))) {
 		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
 	}
+	if (nr_pages > 0)
+		count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_SWPOUT);
 #endif
-	count_vm_events(PSWPOUT, folio_nr_pages(folio));
+	count_vm_events(PSWPOUT, nr_pages);
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
--- a/mm/vmscan.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/vmscan.c
@@ -1230,6 +1230,9 @@ retry:
 						count_vm_event(
 							THP_SWPOUT_FALLBACK);
 					}
+					if (nr_pages > 0)
+						count_mthp_stat(get_order(nr_pages * PAGE_SIZE),
+							MTHP_STAT_ANON_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch

