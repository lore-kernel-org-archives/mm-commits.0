Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3824928F5
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716493222; cv=none; b=AYQs2qXz5nNivun8RXd4dsZhqt53ohCMocEg843jDs73FfNvc5jP+MVPzXBo3mmSZcGpOzPisO/a+snV2rTkpLl9H5RzRP2SkE/CXeYdxfmGjz6wmnh/g4bfN55vydaTm3q96J99PalOgyDn3N4/DmYHZxV6aNO+5fLYSO4Rark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716493222; c=relaxed/simple;
	bh=nCVCq3KMt1p+++3fOEqP5QzqM00+hk4nRjWrOFKickQ=;
	h=Date:To:From:Subject:Message-Id; b=Z4eBSjd2f8p9IU29hzSWR/jIR7dCXfvVd9b8ZNVjw01GVo3bkCxNQHLmrPGcv+fmHLicTz+7E/9aL8dv3UkxCWFyNPDHEJGBvGqSEzGC/dTaJTOI6TWjXTTUAzUp4DYe3aQWpvb23rG8/kHCOzrw5xVVDXflF9lmnnslcFk7V8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZFbLGN//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZFbLGN//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF145C2BD10;
	Thu, 23 May 2024 19:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716493221;
	bh=nCVCq3KMt1p+++3fOEqP5QzqM00+hk4nRjWrOFKickQ=;
	h=Date:To:From:Subject:From;
	b=ZFbLGN//sWuaMLVBR4HVs6d7GIzYNBJ+pFkeT3O9/Wh511Qa51+lIaLXm3Yk34qJp
	 aOlyEjbYgI80t96xq/CnpufqhmeIJXqQqW0vHIcqY3BhcCiE6vpN82hr2bc/65W1YJ
	 iqB8JqvMY2TdgOCcN3Id0tddu2ETGRHLW4DqZ9ho=
Date: Thu, 23 May 2024 12:40:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch added to mm-unstable branch
Message-Id: <20240523194021.CF145C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
Date: Thu, 23 May 2024 10:36:39 +0800

The mTHP swap related counters: 'anon_swpout' and 'anon_swpout_fallback'
are confusing with an 'anon_' prefix, since the shmem can swap out
non-anonymous pages.  So drop the 'anon_' prefix to keep consistent with
the old swap counter names.

Link: https://lkml.kernel.org/r/7a8989c13299920d7589007a30065c3e2c19f0e0.1716431702.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    4 ++--
 include/linux/huge_mm.h                    |    4 ++--
 mm/huge_memory.c                           |    8 ++++----
 mm/page_io.c                               |    2 +-
 mm/vmscan.c                                |    2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-drop-the-anon_-prefix-for-swap-out-mthp-counters
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -467,11 +467,11 @@ anon_fault_fallback_charge
 	instead falls back to using huge pages with lower orders or
 	small pages even though the allocation was successful.
 
-anon_swpout
+swpout
 	is incremented every time a huge page is swapped out in one
 	piece without splitting.
 
-anon_swpout_fallback
+swpout_fallback
 	is incremented if a huge page has to be split before swapout.
 	Usually because failed to allocate some continuous swap space
 	for the huge page.
--- a/include/linux/huge_mm.h~mm-drop-the-anon_-prefix-for-swap-out-mthp-counters
+++ a/include/linux/huge_mm.h
@@ -269,8 +269,8 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_ALLOC,
 	MTHP_STAT_ANON_FAULT_FALLBACK,
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
-	MTHP_STAT_ANON_SWPOUT,
-	MTHP_STAT_ANON_SWPOUT_FALLBACK,
+	MTHP_STAT_SWPOUT,
+	MTHP_STAT_SWPOUT_FALLBACK,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-drop-the-anon_-prefix-for-swap-out-mthp-counters
+++ a/mm/huge_memory.c
@@ -558,15 +558,15 @@ static struct kobj_attribute _name##_att
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-DEFINE_MTHP_STAT_ATTR(anon_swpout, MTHP_STAT_ANON_SWPOUT);
-DEFINE_MTHP_STAT_ATTR(anon_swpout_fallback, MTHP_STAT_ANON_SWPOUT_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
+DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
 
 static struct attribute *stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
 	&anon_fault_fallback_attr.attr,
 	&anon_fault_fallback_charge_attr.attr,
-	&anon_swpout_attr.attr,
-	&anon_swpout_fallback_attr.attr,
+	&swpout_attr.attr,
+	&swpout_fallback_attr.attr,
 	NULL,
 };
 
--- a/mm/page_io.c~mm-drop-the-anon_-prefix-for-swap-out-mthp-counters
+++ a/mm/page_io.c
@@ -217,7 +217,7 @@ static inline void count_swpout_vm_event
 		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
 	}
-	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_SWPOUT);
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
--- a/mm/vmscan.c~mm-drop-the-anon_-prefix-for-swap-out-mthp-counters
+++ a/mm/vmscan.c
@@ -1230,7 +1230,7 @@ retry:
 							THP_SWPOUT_FALLBACK, 1);
 						count_vm_event(THP_SWPOUT_FALLBACK);
 					}
-					count_mthp_stat(order, MTHP_STAT_ANON_SWPOUT_FALLBACK);
+					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch

