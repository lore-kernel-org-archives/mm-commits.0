Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BFA3B0585
	for <mm-commits@vger.kernel.org>; Sat,  3 Oct 2026 22:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067144; cv=none; b=F2Q4M83dJZI5HcGwgq3UTwBnGSGorzgVPFEk54MMT0F1dt28xPWOClvOpDksS46xl77kLqrIiKLTLoi6yAKRo0yt46QPAA+k4MqYYB1XjBdX8BDLY9lAO3BhyEp4SW4ASW++shuyLhAKrEcZyoX+QsYOo2SlbLPgDSFgkSMQfP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067144; c=relaxed/simple;
	bh=jwScjm3L1TkY7HD+J9KfndkQW60XUOHo9DSfXw/+kck=;
	h=Date:To:From:Subject:Message-Id; b=Gx4OGX90PWP2CJ6qFOWr3vsX1VnaX2nZBrGBvHouY9vqybtQEkWLn/BYDzg0O9Ic+iOByLJ5Wx2d0Xe6jOxzhYmTQHP4CWm+EIeeCuMT1R/GNGOLWIJl6jGrmIR+LpB+d7Bx5TYoLvMnYHGk7veFwIXpK23Gl4qu/YPRdQPNPCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Xj99iDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Xj99iDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838B51F0089C;
	Sat,  3 Oct 2026 22:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791067142;
	bh=fKp+KmJHaExut2MILxFpP1OgtRAnycafQqPu3eCa1JE=;
	h=Date:To:From:Subject;
	b=1Xj99iDyY3p04eoQ1MIURz05plO1FKpeVWGOzRxcoDkZTh3lWDmdc1JQj0/+J4Kfn
	 GzElGlFVwDHrCcPU95KH2BF6P46joVvpaLv5coyyKBPcpy3oKE/4G4PGK33rz42ocw
	 HSHRsFm9V/HzSM7c1A5TNwtIei+Jco51TM6GzdrI=
Date: Sat, 03 Oct 2026 15:39:02 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-drop-some-redundant-checks-around-hugetlb-vmas.patch removed from -mm tree
Message-Id: <20261003223902.838B51F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop some redundant checks around hugetlb VMAs
has been removed from the -mm tree.  Its filename was
     mm-drop-some-redundant-checks-around-hugetlb-vmas.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: drop some redundant checks around hugetlb VMAs
Date: Thu, 17 Sep 2026 17:22:38 +0100

Adjust code which inadvertently perform redundant checks on hugetlb VMAs
and clean them up:

* hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
  suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
  the series, once VMA_SPECIAL_FLAGS is removed.)

* hugetlb VMAs unconditionally set vma->vm_ops, so they are never
  anonymous.

* hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.

While we're here also drop a VM_BUG_ON() which the simplified check above
makes unreachable, and use the new VMA flag API.

No functional change intended.

Link: https://lore.kernel.org/20260917-b4-mmap-prepare-vma-flag-sanify-v3-29-4583d8a23bca@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anup Patel <anup@brainfault.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Emil Tsalapatis <emil@etsalapatis.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jaya Kumar <jayalk@intworks.biz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 drivers/gpu/drm/drm_gpusvm.c |    3 +--
 mm/migrate_device.c          |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~mm-drop-some-redundant-checks-around-hugetlb-vmas
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -1141,8 +1141,7 @@ drm_gpusvm_range_find_or_insert(struct d
 	 * limitations. If/when migrate_vma_* add more support, this logic will
 	 * have to change.
 	 */
-	migrate_devmem = ctx->devmem_possible &&
-		vma_is_anonymous(vas) && !vma_is_hugetlb(vas);
+	migrate_devmem = ctx->devmem_possible && vma_is_anonymous(vas);
 
 	chunk_size = drm_gpusvm_range_chunk_size(gpusvm, notifier, vas,
 						 fault_addr, gpuva_start,
--- a/mm/migrate_device.c~mm-drop-some-redundant-checks-around-hugetlb-vmas
+++ a/mm/migrate_device.c
@@ -743,8 +743,8 @@ int migrate_vma_setup(struct migrate_vma
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_is_hugetlb(args->vma) ||
-	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
+	    vma_is_dax(args->vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-userland-pgtable-freeing-is-rcu-safe-now-remove-leftover-bits.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
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
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

