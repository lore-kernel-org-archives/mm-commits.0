Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3243B28D;
	Thu, 14 May 2026 00:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719225; cv=none; b=oA78ZXdd6+ZhZnilNnSMpq5AuSFVTJTRa5mQQOG53gMZu1v+kJt15gOw55vsWPCJm+cGdUozcrmV2SG8MYYhPddC1+0Md9evc6R4vzPe3Oj3H8P4qPEMa8L0NylppzBJzVpDO2ke/BUCDZ7h1rF4RvXbEYj4zFTDly6274+6yMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719225; c=relaxed/simple;
	bh=DHXZrYr5HpqXxV6YN7/Rh2hvdaDOXXYVl3Wbie5hkNw=;
	h=Date:To:From:Subject:Message-Id; b=rnqLi5cev2wfnbUuIqiTW6L6QQtlEloLKCwM35n4ohFCM1W8XiinD4luNvNz1ZCm+wlENZcrt/OHamSHPbVKZhdlV5eb/n7NjArtrUCWaeJriRUa2WdL2demuWXk1+iHYbVMNfx08VeNv9DvKpoLWeQqS2J3I9z3o+FPk8MEJ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bryA+xMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bryA+xMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70512C19425;
	Thu, 14 May 2026 00:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719224;
	bh=DHXZrYr5HpqXxV6YN7/Rh2hvdaDOXXYVl3Wbie5hkNw=;
	h=Date:To:From:Subject:From;
	b=bryA+xMPvWISRrNPsoxZgFZbKAkuYzMambc3saLX3fCDFPcX1Xn3uCd3aHAbGOaN0
	 ohuwpQAaeGMvmH7cDChK2Sgr1qDoTj6j01tHXGFebuo2SnVbSJ4SeqTW6aXg4mY2Qk
	 N9LRqH/KSraLpy0bgZ3jD2tCDp1crhj0UFWwkWnI=
Date: Wed, 13 May 2026 17:40:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org,nueralspacetech@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate_device-fix-spinlock-leak-in-migrate_vma_insert_huge_pmd_page.patch removed from -mm tree
Message-Id: <20260514004024.70512C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: fix spinlock leak in migrate_vma_insert_huge_pmd_page
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-fix-spinlock-leak-in-migrate_vma_insert_huge_pmd_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sunny Patel <nueralspacetech@gmail.com>
Subject: mm/migrate_device: fix spinlock leak in migrate_vma_insert_huge_pmd_page
Date: Sat, 25 Apr 2026 19:05:27 +0530

When check_stable_address_space() fails after the PMD spinlock has
been acquired via pmd_lock(), the code jumps directly to the abort
label, bypassing the spin_unlock() call in unlock_abort. This causes
the PMD spinlock to be permanently held, leading to a deadlock.

Change the goto target from abort to unlock_abort to ensure the
spinlock is always released on this error path.

Link: https://lore.kernel.org/20260425133537.17463-1-nueralspacetech@gmail.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-spinlock-leak-in-migrate_vma_insert_huge_pmd_page
+++ a/mm/migrate_device.c
@@ -850,7 +850,7 @@ static int migrate_vma_insert_huge_pmd_p
 	ptl = pmd_lock(vma->vm_mm, pmdp);
 	csa_ret = check_stable_address_space(vma->vm_mm);
 	if (csa_ret)
-		goto abort;
+		goto unlock_abort;
 
 	/*
 	 * Check for userfaultfd but do not deliver the fault. Instead,
_

Patches currently in -mm which might be from nueralspacetech@gmail.com are

mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page.patch
mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch

