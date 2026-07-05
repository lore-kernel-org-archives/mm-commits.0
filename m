Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71C3033EC;
	Sun,  5 Jul 2026 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783279521; cv=none; b=FfgdK0Ns0vgN56NJ67t7NvQrBwmsx1rbs9jwT4lcTq8JDNf8SCQcikax22p6ttuPA75mI/dUt52fs4ciAKOCj+KDqyTifUmGstsrRpFWY/FPEmhTD6qpW0uPJsBSZJsi51UibbdDFe9T8Dpo5sU8kJhpp2ZPHQiYfSVp3CePryU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783279521; c=relaxed/simple;
	bh=ijyspr+c44CCaxqeaoj/aG6tYae95Fwhj/blnfm0pPI=;
	h=Date:To:From:Subject:Message-Id; b=gijBo8Dgmdn07DF8ImSiOmg200wHvUI6NNCHJ+V/NQL16sXtyUwYhapoa4KRq5sC+SEX+RK9QildVbtsH+C5KV4ghOvfA0WLYv6QhV/zo9qAElEHF2yrkR2OsuYRRNVqlUQ6gdyT8/1YXuXFxa0j8nEqlzB16LCZZmUBclIH+hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=st0G3iY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="st0G3iY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327D81F000E9;
	Sun,  5 Jul 2026 19:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783279520;
	bh=B6ncig4cfVSaa9pb4BHynlJDPjpQTJ1uWxcz7mLkD7E=;
	h=Date:To:From:Subject;
	b=st0G3iY1bg5mmnLNSPgdHtztJqihUlWwgPDss9y5RbwG8PgUqYzy+QSI2eagqd7wd
	 wuTtWP8aI7PbmlSmFuz2dJEXrPClzgD86kSOyrxQNtulq+RJtdU/FBRxS1k8WFZgdZ
	 DlexKiUSeRtzZoNrQiMUyVSFVH+Jb2NzASA0Fa2g=
Date: Sun, 05 Jul 2026 12:25:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,shakeel.butt@linux.dev,sashiko-bot@kernel.org,ryan.roberts@arm.com,riel@surriel.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,aarcange@redhat.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-wait-on-source-pmd-during-uffdio_move.patch added to mm-hotfixes-unstable branch
Message-Id: <20260705192520.327D81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: wait on source PMD during UFFDIO_MOVE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-wait-on-source-pmd-during-uffdio_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-wait-on-source-pmd-during-uffdio_move.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: userfaultfd: wait on source PMD during UFFDIO_MOVE
Date: Sun, 5 Jul 2026 06:12:31 -0700

move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the lock,
and, for migration entries, waits with pmd_migration_entry_wait().

Passing &src_pmdval is wrong.  pmd_migration_entry_wait() must lock and
re-read the real page-table PMD; on split-PMD-lock kernels, a stack
address also resolves to the wrong lock.  softleaf_entry_wait_on_locked()
then waits without a folio reference, which is safe only while serialized
against migration-entry removal by the real PT lock.

Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().

Link: https://lore.kernel.org/20260705131231.1499198-1-usama.arif@linux.dev
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=8
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~userfaultfd-wait-on-source-pmd-during-uffdio_move
+++ a/mm/huge_memory.c
@@ -2774,7 +2774,7 @@ int move_pages_huge_pmd(struct mm_struct
 	if (!pmd_trans_huge(src_pmdval)) {
 		spin_unlock(src_ptl);
 		if (pmd_is_migration_entry(src_pmdval)) {
-			pmd_migration_entry_wait(mm, &src_pmdval);
+			pmd_migration_entry_wait(mm, src_pmd);
 			return -EAGAIN;
 		}
 		return -ENOENT;
_

Patches currently in -mm which might be from usama.arif@linux.dev are

userfaultfd-wait-on-source-pmd-during-uffdio_move.patch
mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch

