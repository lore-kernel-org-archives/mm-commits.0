Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271FA2367CF;
	Sun, 31 May 2026 19:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255554; cv=none; b=eCoJV81Z4k9aElohTr2MbQ/ZdjaPFrUauJdjMgv4MkwebPZuS3WSux/8GMrllSQk/UzganamUDwqN6zmVT7pUde/t10QNqyOTWrw9L3je6omve75eWPz0huYtyXXxeCDKcSHc61G4CZ+7a1nj+GRiDAjIJyccEpdEP/w0MFnMd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255554; c=relaxed/simple;
	bh=WPANuC8P4JQyvClU7fIZoIl4UDZjdW3Mad3ihYThJmA=;
	h=Date:To:From:Subject:Message-Id; b=Fe6wejTftH4Xd7m35hG9WQVAcZSifG8WqxCsAjnKd4GgZzNVEqpH+BwnAW7AurLjq75DZnEgvZmiVt61SjQH7Uoz8IC7HuZ/tjG8utLMX0ezx/t1EWX/Kiu7v80VWsqI558tkupzoqXK7bnGequV1XOIhME2ofkaelvZcqzINh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0VnGTdlE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0VnGTdlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7AF1F00893;
	Sun, 31 May 2026 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780255552;
	bh=hApnSMvd00uPSImXIB2e76+9L+nVhMRFeVc5ZAsDmfs=;
	h=Date:To:From:Subject;
	b=0VnGTdlEmETqNxNOO0ONbPzI4WYwCLzfe4GF4peeJWiToJ9oyIDR8sftVC3TGIDwx
	 GUVIijlSlumgYp0WzpB2HDh9Mr7lxRDdT/o+Ak4W93KSZLahzDbgQXYrH5WmeZ3R+T
	 LQdFrG3rZGiFrHM43KDLj3fuhc8m/BT/JwS2WEWA=
Date: Sun, 31 May 2026 12:25:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,jannh@google.com,david@kernel.org,balbirs@nvidia.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch added to mm-new branch
Message-Id: <20260531192552.BC7AF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch

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
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

mm-khugepaged-generalize-alloc_charge_folio.patch
fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch
selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch

