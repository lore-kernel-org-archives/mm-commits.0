Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A71A41
	for <mm-commits@vger.kernel.org>; Fri, 15 Aug 2025 00:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755218125; cv=none; b=tzTSzjJfSNs+90/VJ/tSLd7WXmTi4Zi/rT193XTE6xXuLDlb2QxJZrS4lVj4uMo7Omb3KX+I7n6oZPMXXOqmzt5jmFHaJYyLgWoDaHzrkBuMgMRy5FaeqkkjUMow2infxQbOSosCGjDcS6QXV3gb0/387TddnMj1P10QsATEslw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755218125; c=relaxed/simple;
	bh=fVqVU7yBN2KAPS6ZQAd4gBwGazyCI+eRd0FPh7OEsn0=;
	h=Date:To:From:Subject:Message-Id; b=EFm1NX/Bt4ggBK+9yHKSuAoVvq8rQG+NWIhuds5Myflow8u6bhc1M+4kO0sybc4m8MEk+nHvMDqpGL2+YQFF0EvQCy8d97r+oGCulGs5bslXUPpCTJFyvACS4c34LZsqF1sSzjNpyFkRgwNIPn5tq5Z6vdgZ5WzVO6ZXtGEIBS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRskF44d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRskF44d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293CFC4CEED;
	Fri, 15 Aug 2025 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755218125;
	bh=fVqVU7yBN2KAPS6ZQAd4gBwGazyCI+eRd0FPh7OEsn0=;
	h=Date:To:From:Subject:From;
	b=gRskF44dQufDr0IsUirTuVK1vfX1nbwgJ1VrkoButCgq4bOIfqFDnpdEGw2GEMBg6
	 QaF9oFTUPSwoH9wq0IQ7hMGjmab9K3CcxifHMW00tlyZmuNbGNJzTKF0FrbrUBBCdQ
	 N6jgSS+hnqJW3ABfSi4CqxkvP77L4tf8khYhYOn0=
Date: Thu, 14 Aug 2025 17:35:24 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-early-exit-from-hugetlb_pages_alloc_boot-when-max_huge_pages=0.patch added to mm-new branch
Message-Id: <20250815003525.293CFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-early-exit-from-hugetlb_pages_alloc_boot-when-max_huge_pages=0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-early-exit-from-hugetlb_pages_alloc_boot-when-max_huge_pages=0.patch

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
Subject: mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0
Date: Thu, 14 Aug 2025 18:23:33 +0800

Optimize hugetlb_pages_alloc_boot() to return immediately when
max_huge_pages is 0, avoiding unnecessary CPU cycles and the below log
message when hugepages aren't configured in the kernel command line.
[    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32

Link: https://lkml.kernel.org/r/20250814102333.4428-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-early-exit-from-hugetlb_pages_alloc_boot-when-max_huge_pages=0
+++ a/mm/hugetlb.c
@@ -3654,6 +3654,9 @@ static void __init hugetlb_hstate_alloc_
 		return;
 	}
 
+	if (!h->max_huge_pages)
+		return;
+
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;
_

Patches currently in -mm which might be from lirongqing@baidu.com are

mm-hugetlb-early-exit-from-hugetlb_pages_alloc_boot-when-max_huge_pages=0.patch

