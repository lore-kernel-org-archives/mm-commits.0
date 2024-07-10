Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621BB34545
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633060; cv=none; b=P9xe4AOLDE3T0vi6sdWz8F0AOAoz1vuoezYqGzlMWE4RMmH8/+iCkhD+k8U5xJBQqGGTZsr2uw2COVwXxrySt3dDIpRKhIze2tEWwGbI2fTZkGkxJ7LKDIIboL5IDSM23mhsNRGbI7jHt7x7uMju5edRyC6WBHKeUs05Ee3WA74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633060; c=relaxed/simple;
	bh=Se254LfjtdjY+H0FLeJRCavVzBQbrY2SwnSW1JjHPzU=;
	h=Date:To:From:Subject:Message-Id; b=s0ASuviKEcKb24Q0cpHx0LyFUDOAGNnS6DvgO8ma3Rmuv84pULAqeFKYpY+3tMtA+fq2/VCHsM8RcPrrQ/H+RuoJgBPlM3TH7lP2d3iv2VXIDR+UzHvw5ggq3xqA3vVZjb+jdXiUx1c6pfsF1p9i0MLNqORMYdrMBrvXUEVPbso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R5nXYDPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R5nXYDPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4E9C32781;
	Wed, 10 Jul 2024 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720633059;
	bh=Se254LfjtdjY+H0FLeJRCavVzBQbrY2SwnSW1JjHPzU=;
	h=Date:To:From:Subject:From;
	b=R5nXYDPhH52fS/rxO2Nqx774q++l+twrbetW11vapv/FaxZxOfYx1/xtPFpIEE6Yj
	 DnWsOfZHQOXUG1WRqI3k3UzVPX/uSbkXb40JbwkAm9RQo9huE7Ts8/LqsJh05DfwGS
	 LNUrEozNh1Yp2Xxtzt7IC1qLQE72A1UCGkOmJKN4=
Date: Wed, 10 Jul 2024 10:37:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-rename-mthp-shmem-counters.patch added to mm-unstable branch
Message-Id: <20240710173739.BE4E9C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: rename mTHP shmem counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-rename-mthp-shmem-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-rename-mthp-shmem-counters.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: shmem: rename mTHP shmem counters
Date: Wed, 10 Jul 2024 10:55:01 +0100

The legacy PMD-sized THP counters at /proc/vmstat include thp_file_alloc,
thp_file_fallback and thp_file_fallback_charge, which rather confusingly
refer to shmem THP and do not include any other types of file pages.  This
is inconsistent since in most other places in the kernel, THP counters are
explicitly separated for anon, shmem and file flavours.  However, we are
stuck with it since it constitutes a user ABI.

