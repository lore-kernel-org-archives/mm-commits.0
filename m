Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DB1273FE
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741063942; cv=none; b=A/zgbgaUF5jPiKvXyQ6lJEG7zL8CWXPgdWMdaYGg6JWtSqVhCt0Y/mrzoj4MWDqg0Ud0rNsPpEXU+ZruXLTh3UDZPB1XixJbI0iWLKXk3k5zynXUBKjM6fHU6LVo53x+uzv3YfpI21b8TdytzRFA2QXqoKDa5oBYeoy8ZJNX5MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741063942; c=relaxed/simple;
	bh=5KSRLnH8mtnjS85td22CFLtJrPlN3k3N3SvkvRdVcrU=;
	h=Date:To:From:Subject:Message-Id; b=mwHfpST344b/3bi5vRbgOd1HXp8zGkkeyCQrlf+Eet6X+skQzTp8jjLxPhTBQi5rZXmcyf/aFpCO1/HZqm4XCoyhqDT2IbD/xmCylkOm8RG4BEBeM2JRTbgzWrPFTUOsWdRg7Ybj37kq9V7115Y0/bBIsFyKUglkq68HIHgyXG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NqLP1OCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NqLP1OCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BA6C4CEE5;
	Tue,  4 Mar 2025 04:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741063941;
	bh=5KSRLnH8mtnjS85td22CFLtJrPlN3k3N3SvkvRdVcrU=;
	h=Date:To:From:Subject:From;
	b=NqLP1OCb2uZ+igk0I6ZJ1rfL9zUxZhCX1qoOXlT6xwHn9XduP0aKf0OWcHuxhVME+
	 GSsm2BErGAt5Dy6G82ePHyhwThRK7fFON97upT8vvA2MLdBzh3WjrtPE9TwlDArOPc
	 Xpa8GWfa+yJ4wlJx/beCRMidvq95k8ynDE1yvX6Q=
Date: Mon, 03 Mar 2025 20:52:20 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,corbet@lwn.net,thomas.prescher@cyberus-technology.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-log-time-needed-to-allocate-hugepages.patch added to mm-unstable branch
Message-Id: <20250304045221.99BA6C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: log time needed to allocate hugepages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-log-time-needed-to-allocate-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-log-time-needed-to-allocate-hugepages.patch

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
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Subject: mm: hugetlb: log time needed to allocate hugepages
Date: Thu, 27 Feb 2025 23:45:07 +0100

Having this information allows users to easily tune the
hugepages_node_threads parameter.

Link: https://lkml.kernel.org/r/20250227-hugepage-parameter-v2-3-7db8c6dc0453@cyberus-technology.de
Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-log-time-needed-to-allocate-hugepages
+++ a/mm/hugetlb.c
@@ -3603,6 +3603,9 @@ static unsigned long __init hugetlb_page
 		.numa_aware	= true
 	};
 
+	unsigned long jiffies_start;
+	unsigned long jiffies_end;
+
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
 	job.start	= 0;
 	job.size	= h->max_huge_pages;
@@ -3630,7 +3633,14 @@ static unsigned long __init hugetlb_page
 
 	job.max_threads	= hugepage_allocation_threads;
 	job.min_chunk	= h->max_huge_pages / hugepage_allocation_threads;
+
+	jiffies_start = jiffies;
 	padata_do_multithreaded(&job);
+	jiffies_end = jiffies;
+
+	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
+		jiffies_to_msecs(jiffies_end - jiffies_start),
+		hugepage_allocation_threads);
 
 	return h->nr_huge_pages;
 }
_

Patches currently in -mm which might be from thomas.prescher@cyberus-technology.de are

mm-hugetlb-improve-parallel-huge-page-allocation-time.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch
mm-hugetlb-log-time-needed-to-allocate-hugepages.patch

