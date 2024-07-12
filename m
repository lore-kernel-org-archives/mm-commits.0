Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F08A12EBF5;
	Fri, 12 Jul 2024 22:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824906; cv=none; b=oYhKwlGZZmkfUfAHWF7qOQ8qaVKk84urLaS9sy2Sozu5erLL8AEIWlqUFrwtXII0m2T7aOQAd+xgWrPsdDVi4m4wunGLuQiGlwBj9tvPyrkH07Uv+Rdo0ceeBqE4BMjQZGjQFUpKlyJol0jkzutQ/zDeYFUjYhvWIqp59YIuquo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824906; c=relaxed/simple;
	bh=ddnqm1fNdbisfqkstyc54ARb4yvftvzyKMc2ty0dgvA=;
	h=Date:To:From:Subject:Message-Id; b=N1aAvcUkp/n7qcGPCI2OYXW2dMYsV7TsBAUKV3y1/bM3dkyKMwfUY/A0HeF7u8rDlqA28ePa/gfB/8fKEGI9lDspX/7KCC79BQRmQjs6uAXAfEnXnt+TNHT6xhahsxcRCcr08bLIw8NiJdkR9/X9GE3p9CpRjx8Sg3a0HYaIv+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0IVN/GEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0IVN/GEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C2CC32782;
	Fri, 12 Jul 2024 22:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824905;
	bh=ddnqm1fNdbisfqkstyc54ARb4yvftvzyKMc2ty0dgvA=;
	h=Date:To:From:Subject:From;
	b=0IVN/GEQx8HbYH9ayAgqzaxxmKd0XwaLlHAxifyfwGepqYL8qod/AoKOxyhEUG4cc
	 CUFjfltEsdnXlfufDArJI7pz0yPGE3bks397/mCdk9YjRwq7zGSYt4eTtfLojht7W1
	 3wCdRoZVgeObaBQIw/z9h5SAHXexytWiVdtBB0/0=
Date: Fri, 12 Jul 2024 15:55:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-rename-mthp-shmem-counters.patch removed from -mm tree
Message-Id: <20240712225505.D7C2CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: rename mTHP shmem counters
has been removed from the -mm tree.  Its filename was
     mm-shmem-rename-mthp-shmem-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
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


