Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D50F2F9C37;
	Tue,  9 Jun 2026 01:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968179; cv=none; b=c/HKrG67Qxj9WWE6GfH3lteNaZeJ5XgTcCqUEshvhXV+Pr5AQmWBmWX3lRtHSogxzpgCrlBQ6wOb8YiR0vcEZECdKTE6AAiV+IOsQw8BWgmHrQ8y+z7z0UDjOp0XIEZxaK5eZV/cvfbQ/T8MaNRBdXQJ5F3rl+voJHkr+q8E/Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968179; c=relaxed/simple;
	bh=0rJosYoedBTOl0baMIJP+4kCue3SCMbweyIWGu475qU=;
	h=Date:To:From:Subject:Message-Id; b=CYu+Pmhvo95yxotH8djNEsSuCg4/1SUdrSocqBRUPvaE/R19fj5EyQ+rUrdWY0pVivjzdm/kS88kK08v5rMwccH6vYAkzwaBWD6j9sAJsBAB3tPU8vTR0LFdRRpbi60D/Lny6T+XmXTKyENzZSeMU0M0tQzDeTN/6KHYImDZEx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/kTKumE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/kTKumE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57501F00893;
	Tue,  9 Jun 2026 01:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968178;
	bh=hYM5HYSm6WE7dVmU0hyCB7yR52izCnaxQTmAmcEvL84=;
	h=Date:To:From:Subject;
	b=k/kTKumEZlKL4/7wKy4Xxi/c8eCE21X9odKmlnuCxuQ4yYQ6HM6vU7doOhRhvny2G
	 qM4BlDS5brK7KZoMNznEKpqDKtYvTobDduf5gAssjBEltkE6qOp1twJSDWPkc1aqek
	 7LiIDGkIOQmnMRXqUeSLQqLgF745mPOLt4qpMfnw=
Date: Mon, 08 Jun 2026 18:22:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@kernel.org,ljs@kernel.org,david@kernel.org,balbirs@nvidia.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch removed from -mm tree
Message-Id: <20260609012257.E57501F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
Date: Thu, 4 Jun 2026 05:53:05 +0000

Patch series "mm/hmm: A fix and a selftest", v3.

Patch 1 fixes a stale warning present from the time when only migration
softleaf entries were supported at the PMD level.

Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
for PMD device-private entries.


This patch (of 2):

pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
entry.  This became false once device-private entries at the PMD level
were added.

Therefore, remove the stale migration-only assertion.

Link: https://lore.kernel.org/20260604055308.1947679-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260604055308.1947679-2-dev.jain@arm.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry
+++ a/fs/proc/task_mmu.c
@@ -2129,7 +2129,6 @@ static int pagemap_pmd_range_thp(pmd_t *
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
 		page = softleaf_to_page(entry);
 	}
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-khugepaged-generalize-alloc_charge_folio.patch

