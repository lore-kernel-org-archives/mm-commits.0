Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A962ED535
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717545165; cv=none; b=FKDla5MGPLfBqSWK2wys/mqSuIW3WHobbnArf3j+Ewk/GenST+ChM7B/JF0liSS0U2zRkwWUTXGuciRgBHqDsP2ju+9XdeDYta9seTfLNlh0AgglBPs1SSaw909ktUFIN8njc8o4YXHm0S/BLjiMDKBze1iECW7VG8uy6yvxVWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717545165; c=relaxed/simple;
	bh=EQWwrPjTiczg6jldnHDnzXTCQYUhVStH8np1tUtJA4I=;
	h=Date:To:From:Subject:Message-Id; b=AeKWQRkDcxUr+rnisSuuiihUNIUXlWkE0bFGytdlytGWyVWYSUmKUSizgJZIiWwmLinCXdz6ba3yuEjb34KfBLLU6JXz4bc2XXDuyh6f7L8+tE0HyjDoZi1kES7QeB6O2u7QBeE7+HwLSevYWIm3a0FtfEdsr059YtUTiQkuNXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ae+qT44Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ae+qT44Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D091C2BBFC;
	Tue,  4 Jun 2024 23:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717545165;
	bh=EQWwrPjTiczg6jldnHDnzXTCQYUhVStH8np1tUtJA4I=;
	h=Date:To:From:Subject:From;
	b=Ae+qT44QYExsc2rn5fhsPPEjQhIkd9orpty1hMQ4cRvaQVE675RdXTOLfKh9vpFdr
	 z6j3AjknzH1jgCAxA61bxiGc35UrrJFbGrPd/qczLx1v/+K2hBmCPu0v8VMdRbn9qp
	 T0mT2kuGmKQZVirFx+SmJfu7pmInWGohQo5pb4ew=
Date: Tue, 04 Jun 2024 16:52:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch added to mm-unstable branch
Message-Id: <20240604235245.1D091C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: add mTHP size alignment in shmem_get_unmapped_area
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch

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
Subject: mm: shmem: add mTHP size alignment in shmem_get_unmapped_area
Date: Tue, 4 Jun 2024 18:17:49 +0800

Although the top-level hugepage allocation can be turned off, anonymous
shmem can still use mTHP by configuring the sysfs interface located at
'/sys/kernel/mm/transparent_hugepage/hugepage-XXkb/shmem_enabled'. 
Therefore, add alignment for mTHP size to provide a suitable alignment
address in shmem_get_unmapped_area().

Link: https://lkml.kernel.org/r/1d2f719d558d5c789c4cceebdaac42a814e8f107.1717495894.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Lance Yang <ioworker0@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area
+++ a/mm/shmem.c
@@ -2394,6 +2394,7 @@ unsigned long shmem_get_unmapped_area(st
 	unsigned long inflated_len;
 	unsigned long inflated_addr;
 	unsigned long inflated_offset;
+	unsigned long hpage_size;
 
 	if (len > TASK_SIZE)
 		return -ENOMEM;
@@ -2412,8 +2413,6 @@ unsigned long shmem_get_unmapped_area(st
 
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return addr;
-	if (len < HPAGE_PMD_SIZE)
-		return addr;
 	if (flags & MAP_FIXED)
 		return addr;
 	/*
@@ -2425,8 +2424,11 @@ unsigned long shmem_get_unmapped_area(st
 	if (uaddr == addr)
 		return addr;
 
+	hpage_size = HPAGE_PMD_SIZE;
 	if (shmem_huge != SHMEM_HUGE_FORCE) {
 		struct super_block *sb;
+		unsigned long __maybe_unused hpage_orders;
+		int order = 0;
 
 		if (file) {
 			VM_BUG_ON(file->f_op != &shmem_file_operations);
@@ -2439,18 +2441,38 @@ unsigned long shmem_get_unmapped_area(st
 			if (IS_ERR(shm_mnt))
 				return addr;
 			sb = shm_mnt->mnt_sb;
+
+			/*
+			 * Find the highest mTHP order used for anonymous shmem to
+			 * provide a suitable alignment address.
+			 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			hpage_orders = READ_ONCE(huge_anon_shmem_orders_always);
+			hpage_orders |= READ_ONCE(huge_anon_shmem_orders_within_size);
+			hpage_orders |= READ_ONCE(huge_anon_shmem_orders_madvise);
+			if (SHMEM_SB(sb)->huge != SHMEM_HUGE_NEVER)
+				hpage_orders |= READ_ONCE(huge_anon_shmem_orders_inherit);
+
+			if (hpage_orders > 0) {
+				order = highest_order(hpage_orders);
+				hpage_size = PAGE_SIZE << order;
+			}
+#endif
 		}
-		if (SHMEM_SB(sb)->huge == SHMEM_HUGE_NEVER)
+		if (SHMEM_SB(sb)->huge == SHMEM_HUGE_NEVER && !order)
 			return addr;
 	}
 
-	offset = (pgoff << PAGE_SHIFT) & (HPAGE_PMD_SIZE-1);
-	if (offset && offset + len < 2 * HPAGE_PMD_SIZE)
+	if (len < hpage_size)
+		return addr;
+
+	offset = (pgoff << PAGE_SHIFT) & (hpage_size - 1);
+	if (offset && offset + len < 2 * hpage_size)
 		return addr;
-	if ((addr & (HPAGE_PMD_SIZE-1)) == offset)
+	if ((addr & (hpage_size - 1)) == offset)
 		return addr;
 
-	inflated_len = len + HPAGE_PMD_SIZE - PAGE_SIZE;
+	inflated_len = len + hpage_size - PAGE_SIZE;
 	if (inflated_len > TASK_SIZE)
 		return addr;
 	if (inflated_len < len)
@@ -2463,10 +2485,10 @@ unsigned long shmem_get_unmapped_area(st
 	if (inflated_addr & ~PAGE_MASK)
 		return addr;
 
-	inflated_offset = inflated_addr & (HPAGE_PMD_SIZE-1);
+	inflated_offset = inflated_addr & (hpage_size - 1);
 	inflated_addr += offset - inflated_offset;
 	if (inflated_offset > offset)
-		inflated_addr += HPAGE_PMD_SIZE;
+		inflated_addr += hpage_size;
 
 	if (inflated_addr > TASK_SIZE - len)
 		return addr;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch
mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

