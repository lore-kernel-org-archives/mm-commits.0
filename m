Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7073EA959
	for <mm-commits@vger.kernel.org>; Mon, 17 Aug 2026 22:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787004729; cv=none; b=RinKOEaVbZHhDk1NJ00vG3ryIaCjHPWYS1Tnn2MCyoj3h92bFwYMUmK54MjwuCo732vI98OugCTX3BkaORztl48oipIfg6JFAcwazVB56RtXXq/Gcr4ynvg3TN8xrGzukqUknUZYTK8w+LEgbvpMQBaL7HvoMj47Ir3Ud0/u8+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787004729; c=relaxed/simple;
	bh=2f8wB29OuxMjkLIYGyZOmUv9LLfBd5FpEGQFqQpbyRw=;
	h=Date:To:From:Subject:Message-Id; b=NzCZxY+mItdDrrAg4dl+RSvyEzKZ8OcDe05XlzkRuhkiCU4eC7uiU0N6kmrtYnO2nLbeMMzU85atKzMQHAnPWgEQpbbCkCEZhZoMSG6E1jKQrv4ebgcVHhz/VBLhNvh/IIchlU5MpkV1V5VGCfZ5UOBLZmrwJnkm/bILUxXWzic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RwLSMeYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RwLSMeYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77D21F00AC4;
	Mon, 17 Aug 2026 22:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787004727;
	bh=WD/5o2Sw4boMzkcwbeKwKarfxvBJy88CkTicmXVfN1o=;
	h=Date:To:From:Subject;
	b=RwLSMeYPIVJ0wh1wfSvxfNRMGFfxbRiTKTzlPRmf5wY/fRwfDqhorv5/vLPHMFB6k
	 MMsMEN+2FC/SrqCT3AcIFsjlVrbhJRkduWX4m9Aea2PogZ7ys2+4gIvbioJnVobK8W
	 81zMbaNtwdLwFWuB7p0vaVcH1ATl243yejf2QpDY=
Date: Mon, 17 Aug 2026 15:12:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd.patch added to mm-unstable branch
Message-Id: <20260817221207.A77D21F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: fix cache flush when replacing huge zero PMD
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hui Su <sh_def@163.com>
Subject: mm/migrate_device: fix cache flush when replacing huge zero PMD
Date: Mon, 17 Aug 2026 14:08:46 +0800

migrate_vma_insert_huge_pmd_page() calls flush_cache_page() before
replacing an existing huge zero PMD.  However, the third argument to
flush_cache_page() is a PFN, while addr + HPAGE_PMD_SIZE is an end virtual
address.

More importantly, the mapping being invalidated is PMD-sized rather than
PAGE_SIZE-sized.  Flush the whole PMD range with flush_cache_range(),
matching other huge PMD invalidation paths.

There is no userspace-visible effect today.  The architectures that
currently enable ARCH_ENABLE_THP_MIGRATION use no-op implementations of
flush_cache_page()/flush_cache_range().  32-bit ARM has non-trivial
implementations, but does not enable ARCH_ENABLE_THP_MIGRATION.

So this appears to be a latent API misuse rather than a currently
observable bug, and I don't think a stable backport is necessary.

Link: https://lore.kernel.org/20260817060845.377800-2-sh_def@163.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd
+++ a/mm/migrate_device.c
@@ -882,7 +882,7 @@ static int migrate_vma_insert_huge_pmd_p
 
 	if (flush) {
 		pte_free(vma->vm_mm, pgtable);
-		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
+		flush_cache_range(vma, addr, addr + HPAGE_PMD_SIZE);
 		pmdp_invalidate(vma, addr, pmdp);
 	} else {
 		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
_

Patches currently in -mm which might be from sh_def@163.com are

mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch
kasan-fix-cache-shrink-race-with-cpu-hotplug.patch
kasan-fix-quarantine_size-accounting-during-cache-removal.patch
mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd.patch

