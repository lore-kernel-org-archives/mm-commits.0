Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0673528DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489856; cv=none; b=rv9HUVwrQ7biZXLFybj16vcOtdN3HM4Zd4iwbT6kiXG8Pe6b2a+BevgthJ8leGZ03MaxcFkOD7TJtkrvGP3+v5ejW/5ZWyx810MmYI9RXu0QWeTkMg7Pth38TnxqU518ry1xemHdpVEL0nIRbFNt9ggwrBFuUn1GR9nXmfjx7vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489856; c=relaxed/simple;
	bh=5I5vwMjPG3g7LFc507Aj1V3tqBzimeelXmrCQz9nSWw=;
	h=Date:To:From:Subject:Message-Id; b=uPY2ShqZvv0FUd8IX4dj+ciYk0q13zVjWEVB7JZf6VnScGZ8ZKMsSARShlcxiPLHoW0GGbdYiIfSRhquqWmvTOhAb8c+3t56cV8lufp04UqaXjm67dNntZAdnaWMkG/cu04MZ7KM2OpHtU0khOrQdqiOL2rSF9OZ0LN37dbkb30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Npz6+VZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Npz6+VZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE918C4CEE7;
	Sun, 21 Sep 2025 21:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489855;
	bh=5I5vwMjPG3g7LFc507Aj1V3tqBzimeelXmrCQz9nSWw=;
	h=Date:To:From:Subject:From;
	b=Npz6+VZ+YkQxW3P57mnzWr/jZqkkAmOH3exd1b1k5G9VPMXIjgge6KYUfx/H7+mGr
	 6wx3a0BxaWMK8hZ57seOnvHnD6EPraKj1h+NiCfSoMNt6F4T8mK0cw698G1wojjqln
	 7+CtG0mn519XMPh26W41w3icf2hVf85ehTjziok0=
Date: Sun, 21 Sep 2025 14:24:15 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-retry-to-allocate-for-early-boot-hugepage-allocation.patch removed from -mm tree
Message-Id: <20250921212415.CE918C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: retry to allocate for early boot hugepage allocation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-retry-to-allocate-for-early-boot-hugepage-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li RongQing <lirongqing@baidu.com>
Subject: mm/hugetlb: retry to allocate for early boot hugepage allocation
Date: Mon, 1 Sep 2025 16:20:52 +0800

In cloud environments with massive hugepage reservations (95%+ of system
RAM), single-attempt allocation during early boot often fails due to
memory pressure.

Commit 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages")
intensified this by deferring page frees, increase peak memory usage
during allocation.

Introduce a retry mechanism that leverages vmemmap optimization reclaim
(~1.6% memory) when available.  Upon initial allocation failure, the
system retries until successful or no further progress is made, ensuring
reliable hugepage allocation while preserving batched vmemmap freeing
benefits.

Testing on a 256G machine allocating 252G of hugepages:
Before: 128056/129024 hugepages allocated
After:  Successfully allocated all 129024 hugepages

Link: https://lkml.kernel.org/r/20250901082052.3247-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-retry-to-allocate-for-early-boot-hugepage-allocation
+++ a/mm/hugetlb.c
@@ -3593,10 +3593,9 @@ static unsigned long __init hugetlb_page
 
 	unsigned long jiffies_start;
 	unsigned long jiffies_end;
+	unsigned long remaining;
 
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
-	job.start	= 0;
-	job.size	= h->max_huge_pages;
 
 	/*
 	 * job.max_threads is 25% of the available cpu threads by default.
@@ -3620,10 +3619,29 @@ static unsigned long __init hugetlb_page
 	}
 
 	job.max_threads	= hugepage_allocation_threads;
-	job.min_chunk	= h->max_huge_pages / hugepage_allocation_threads;
 
 	jiffies_start = jiffies;
-	padata_do_multithreaded(&job);
+	do {
+		remaining = h->max_huge_pages - h->nr_huge_pages;
+
+		job.start     = h->nr_huge_pages;
+		job.size      = remaining;
+		job.min_chunk = remaining / hugepage_allocation_threads;
+		padata_do_multithreaded(&job);
+
+		if (h->nr_huge_pages == h->max_huge_pages)
+			break;
+
+		/*
+		 * Retry only if the vmemmap optimization might have been able to free
+		 * some memory back to the system.
+		 */
+		if (!hugetlb_vmemmap_optimizable(h))
+			break;
+
+		/* Continue if progress was made in last iteration */
+	} while (remaining != (h->max_huge_pages - h->nr_huge_pages));
+
 	jiffies_end = jiffies;
 
 	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
_

Patches currently in -mm which might be from lirongqing@baidu.com are


