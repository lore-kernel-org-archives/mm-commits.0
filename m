Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3C82119
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 04:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733373448; cv=none; b=EI+UWGdkwwrHZbaEkKEWsEaJ3Q8EhLYVX3tEt4NRj6cm97BMSduD7wrWBC5NJUQ484ycebyVPrksxr7EO8Ei6jH3zjZcZgw0qnpK6cV9rMHDbKnNoRj9k9D9ggExzVUZZ2CgEDv6PKw4CzbphLYcZpFzh27PvlcpOcuEDV/G5UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733373448; c=relaxed/simple;
	bh=uRZlYAcsy7NbJ+Tb6tuej9RbYrNcRWUZeTOFvMO9vOw=;
	h=Date:To:From:Subject:Message-Id; b=mHZd+ZOIVddFB8tGpILyPKbV+YPzsaF/vht9LaoLq7KGHkZKobqhB6Kpiz7nB9qO7ZP7N6u9kM9VVr3N4vA0T9lpphZZuHz9p/WIfG5OqBPsU2/K3Q5n335W46/Uy+QYwNMtf4V4D7e5gj8VdrR3UsiMN7jIN4Nvd2kTFirM4Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AUHpXjEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AUHpXjEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17310C4CED6;
	Thu,  5 Dec 2024 04:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733373448;
	bh=uRZlYAcsy7NbJ+Tb6tuej9RbYrNcRWUZeTOFvMO9vOw=;
	h=Date:To:From:Subject:From;
	b=AUHpXjEYEyrYdrbmyuSjxLW7mrsVPl9BPCtKcRLVoAXdlcdPu85huKW95pdNuQE9o
	 lXtgZThEj8uLqFaX0vEgFHWjNqRH8GkV7Pkw4UIoMNC+FY4wAam4NBBNHeVjSRi7Am
	 ZK0R/UMAhqaxtArX0f2vfjtobREjYlcgbuigNkT0=
Date: Wed, 04 Dec 2024 20:37:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,usamaarif642@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,haowenchao22@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters.patch added to mm-unstable branch
Message-Id: <20241205043728.17310C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add per-order mTHP swap-in fallback/fallback_charge counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters.patch

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
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

mm-add-per-order-mthp-swap-in-fallback-fallback_charge-counters.patch

