Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8419379EDF
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 19:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600818; cv=none; b=rrEWYJn1htsKx6MOWmGaU98ZGX0XfTfmRcvlUim5wPlRdgxugbJu+U+woATacdi7cha4bFATkH//U3eZxLIDXr6RygFzESTOCVswA0vv9De/ePI7R7RxbzM4nuxoVWAtxoaCjhnkTrX7h7lfOLezTT0AlHzu+lhp300KCyykmcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600818; c=relaxed/simple;
	bh=THyuvIFFokIboOTmB7VBBc2rozOdJ0y1Wzx9eovKGdc=;
	h=Date:To:From:Subject:Message-Id; b=X/ZdHhRfSVp5Q+8xaMz7HO8AmrfKxF9LkwvtZxL3Ga3oKZE4MVNMCvmhuZ7TnCkHI919iKqOuuaacB8j7ujtl+dEjbRZnP29mZaFXyQbcOY5GtTNP/buYx4+32uTlsIvGK8obTzkmv0Jbh9wMPi43s3SNrC8qIMXIgyVBotoxMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Few8pHzR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Few8pHzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805111F00893;
	Thu,  4 Jun 2026 19:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780600816;
	bh=VQk4q6aelIsMNZqefAXtrp+PcBFd9O2IbbkXrorPbjQ=;
	h=Date:To:From:Subject;
	b=Few8pHzR6Ed9E9DrO48gHDnT6Ly+ypG7RzmtpsnMr9wPqRXR5peMtUggtdeLiQ5qy
	 yiVZlhuM+RNwPV4PHtdhBbdorwiEjOrI43Z+oPA9sowwnLZxq9IX820ryEMSSy0bSE
	 W6DQ2uGtcGKTP2DdZNVu2kqN6b9wt9NJBotU7aII=
Date: Thu, 04 Jun 2026 12:20:16 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch removed from -mm tree
Message-Id: <20260604192016.805111F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
Date: Sat, 30 May 2026 08:54:11 +0000

Patch series "mm/hmm: A fix and a selftest", v2.

Patch 1 fixes a stale warning present from the time when only migration
softleaf entries were supported at the PMD level.

Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
for PMD device-private entries.


This patch (of 2):

pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
entry.  This became false once device-private entries at the PMD level
were added.

Therefore, remove the stale migration-only assertion.

Link: https://lore.kernel.org/20260530085413.1270139-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260530085413.1270139-2-dev.jain@arm.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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

selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch
mm-khugepaged-generalize-alloc_charge_folio.patch