Recently, commit 66f44583f9b6 ("mm: shmem: add mTHP counters for anonymous
shmem") added equivalent mTHP stats for shmem, keeping the same "file_"
prefix in the names.  But in future, we may want to add extra stats to
cover actual file pages, at which point, it would all become very
confusing.

So let's take the opportunity to rename these new counters "shmem_" before
the change makes it upstream and the ABI becomes immutable.  While we are
at it, let's improve the documentation for the legacy counters to make it
clear that they count shmem pages only.

Link: https://lkml.kernel.org/r/20240710095503.3193901-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   29 ++++++++++---------
 include/linux/huge_mm.h                    |    6 +--
 mm/huge_memory.c                           |   12 +++----
 mm/shmem.c                                 |    8 ++---
 4 files changed, 29 insertions(+), 26 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-rename-mthp-shmem-counters
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -412,20 +412,23 @@ thp_collapse_alloc_failed
 	the allocation.
 
 thp_file_alloc
-	is incremented every time a file huge page is successfully
-	allocated.
+	is incremented every time a shmem huge page is successfully
+	allocated (Note that despite being named after "file", the counter
+	measures only shmem).
 
 thp_file_fallback
-	is incremented if a file huge page is attempted to be allocated
-	but fails and instead falls back to using small pages.
+	is incremented if a shmem huge page is attempted to be allocated
+	but fails and instead falls back to using small pages. (Note that
+	despite being named after "file", the counter measures only shmem).
 
 thp_file_fallback_charge
-	is incremented if a file huge page cannot be charged and instead
+	is incremented if a shmem huge page cannot be charged and instead
 	falls back to using small pages even though the allocation was
-	successful.
+	successful. (Note that despite being named after "file", the
+	counter measures only shmem).
 
 thp_file_mapped
-	is incremented every time a file huge page is mapped into
+	is incremented every time a file or shmem huge page is mapped into
 	user address space.
 
 thp_split_page
@@ -496,16 +499,16 @@ swpout_fallback
 	Usually because failed to allocate some continuous swap space
 	for the huge page.
 
-file_alloc
-	is incremented every time a file huge page is successfully
+shmem_alloc
+	is incremented every time a shmem huge page is successfully
 	allocated.
 
-file_fallback
-	is incremented if a file huge page is attempted to be allocated
+shmem_fallback
+	is incremented if a shmem huge page is attempted to be allocated
 	but fails and instead falls back to using small pages.
 
-file_fallback_charge
-	is incremented if a file huge page cannot be charged and instead
+shmem_fallback_charge
+	is incremented if a shmem huge page cannot be charged and instead
 	falls back to using small pages even though the allocation was
 	successful.
 
--- a/include/linux/huge_mm.h~mm-shmem-rename-mthp-shmem-counters
+++ a/include/linux/huge_mm.h
@@ -269,9 +269,9 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
 	MTHP_STAT_SWPOUT,
 	MTHP_STAT_SWPOUT_FALLBACK,
-	MTHP_STAT_FILE_ALLOC,
-	MTHP_STAT_FILE_FALLBACK,
-	MTHP_STAT_FILE_FALLBACK_CHARGE,
+	MTHP_STAT_SHMEM_ALLOC,
+	MTHP_STAT_SHMEM_FALLBACK,
+	MTHP_STAT_SHMEM_FALLBACK_CHARGE,
 	MTHP_STAT_SPLIT,
 	MTHP_STAT_SPLIT_FAILED,
 	MTHP_STAT_SPLIT_DEFERRED,
--- a/mm/huge_memory.c~mm-shmem-rename-mthp-shmem-counters
+++ a/mm/huge_memory.c
@@ -568,9 +568,9 @@ DEFINE_MTHP_STAT_ATTR(anon_fault_fallbac
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
-DEFINE_MTHP_STAT_ATTR(file_alloc, MTHP_STAT_FILE_ALLOC);
-DEFINE_MTHP_STAT_ATTR(file_fallback, MTHP_STAT_FILE_FALLBACK);
-DEFINE_MTHP_STAT_ATTR(file_fallback_charge, MTHP_STAT_FILE_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(shmem_alloc, MTHP_STAT_SHMEM_ALLOC);
+DEFINE_MTHP_STAT_ATTR(shmem_fallback, MTHP_STAT_SHMEM_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(shmem_fallback_charge, MTHP_STAT_SHMEM_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(split, MTHP_STAT_SPLIT);
 DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
@@ -581,9 +581,9 @@ static struct attribute *stats_attrs[] =
 	&anon_fault_fallback_charge_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
-	&file_alloc_attr.attr,
-	&file_fallback_attr.attr,
-	&file_fallback_charge_attr.attr,
+	&shmem_alloc_attr.attr,
+	&shmem_fallback_attr.attr,
+	&shmem_fallback_charge_attr.attr,
 	&split_attr.attr,
 	&split_failed_attr.attr,
 	&split_deferred_attr.attr,
--- a/mm/shmem.c~mm-shmem-rename-mthp-shmem-counters
+++ a/mm/shmem.c
@@ -1777,7 +1777,7 @@ static struct folio *shmem_alloc_and_add
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			count_mthp_stat(order, MTHP_STAT_FILE_FALLBACK);
+			count_mthp_stat(order, MTHP_STAT_SHMEM_FALLBACK);
 #endif
 			order = next_order(&suitable_orders, order);
 		}
@@ -1804,8 +1804,8 @@ allocated:
 				count_vm_event(THP_FILE_FALLBACK_CHARGE);
 			}
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_FALLBACK);
-			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_FALLBACK_CHARGE);
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SHMEM_FALLBACK);
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SHMEM_FALLBACK_CHARGE);
 #endif
 		}
 		goto unlock;
@@ -2181,7 +2181,7 @@ repeat:
 			if (folio_test_pmd_mappable(folio))
 				count_vm_event(THP_FILE_ALLOC);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_ALLOC);
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SHMEM_ALLOC);
 #endif
 			goto alloced;
 		}
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-fix-khugepaged-activation-policy.patch
mm-fix-khugepaged-activation-policy-v3.patch
mm-shmem-rename-mthp-shmem-counters.patch

