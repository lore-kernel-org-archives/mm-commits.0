Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E4A1849
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289199; cv=none; b=gj10YWQPYWXv0dfG6W65bxgfpgntG6LIKvIP2n0k+H1uYnSLQ/0hxtVXxACP5SwdHHX+8av90R/MsiAxhHrvx7fVzKi6o0b4SFQRmgxMuOcVSMEY9zT50/3nuGJ1LZd+ZYhExoV9rYncz5f/VOHS5dBXLcXbOriqDZDVZv0sBgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289199; c=relaxed/simple;
	bh=S27+YEXWG9Xu4RWgFPwoNSPKs3BzPvIXQAdLBJLcng0=;
	h=Date:To:From:Subject:Message-Id; b=m5ic5bADCMQlmCxRgs5iLseQKn9tnIu0Nmw43JUifkYsOhNAmtxB1QRxmn4kKo70Kd8FmPHZJPLF5Sc6ORkGqPW161t/8V3I1+sbmcndmuPV7NHcrjj+uyUO/yHGMmH/oUIa6/tdnuBeybAXll59RXgCul8Jy7g5LZwO9UNpPaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KILfK+s0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KILfK+s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC34C32782;
	Tue, 25 Jun 2024 04:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289199;
	bh=S27+YEXWG9Xu4RWgFPwoNSPKs3BzPvIXQAdLBJLcng0=;
	h=Date:To:From:Subject:From;
	b=KILfK+s03zy1wbmZJOs7hgBO4/aPOU9VYloGR4V+cH6mjiltEtA4wvhEA6EuBdx4E
	 E9KNuhqVrHdq9/AQIXxkkhOronvwsY8dN9GjhRbSqzBAjucbZ8cEf2llYuYmsJ0zlN
	 uxRKk8Z/OAv25fljiSxd5aicsTd3gfaUquRFH4Ls=
Date: Mon, 24 Jun 2024 21:19:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-extend-finish_fault-to-support-large-folio-fix.patch removed from -mm tree
Message-Id: <20240625041959.0FC34C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-extend-finish_fault-to-support-large-folio-fix.patch

This patch was dropped because it was folded into mm-memory-extend-finish_fault-to-support-large-folio.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix
Date: Thu, 13 Jun 2024 21:03:36 +0800

avoid going beyond the PMD pagetable size

Link: https://lkml.kernel.org/r/b0e6a8b1-a32c-459e-ae67-fde5d28773e6@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com> 
Reported-by: syzbot+d6e5c328862b5ae6cbfe@syzkaller.appspotmail.com
Fixes: 1c05047ad016 ("mm: memory: extend finish_fault() to support
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-extend-finish_fault-to-support-large-folio-fix
+++ a/mm/memory.c
@@ -4876,13 +4876,17 @@ vm_fault_t finish_fault(struct vm_fault
 		pgoff_t idx = folio_page_idx(folio, page);
 		/* The page offset of vmf->address within the VMA. */
 		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
+		/* The index of the entry in the pagetable for fault page. */
+		pgoff_t pte_off = pte_index(vmf->address);
 
 		/*
 		 * Fallback to per-page fault in case the folio size in page
-		 * cache beyond the VMA limits.
+		 * cache beyond the VMA limits and PMD pagetable limits.
 		 */
 		if (unlikely(vma_off < idx ||
-			     vma_off + (nr_pages - idx) > vma_pages(vma))) {
+			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
+			    pte_off < idx ||
+			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE - 1)) {
 			nr_pages = 1;
 		} else {
 			/* Now we can set mappings for the whole large folio. */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

