Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A02346AC0
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782355187; cv=none; b=m8uyMiSEjyRwkccGbWEbQQt4xILEybpzMWpPvjyBiFrFxMra70i7cdYOAbyQ4kMAtRjZPuljueRxPcT1mgU+/qhwf3k4IAGkRhMFArgg6SbogYwUOCb/Tz+JdPpaHbXMPEsPjAO+OKfwo2GtYJ5qEePGKjhQtU9GVkWPZV7Syn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782355187; c=relaxed/simple;
	bh=QsSt3/UipVEC2QU3S8Cj6rG75YzLs1xbHQbDesGL9Es=;
	h=Date:To:From:Subject:Message-Id; b=ugiY5ttkAlx9fj6Lul831uaucZHKZO06RX3BlRiwH4WMTjxxnMkkTbSnSK84p2KSWqLhNtMV0GCCWsKKWJ/0WHiDUoGrVmITYoeCZmWOfPjZv8+vb8BWpd0EKTaQDShw097VxM0UsggqNvDMY+aXbWYCT3kamUStsJa3KKw6op8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J2bvUlH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J2bvUlH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEE21F000E9;
	Thu, 25 Jun 2026 02:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782355185;
	bh=1QYf6qgtlJ2vZfR9lNpUv4z+a5S+Y4pIIc0hMVM12ZM=;
	h=Date:To:From:Subject;
	b=J2bvUlH5WWLg5XPR2Gxw37FB6RwmcOxuG7Eqi/F3QVrq7huCYADUGvtjF73KvVM2j
	 wT/0fIXDogopAOvUIw0YVV9KUmfuNysG8fA+EW34efrXlvhrnRMrZxYXRdc8VNLk5Y
	 K1PqqJBSkvH/m7sA9qQXHgPaS5l6eZGDFy2t84J4=
Date: Wed, 24 Jun 2026 19:39:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch added to mm-new branch
Message-Id: <20260625023945.BFEE21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
Date: Thu, 18 Jun 2026 17:28:44 +0800

The mlock_vma_pages_range() uses walk_page_range() to walk the page table.
Fortunately, the caller always passes start/end that falls within a
single VMA, apply_vma_lock_flags() iterates per-VMA, and
apply_mlockall_flags() passes the whole VMA.

Since there is no .test_walk in mlock_walk_ops and VM_PFNMAP was filtered
by vma_supports_mlock(), it's safe to replace walk_page_range() with
walk_page_range_vma() to eliminate an unnecessary find_vma() lookup.

Link: https://lore.kernel.org/20260618092845.3905740-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range
+++ a/mm/mlock.c
@@ -446,7 +446,7 @@ static void mlock_vma_pages_range(struct
 	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
-	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
 	lru_add_drain();
 
 	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch

