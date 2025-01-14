Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4182323C6F6
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837013; cv=none; b=kIJ4Y2sgXTMvHxo02iW+AT0X0He1wbZm8mXIeEqlxjYrmT6HjAyJPoKwOsFJY/XCQjIYBx4C2qkYwSFlCyuPHMISgUSkSE6KRJ4v/VGgRq8rK7fdoR7ygednXMABXMBPn+uP8huwHRY+ui6Q32QIL4paM5W+w3ldRW/6UQ4QcvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837013; c=relaxed/simple;
	bh=L2TKEPg0rJKPAm+Z8iSU67sbxM7T6a5LPaB0zNJsx3w=;
	h=Date:To:From:Subject:Message-Id; b=E0t56/9M00oTZ/zcqs8X9EGS92U0gNy3GPwyJMhdfzL6CISe0zqTqzmtDigJzNbl+q2BffkW5fgVGuuR6Glof4J4V1KjZvr0ho9QcrjygbgljCtpz77vYojJhks+T4Ht0v1o3atwFoCOkaDYNpcgQgSvC/GejKuAqHfbaOuKplM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oenwwGpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oenwwGpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C72C4CEDD;
	Tue, 14 Jan 2025 06:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837013;
	bh=L2TKEPg0rJKPAm+Z8iSU67sbxM7T6a5LPaB0zNJsx3w=;
	h=Date:To:From:Subject:From;
	b=oenwwGpQ3oHVmWeakakpVSPW6o9gl29LbNPWHI8VekBkQj/znVNCibaoABbZOzpFh
	 uL3D/qK/1oWXQEixd73Kg5PwWxGibplVThHFS0AsxkWBxfQ+oXkyEFSHw7+EYBzE8Z
	 QvBLYOCy8sKd1WoxXAYMkORx4eItQvkbmaIIgXm0=
Date: Mon, 13 Jan 2025 22:43:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,usamaarif642@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,haowenchao22@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters.patch removed from -mm tree
Message-Id: <20250114064333.11C72C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add per-order mTHP swap-in fallback/fallback_charge counters
has been removed from the -mm tree.  Its filename was
     mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wenchao Hao <haowenchao22@gmail.com>
Subject: mm: add per-order mTHP swap-in fallback/fallback_charge counters
Date: Mon, 2 Dec 2024 20:47:30 +0800

Currently, large folio swap-in is supported, but we lack a method to
analyze their success ratio.  Similar to anon_fault_fallback, we introduce
per-order mTHP swpin_fallback and swpin_fallback_charge counters for
calculating their success ratio.  The new counters are located at:

/sys/kernel/mm/transparent_hugepage/hugepages-<size>/stats/
	swpin_fallback
	swpin_fallback_charge

Link: https://lkml.kernel.org/r/20241202124730.2407037-1-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   10 ++++++++++
 include/linux/huge_mm.h                    |    2 ++
 mm/huge_memory.c                           |    6 ++++++
 mm/memory.c                                |    2 ++
 4 files changed, 20 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -591,6 +591,16 @@ swpin
 	is incremented every time a huge page is swapped in from a non-zswap
 	swap device in one piece.
 
+swpin_fallback
+	is incremented if swapin fails to allocate or charge a huge page
+	and instead falls back to using huge pages with lower orders or
+	small pages.
+
+swpin_fallback_charge
+	is incremented if swapin fails to charge a huge page and instead
+	falls back to using  huge pages with lower orders or small pages
+	even though the allocation was successful.
+
 swpout
 	is incremented every time a huge page is swapped out to a non-zswap
 	swap device in one piece without splitting.
--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters
+++ a/include/linux/huge_mm.h
@@ -121,6 +121,8 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
 	MTHP_STAT_ZSWPOUT,
 	MTHP_STAT_SWPIN,
+	MTHP_STAT_SWPIN_FALLBACK,
+	MTHP_STAT_SWPIN_FALLBACK_CHARGE,
 	MTHP_STAT_SWPOUT,
 	MTHP_STAT_SWPOUT_FALLBACK,
 	MTHP_STAT_SHMEM_ALLOC,
--- a/mm/huge_memory.c~mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters
+++ a/mm/huge_memory.c
@@ -617,6 +617,8 @@ DEFINE_MTHP_STAT_ATTR(anon_fault_fallbac
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
+DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(swpin_fallback_charge, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
 #ifdef CONFIG_SHMEM
@@ -637,6 +639,8 @@ static struct attribute *anon_stats_attr
 #ifndef CONFIG_SHMEM
 	&zswpout_attr.attr,
 	&swpin_attr.attr,
+	&swpin_fallback_attr.attr,
+	&swpin_fallback_charge_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
@@ -669,6 +673,8 @@ static struct attribute *any_stats_attrs
 #ifdef CONFIG_SHMEM
 	&zswpout_attr.attr,
 	&swpin_attr.attr,
+	&swpin_fallback_attr.attr,
+	&swpin_fallback_charge_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
--- a/mm/memory.c~mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters
+++ a/mm/memory.c
@@ -4258,8 +4258,10 @@ static struct folio *alloc_swap_folio(st
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
 				return folio;
+			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
 			folio_put(folio);
 		}
+		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
 		order = next_order(&orders, order);
 	}
 
_

Patches currently in -mm which might be from haowenchao22@gmail.com are


