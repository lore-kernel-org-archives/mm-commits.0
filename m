Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BA438F83
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736817375; cv=none; b=Phxz7LpHO8Mf/sXAaj92XJC8yKDPFI/Gx5468Hy5qhteQz8K51Y391SbTjQIAjomkBAtJCBdpdqPucXFE6AURbZ90dWL33xaSRmrvQxszAjBBTq3xFR/NPaq0rZUczTWvu6Zi9mXuiFg0mF+U4QDr65jVMNVbSG2U9+dmvEBMd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736817375; c=relaxed/simple;
	bh=m/AxOJciZQ6T6n9pHxvxtJgyc3MQBFw5UJwTB/wcS24=;
	h=Date:To:From:Subject:Message-Id; b=ryvyakJlVYdMQvDz1xiZm/RccU4TQmhPpHqDrBm2DhmpX8E/V6IszS4831lmrv5OzpXcdoKaJdGYbdL8lJ6eFdXZfgELkCLvgefp0L/kJfeHQnFkPBzpmlxxktSW3qW4O4YpxE65CivRNKznCxdnjC113jIKz7abbvOuIeW3T7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WDcCYCze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WDcCYCze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0741C4CED6;
	Tue, 14 Jan 2025 01:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736817375;
	bh=m/AxOJciZQ6T6n9pHxvxtJgyc3MQBFw5UJwTB/wcS24=;
	h=Date:To:From:Subject:From;
	b=WDcCYCzezqJ4qciwyz0tcJLYqaXy9H1weZGFSI/3K0E5mXQiB41P7m3Mw7xxy/pQg
	 Px2nWXEZgHJMYbVq0+7Y1m7YDJSAEmWDq+QpZnpGoVKr/TQ69gbGh8GVsR9TrccBzn
	 SQRUPoqRX1T8tJvuG0UQUZ/4p8pi8WEZGf5VsYoQ=
Date: Mon, 13 Jan 2025 17:16:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch added to mm-unstable branch
Message-Id: <20250114011614.F0741C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()
Date: Mon, 13 Jan 2025 14:16:11 +0100

We are demoting hugetlb folios to smaller hugetlb folios; let's avoid
messing with pages where avoidable and handle it more similar to
__split_huge_page_tail().

Link: https://lkml.kernel.org/r/20250113131611.2554758-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios
+++ a/mm/hugetlb.c
@@ -3826,13 +3826,15 @@ static long demote_free_hugetlb_folios(s
 
 		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
 			struct page *page = folio_page(folio, i);
+			/* Careful: see __split_huge_page_tail() */
+			struct folio *new_folio = (struct folio *)page;
 
-			page->mapping = NULL;
 			clear_compound_head(page);
 			prep_compound_page(page, dst->order);
 
-			init_new_hugetlb_folio(dst, page_folio(page));
-			list_add(&page->lru, &dst_list);
+			new_folio->mapping = NULL;
+			init_new_hugetlb_folio(dst, new_folio);
+			list_add(&new_folio->lru, &dst_list);
 		}
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are

docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch
mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

