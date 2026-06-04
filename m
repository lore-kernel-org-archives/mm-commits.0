Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC7738B7CD;
	Thu,  4 Jun 2026 19:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600920; cv=none; b=WuvxuAAJUi93zOuUkxBJp7GlZclxmezQlxsuwOhJSPntAiKvwVAQ/227+Tx/LLuXZ2cp9iweGu5EcR0sUBxM5fl6aC/yBf5pxes9GNc0nrsB2vlVkjShyd5o9W8DfiH7Z78y6eRR+mlcS8KpeLXbgBz+Jl2NwjY+PKqjr+f0RfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600920; c=relaxed/simple;
	bh=RjbBhK4NdcCanMMOdRqAZTwvR5HclcqdPzwrm/LL3TQ=;
	h=Date:To:From:Subject:Message-Id; b=BbSgFsIcamlp+Eum5OsgmteCrfW0ME/eXwKFHIhwWf9zvwNEY3W4/CMXOJyl4z8eGtaa0BJDQFmfq9yK6JqiielZ3q3njtO1BY9Vb58VC+JAlGxii7dhGVtkQJi1zgcJ++4Qc6fu1EQXRBi68j9Ox7TQUGUFX2zk6p4osHzPMnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dbjFlCoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dbjFlCoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C71B1F00893;
	Thu,  4 Jun 2026 19:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780600919;
	bh=4ZQKrc2W7Z3ADOGrFarF0lmXE+hqjlZP+zMmoFxUI1U=;
	h=Date:To:From:Subject;
	b=dbjFlCoojhW50jatmJcb8Rjt05x1N12QpLUVEbWUnQ1t9rckqUeXDbmllBdiGApwx
	 xjNR/9uXBOg9xZPVl7Vy0IP7tjN1S196avCSP3SIxUGdZsbOghwJ3gebCUcAjndqTy
	 +0p1mXP8Ui+93aPIPLWAnFFimDhNDcdTMFohnMWQ=
Date: Thu, 04 Jun 2026 12:21:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@kernel.org,ljs@kernel.org,david@kernel.org,balbirs@nvidia.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch added to mm-unstable branch
Message-Id: <20260604192159.4C71B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch

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

fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch
selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch
mm-khugepaged-generalize-alloc_charge_folio.patch

