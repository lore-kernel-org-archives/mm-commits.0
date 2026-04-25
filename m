Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059DE86331;
	Sat, 25 Apr 2026 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777126571; cv=none; b=EqNlI7bXI4uYjCd00OUH+DKyHog/NURcm8O3RBS4POBVdrA6C2jb3Sjg2cOk6LMbjEsSSHc1nSpo9PTPKJ3IAhtE+or8vPJxjssQKKboQ9wbnFRM3qh4LiGlAgf8qcCb/ChWUEzaYgND3MrWOA+dKNV4NOgj57BWOW77/lkrD8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777126571; c=relaxed/simple;
	bh=3KJk8T1jkDR0NnuE6mdy+OrZzgQy59TL8Q0uqIjl7PY=;
	h=Date:To:From:Subject:Message-Id; b=u2bT1NxmdFI9yIlvcKvveGpv4+BgEjq3EuKW0M7i/AKQ/VfbUWKYVx/x66MnDf2zXo9T0MRnLaNR3VzZ4QkhPyxt/pbHYg9/kONAqDuLI0wWtI/d+9by0m64SoTa+nZRZ3lwbXM+Dveo+GWSJjvZKn+anlqJTal1Q+dJdLHU9zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OMrgvVNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OMrgvVNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73EBC2BCB0;
	Sat, 25 Apr 2026 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777126570;
	bh=3KJk8T1jkDR0NnuE6mdy+OrZzgQy59TL8Q0uqIjl7PY=;
	h=Date:To:From:Subject:From;
	b=OMrgvVNG3GgfbOyWYTJ41iJjhIvTMFei0i23Otm4CBduXPRum7hyfdWp6DJ+HUUV8
	 43hVFOD0uLbc6Il9bBunqgtJ0phDBpze3EHcCIeKDdKtsLQmtXRJIr30Ra2LYKpdUp
	 /DXVSTv/d+AD+oeC9O+UP2+r9C8CuRB/YljN5xo8=
Date: Sat, 25 Apr 2026 07:16:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org,nueralspacetech@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20260425141610.A73EBC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sunny Patel <nueralspacetech@gmail.com>
Subject: mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
Date: Sat, 25 Apr 2026 19:14:48 +0530

When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due to a PMD
check failure, the pgtable allocated earlier via pte_alloc_one() is never
freed, causing a memory leak.

Add a pte_free() call in the unlock_abort error path to release the
pgtable before returning.

Link: https://lore.kernel.org/20260425134453.23769-1-nueralspacetech@gmail.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/migrate_device.c~mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page
+++ a/mm/migrate_device.c
@@ -893,6 +893,7 @@ static int migrate_vma_insert_huge_pmd_p
 
 unlock_abort:
 	spin_unlock(ptl);
+	pte_free(vma->vm_mm, pgtable);
 abort:
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
_

Patches currently in -mm which might be from nueralspacetech@gmail.com are

mm-migrate_device-fix-spinlock-leak-in-migrate_vma_insert_huge_pmd_page.patch
mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page.patch
mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch

