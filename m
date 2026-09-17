Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B31A4E9C2F
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679431; cv=none; b=UXpiLcWrmZbN98JdhlAdRtm3KIXX5+oTWjRDOzbvh00EXLRV2lRzES05wsTcYr9/O4NI6t0eR/OGEmzxrnjrxehjraZX9L3s8CrpgFx3/pmUdE3K9pl0kmFCDyvWMO0GEUTLMJoNe9ZaBmapi3GRRQTBE3XiRRqcXgdhiQKPa9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679431; c=relaxed/simple;
	bh=sOzeEwW4SH7xZG2yh7WlqYTqRPx02E6oKaNg1mAGdtA=;
	h=Date:To:From:Subject:Message-Id; b=U4RGyvLEhDZC5piaZJddLtiGT0kUky4c4KuLJs0aOgNLR/Dla4+dwvdIZ6SZscRszrvP4NeNnt79laAuFw06HVnKuT1sWRy47lVPsfCN84Ag8NDyckYnGZdBKLKRIV1lbiewh3ZuDOLlinV1b4WK/C+WiE5Yl/5lPKqIY/P6idE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UOImDZOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOImDZOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723151F000FF;
	Thu, 17 Sep 2026 21:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679429;
	bh=B3mxVkj14kecNrK1Mtuuyzpf4DI971kUcmSpzcMtVz4=;
	h=Date:To:From:Subject;
	b=UOImDZOavQaRvEqb5ru5ojhhXo1Nb2qfegGx0x6QlGz/FNcU6LGrolttdE2vxv+Ab
	 fknNv1yAxPBd9gEfg2t8m8+SQ9EBom6gYNU83wMJXWo2b/sQNpqj5zEsDEX5kvsbPT
	 QUHg9XeGPOmepz9peK+wfDjIqBzbyev2dRj16QZM=
Date: Thu, 17 Sep 2026 14:10:29 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-madvise-use-predicates-for-madvise-madv_dofork.patch removed from -mm tree
Message-Id: <20260917211029.723151F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: use predicates for madvise(..., MADV_DOFORK)
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-predicates-for-madvise-madv_dofork.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/madvise: use predicates for madvise(..., MADV_DOFORK)
Date: Mon, 14 Sep 2026 15:57:53 +0100

Make it clear what we're blocking in MADV_DOFORK.  Previously we simply
disallowed VM_SPECIAL i.e.  kernel-owned mappings, fixed mappings and
VMA_IO_BIT.

Now the invariant is established that only kernel-owned mappings can set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a kernel-owned or fixed mapping,
i.e.  exactly the same check as whether the VMA is permitted to be merged.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing differently - if we wouldn't be allowed to merge
it, then we aren't allowed to manipulate CoW behaviour on fork.

No functional change intended.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-33-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-use-predicates-for-madvise-madv_dofork
+++ a/mm/madvise.c
@@ -1565,7 +1565,7 @@ static int madvise_vma_behavior(struct m
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_can_merge(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-huge_memory-zap-deposited-page-tables-after-an-rcu-grace-period.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

