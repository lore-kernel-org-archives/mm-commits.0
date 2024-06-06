Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269EC440C
	for <mm-commits@vger.kernel.org>; Thu,  6 Jun 2024 02:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640405; cv=none; b=OZZgA1cc/NfQB8xrTXT6IcYhi637e9lF6Of9XDYNnQ34KtIYqfSA4NoIQyXgCBgMo6+1ABJ+EXVASAsWjnrGAQ6Rz0uOX6ZcAiAcD67p1Bt7uNVNzMVlnKwEi9oUw1xA4UFPwab/R8spqhP+aBK/0C71vERW1LSHgh0hlhCpw14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640405; c=relaxed/simple;
	bh=fxZSTTnlSFhtjmhScO+LcFW9RM0dWW/WlkbIOovb0h4=;
	h=Date:To:From:Subject:Message-Id; b=eELrieHYalfIJUqONedHqxZTJCIJZ2UwNyvB0lC/FIvnsXFUkikfh2u+kRXuUaJW+yP+1tvjW09YeNgDjn26sq9mk0OqX0o9aJ1GtAMVw5ES4RW36VVbJEmXi63qkQkZ4fDNOvWr4l5awRBndZ0Cv8w8n4g/3j4eqHY4Eep8yYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/4ZnPgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/4ZnPgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4C5C3277B;
	Thu,  6 Jun 2024 02:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640404;
	bh=fxZSTTnlSFhtjmhScO+LcFW9RM0dWW/WlkbIOovb0h4=;
	h=Date:To:From:Subject:From;
	b=A/4ZnPgyHmog0POI5nCAzcKy92fQI04Ov4mM3PfT/M/5R7FakS49l0olMjtyG9HdL
	 wCnTVmZHov8YJ1Nptl4SaQdMAYQ9JFZU6X7wU2YjFjNVzG6FD+T9dKd4K6iZ51HjQa
	 BTQ3h1xu6h8RQTMJlFjPXiHMgswUHqcFfZB/7ZTk=
Date: Wed, 05 Jun 2024 19:20:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch removed from -mm tree
Message-Id: <20240606022004.7A4C5C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
has been removed from the -mm tree.  Its filename was
     mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
Date: Thu, 23 May 2024 10:36:39 +0800

The mTHP swap related counters: 'anon_swpout' and 'anon_swpout_fallback'
are confusing with an 'anon_' prefix, since the shmem can swap out
non-anonymous pages.  So drop the 'anon_' prefix to keep consistent with
the old swap counter names.

This is needed in 6.10-rcX to avoid having an inconsistent ABI out in the
field.

Link: https://lkml.kernel.org/r/7a8989c13299920d7589007a30065c3e2c19f0e0.1716431702.git.baolin.wang@linux.alibaba.com
Fixes: d0f048ac39f6 ("mm: add per-order mTHP anon_swpout and anon_swpout_fallback counters")
Fixes: 42248b9d34ea ("mm: add docs for per-order mTHP counters and transhuge_page ABI")
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
@@ -1227,7 +1227,7 @@ retry:
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

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

