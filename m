Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2252C683
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 23:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712963296; cv=none; b=tJLjYDWw3mqJIpFioRuvhmOWbreI+UIqnQm7J/cjF2Lj3051Q3FOaODgJLyh2HKyChg/0lXYjSgytEkoXRhvGAQcCqQ4kLmYTn0+E/9j3tAHWtMaJR2UFM9SMixH2S8iCOdIHaIR0NNCYkAbwsw9MjoCR8Zds4UqteuYj2LFe0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712963296; c=relaxed/simple;
	bh=hJ0ZCoTTwzw8bepwDlnSYhVN0JYyYvURd3DWzSUatkQ=;
	h=Date:To:From:Subject:Message-Id; b=U34FoWFBQ9A5cfFmANLLMD4ph4tuI3l4Gk7jtZLkBn0jCR6uZEGhCY+DPNk+KMcyOWXnBdDR0PbQuACvEM1hZXC2jxxJ8M7Ev/xNkqcn/70JZlJztG4gKvTQ72RPfLGQuIgRWc5/P7vNqJrvSzN+E31b6JvBGm5F8kkyf9jesCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N5P9+tA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N5P9+tA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C835C113CC;
	Fri, 12 Apr 2024 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712963296;
	bh=hJ0ZCoTTwzw8bepwDlnSYhVN0JYyYvURd3DWzSUatkQ=;
	h=Date:To:From:Subject:From;
	b=N5P9+tA+zQEbdVHAvR16qnHz616xoWcUmKwlSBPmr0mmRMtrRAvAV36TKdb1MZNms
	 iD8hIuq0LXSzL/lYWXo9iPKPXCu8I4OXtPPoR9dkKENREiailLUG5qesytah2QXjgd
	 AAxCYVr1fkmmwtNvMTWGUBUK/Uk9IPsHhcStnJP4=
Date: Fri, 12 Apr 2024 16:08:15 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch added to mm-unstable branch
Message-Id: <20240412230816.2C835C113CC@smtp.kernel.org>
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
Date: Fri, 12 Apr 2024 23:48:56 +1200

This helps to display the fragmentation situation of the swapfile, knowing
the proportion of how much we haven't split large folios.  So far, we only
support non-split swapout for anon memory, with the possibility of
expanding to shmem in the future.  So, we add the "anon" prefix to the
counter names.

Link: https://lkml.kernel.org/r/20240412114858.407208-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
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

 include/linux/huge_mm.h |    2 ++
 mm/huge_memory.c        |    4 ++++
 mm/page_io.c            |    1 +
 mm/vmscan.c             |    3 +++
 4 files changed, 10 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/include/linux/huge_mm.h
@@ -268,6 +268,8 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_ALLOC,
 	MTHP_STAT_ANON_FAULT_FALLBACK,
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
+	MTHP_STAT_ANON_SWPOUT,
+	MTHP_STAT_ANON_SWPOUT_FALLBACK,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/huge_memory.c
@@ -555,11 +555,15 @@ static struct kobj_attribute _name##_att
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(anon_swpout, MTHP_STAT_ANON_SWPOUT);
+DEFINE_MTHP_STAT_ATTR(anon_swpout_fallback, MTHP_STAT_ANON_SWPOUT_FALLBACK);
 
 static struct attribute *stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
 	&anon_fault_fallback_attr.attr,
 	&anon_fault_fallback_charge_attr.attr,
+	&anon_swpout_attr.attr,
+	&anon_swpout_fallback_attr.attr,
 	NULL,
 };
 
--- a/mm/page_io.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/page_io.c
@@ -217,6 +217,7 @@ static inline void count_swpout_vm_event
 		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
 	}
+	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_SWPOUT);
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
--- a/mm/vmscan.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/vmscan.c
@@ -1214,6 +1214,8 @@ retry:
 						goto activate_locked;
 				}
 				if (!add_to_swap(folio)) {
+					int __maybe_unused order = folio_order(folio);
+
 					if (!folio_test_large(folio))
 						goto activate_locked_split;
 					/* Fallback to swap normal pages */
@@ -1225,6 +1227,7 @@ retry:
 							THP_SWPOUT_FALLBACK, 1);
 						count_vm_event(THP_SWPOUT_FALLBACK);
 					}
+					count_mthp_stat(order, MTHP_STAT_ANON_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch
mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

