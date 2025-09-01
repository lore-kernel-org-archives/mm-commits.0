Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD632356C6
	for <mm-commits@vger.kernel.org>; Mon,  1 Sep 2025 20:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756757388; cv=none; b=Ks9rGgpX+wliSlB9s4SSS+gi2yk96UzgXF1cWbfBQ8Q8Ib9fjM38o8U2l1bm3rff9NQRd8NfOJPjkNqIIlFjIRsH4arPua9SGirteAzMPgdUCMxoYv/Y8edZYksugXrqulEbLPwjdoxHjeX6XPfM1Sg7LwKl67NxvETKCE/xE7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756757388; c=relaxed/simple;
	bh=XD3hG92AV8+gNi991bUuJTSzZlQcK67c/I3HG1Yu+h8=;
	h=Date:To:From:Subject:Message-Id; b=SrhqmHan0QTds7pnSgn+pDB1Hs8LRkTAQuFECyX+mtiRxy552GulM6g0w24CfEkpsDpirfvUe3djXN4u+n9xw0s+Fss0Wlp0IzMlcnqTDAUmac83In30FDhMgrFNagZU/YC/ytlhkPTlxlVll/7uXu3VPVTJCzuA7zMp47tYvoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fZfpe45J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fZfpe45J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4ADC4CEF0;
	Mon,  1 Sep 2025 20:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756757388;
	bh=XD3hG92AV8+gNi991bUuJTSzZlQcK67c/I3HG1Yu+h8=;
	h=Date:To:From:Subject:From;
	b=fZfpe45JlUtMsj0YA2+z4mgqWcn6nptxDQGmswUzTDl0Kng12FAcOAxVojIS+zWWb
	 +lFHiFGGwmh+QWxzCVPtKYC4Mmck/CAFCoF3sn+86QGzyxlh5kKc0KZTEW9zNnl7dH
	 SuDErDo/pFxDZeWkUgfdU4rXch/J/cCLzmKOGeFc=
Date: Mon, 01 Sep 2025 13:09:47 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-retry-to-allocate-for-early-boot-hugepage-allocation.patch added to mm-new branch
Message-Id: <20250901200948.6D4ADC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: retry to allocate for early boot hugepage allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-retry-to-allocate-for-early-boot-hugepage-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-retry-to-allocate-for-early-boot-hugepage-allocation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-hugetlb-early-exit-from-hugetlb_pages_alloc_boot-when-max_huge_pages=0.patch
mm-hugetlb-retry-to-allocate-for-early-boot-hugepage-allocation.patch

