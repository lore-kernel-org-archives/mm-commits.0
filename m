Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5F73EF67D;
	Tue, 21 Jul 2026 00:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594612; cv=none; b=DX+unyRgN1Kc5r8yB7TxjD6G/Y0ukD5MqjkElU+Sv0x0gZaxlkbvL1fgqO3+WiNY42i/b4qKtqMEJ5/cfklNGyKNtbZaf8dhapUvepzQ0mhFw9n4KzbhdORhka7UenfIbzISpt4a1Z8TpHab0kM00peiQNRlbb4FRrnSDe8+QZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594612; c=relaxed/simple;
	bh=w10yV26HJZMwQYRzj/iITpt9/zeVVskmEWOkCHsVbn4=;
	h=Date:To:From:Subject:Message-Id; b=bupOL/ozzk4DL8Iz9HJ/W95mDMeKMGT4DJZJftFMdHei1SFpUYFUFslV/LLBa2xi3nIq5U2Mn9hDlzn85LpoAk3bQ2M6/12IJGEUQA6hEVSMn1a6h5wlBdBF4vY+BDh1ezo/5RloakqcUi4FVHhY726s0H7VcWQto0Q4uYtkOc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=arMznA4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="arMznA4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950E71F000E9;
	Tue, 21 Jul 2026 00:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594610;
	bh=OH+U8Vg1RsLNlM4IZL+EJlD6DGEWuSij7FEkZLJRFcc=;
	h=Date:To:From:Subject;
	b=arMznA4TnQ6aGpItT054EzQnJdjvPtz3w1kRIURk8/JfEVl2EEVcE4PZRloQLfpMz
	 n+EXB+t+Bk2i7kSCu4PAPL82UxULRbfA04f1fVBlvmC9zpGIIjd4Dm9GEQKWukgEOo
	 3jdGdXVfOa0+GikTq9/87p1k0CSr0cYX1a2jLhrM=
Date: Mon, 20 Jul 2026 17:43:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,shakeel.butt@linux.dev,sashiko-bot@kernel.org,ryan.roberts@arm.com,riel@surriel.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,aarcange@redhat.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-wait-on-source-pmd-during-uffdio_move.patch removed from -mm tree
Message-Id: <20260721004330.950E71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: wait on source PMD during UFFDIO_MOVE
has been removed from the -mm tree.  Its filename was
     userfaultfd-wait-on-source-pmd-during-uffdio_move.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
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

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch
mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch

