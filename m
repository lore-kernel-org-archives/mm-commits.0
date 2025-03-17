Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3142B8634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188531; cv=none; b=B/5XO0UeYD2+X3OSZBeyK1jaiLuHhAeYega1kD80Y0KbKuE463KQgNE0ZOSaqmdZMAcCOGHD2mylAuTXGnbkSCjWx4wAprKwxOWLAMuhTn4Y5RelepRBDhU7F1aUHAtfJo782rNKLWP5z4DPpgXWtrmkiXhI42NaUpSjMeOMAno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188531; c=relaxed/simple;
	bh=8tq9aXAA0JIeKELkUmL1SqQfMsEoSHElbZIgMKknhYU=;
	h=Date:To:From:Subject:Message-Id; b=ERaUOtC07hJBQTe5EI5ImUuDCJFtL8f98cJqnAhG0ibGQDX73POqISxpHZn+blWA/fBqCKVoKRapSHqoNdms2BjEtS5w5DPXZOVnctwQNLEo3A4qR+jcOxJ4Fjc9nZbfsHGKxEl+yz/sRYZXGcZlweXl/YBf2s280NZjyp8Gpug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IhIRFgM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IhIRFgM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FA9C4CEEC;
	Mon, 17 Mar 2025 05:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188531;
	bh=8tq9aXAA0JIeKELkUmL1SqQfMsEoSHElbZIgMKknhYU=;
	h=Date:To:From:Subject:From;
	b=IhIRFgM/AScu7QF1muDh6wfOZ+HM2/ddZvSVV54DB5oQsPqAWa3Zxhf8AAc6M20kv
	 wjiuCUJfqceeKgbaXq9E+1txbpm66orXFs9B20oaV3loLnNKVRz99v72V/KZYbFTK+
	 f9Zs+o95yoEF8WEDZ1duiAjA/MG2jXlsAYqwGWhc=
Date: Sun, 16 Mar 2025 22:15:30 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,corbet@lwn.net,thomas.prescher@cyberus-technology.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-log-time-needed-to-allocate-hugepages.patch removed from -mm tree
Message-Id: <20250317051531.07FA9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: log time needed to allocate hugepages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-log-time-needed-to-allocate-hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3608,6 +3608,9 @@ static unsigned long __init hugetlb_page
 		.numa_aware	= true
 	};
 
+	unsigned long jiffies_start;
+	unsigned long jiffies_end;
+
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
 	job.start	= 0;
 	job.size	= h->max_huge_pages;
@@ -3635,7 +3638,14 @@ static unsigned long __init hugetlb_page
 
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


