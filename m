Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B23D535
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 23:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717545167; cv=none; b=aOvXcL/iL+25W7am+EXthw+ntqAEIjGvQhe5qZvkbKMl5yWorjSw6OF7rnLBf5Xn+JxX2kT8rACwdKhrsiiX3F8jwYjNv0+e6eQ+7ToIfKtxL3SZ7DRF/L/Q2Hvq5CQR41sE3d28TkhTZsVmvO9gXHWgyVRn+waJC+Ig4s+f6+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717545167; c=relaxed/simple;
	bh=oOtD3AY1w+QzntvIXB48DLgxk2BwYdiYTtpBgt4gB0M=;
	h=Date:To:From:Subject:Message-Id; b=k9/+BF5ExzOpDwYZHxGs8KZ0sYpkGx7NpyzeEf/4KInxzhXXdnWmerlr6/cahjBgRYbv5MBw3PRXO7qeMYoRk5d+nBgqm47kJYP3utBMttTGL8z5bdkgnOojxBG5sIbHlvzK2CkwOwcaHyMXR9cLSYzgBGfkIFQkABNNbHuTU+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hkwKEFAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hkwKEFAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115F3C2BBFC;
	Tue,  4 Jun 2024 23:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717545167;
	bh=oOtD3AY1w+QzntvIXB48DLgxk2BwYdiYTtpBgt4gB0M=;
	h=Date:To:From:Subject:From;
	b=hkwKEFAFlubtxuNp87qjm+7mqT2J7Kpl0bVHCn9My2VDgGgEjYRaE6tRek+N4Z5qs
	 2cV4YoT0oPfaPiYySbf1WqlKhAuWU5PPKa8i/jHU5eyDFMc6owELmjEkNFJZoXBrwQ
	 9RfIWWeXaaY/fvZ/EY8ZSoEgPSSIUgTL7hl2tlls=
Date: Tue, 04 Jun 2024 16:52:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-mthp-counters-for-anonymous-shmem.patch added to mm-unstable branch
Message-Id: <20240604235247.115F3C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: add mTHP counters for anonymous shmem
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: add mTHP counters for anonymous shmem
Date: Tue, 4 Jun 2024 18:17:50 +0800

Add mTHP counters for anonymous shmem.

Link: https://lkml.kernel.org/r/f3c8f7a1c9fd17a48ffa22f7e7d236ac96caced6.1717495894.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 +++
 mm/huge_memory.c        |    6 ++++++
 mm/shmem.c              |   18 +++++++++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

--- a/include/linux/huge_mm.h~mm-shmem-add-mthp-counters-for-anonymous-shmem
+++ a/include/linux/huge_mm.h
@@ -281,6 +281,9 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
 	MTHP_STAT_SWPOUT,
 	MTHP_STAT_SWPOUT_FALLBACK,
+	MTHP_STAT_FILE_ALLOC,
+	MTHP_STAT_FILE_FALLBACK,
+	MTHP_STAT_FILE_FALLBACK_CHARGE,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-shmem-add-mthp-counters-for-anonymous-shmem
+++ a/mm/huge_memory.c
@@ -555,6 +555,9 @@ DEFINE_MTHP_STAT_ATTR(anon_fault_fallbac
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(file_alloc, MTHP_STAT_FILE_ALLOC);
+DEFINE_MTHP_STAT_ATTR(file_fallback, MTHP_STAT_FILE_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(file_fallback_charge, MTHP_STAT_FILE_FALLBACK_CHARGE);
 
 static struct attribute *stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -562,6 +565,9 @@ static struct attribute *stats_attrs[] =
 	&anon_fault_fallback_charge_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
+	&file_alloc_attr.attr,
+	&file_fallback_attr.attr,
+	&file_fallback_charge_attr.attr,
 	NULL,
 };
 
--- a/mm/shmem.c~mm-shmem-add-mthp-counters-for-anonymous-shmem
+++ a/mm/shmem.c
@@ -1773,6 +1773,9 @@ static struct folio *shmem_alloc_and_add
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			count_mthp_stat(order, MTHP_STAT_FILE_FALLBACK);
+#endif
 			order = next_order(&suitable_orders, order);
 		}
 	} else {
@@ -1792,9 +1795,15 @@ allocated:
 		if (xa_find(&mapping->i_pages, &index,
 				index + pages - 1, XA_PRESENT)) {
 			error = -EEXIST;
-		} else if (pages == HPAGE_PMD_NR) {
-			count_vm_event(THP_FILE_FALLBACK);
-			count_vm_event(THP_FILE_FALLBACK_CHARGE);
+		} else if (pages > 1) {
+			if (pages == HPAGE_PMD_NR) {
+				count_vm_event(THP_FILE_FALLBACK);
+				count_vm_event(THP_FILE_FALLBACK_CHARGE);
+			}
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_FALLBACK);
+			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_FALLBACK_CHARGE);
+#endif
 		}
 		goto unlock;
 	}
@@ -2168,6 +2177,9 @@ repeat:
 		if (!IS_ERR(folio)) {
 			if (folio_test_pmd_mappable(folio))
 				count_vm_event(THP_FILE_ALLOC);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_ALLOC);
+#endif
 			goto alloced;
 		}
 		if (PTR_ERR(folio) == -EEXIST)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch
mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

