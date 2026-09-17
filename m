Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FBF4F5DEA
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789680329; cv=none; b=GPQoyd8VC08G5GIm9xNoRWGL9HsWTzRfraa2jk8SEhbN6HC5URv9bnRJ8ZTizvHr9/O3P27QL/mXRuLx+DqSBxIBT+20cwlUXwaOqk4XVXXBm3JKlI923fGly5l0bsOICyP1ejGHVuo9STHpIZuFkupPZu3NArMW8GwKGS9YYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789680329; c=relaxed/simple;
	bh=tH7YCf+iAwW+ZZ+lx87GpNWLzfgAcxq/nD2zOn90uoU=;
	h=Date:To:From:Subject:Message-Id; b=Ez0R47N3yPuNNYgHtVcoQwlRx/uxltlFbm/aBNc+Rs2SpZBbwIVMcj2FdmyPVM26C9e54oAlx0/cUwirtm/kyVz0jkxbVOQT/dv6USr35wfBYlduwAOmylbA/fbsVf1FCjfGsUjixp/9nnx+QCK98HS+Agd35EdgIe7yO9viynY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1p6neLiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1p6neLiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5C81F000FF;
	Thu, 17 Sep 2026 21:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789680326;
	bh=CngBQYiyJGQOUGIH1FOiCk3WT5DmagrAErs2FQCnmzk=;
	h=Date:To:From:Subject;
	b=1p6neLiq6BwAJiqIidJRP04NDAVOuMAF/bRP10w8x0zgYhwf8NNlNmyp0hmymjF9/
	 LFl440QPO+Gx/k8BLfBhWcGIhh48+AfvfyWGpwetDv/mLCFKFKCHIRLW0jsgg3EFXG
	 +ZwIsyu8KpXzCj01rZ7pplTtq7srrtZmxpc+g/VQ=
Date: Thu, 17 Sep 2026 14:25:25 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch added to mm-unstable branch
Message-Id: <20260917212526.4B5C81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
Date: Thu, 17 Sep 2026 17:22:33 +0100

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT.  These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

Finally, with the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio() and folio_add_lru_vma() to simply test for
VMA_LOCKED_BIT.  munlock_vma_folio() tests VMA_LOCKED_MASK instead, as an
unmap racing with the locking walk must still munlock folios the walk has
already counted.

While here, also replace some deprecated VMA flag predicates.

Link: https://lore.kernel.org/20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Cc: David Hildenbrand <david@kernel.org>
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
Cc: Marc Zyngier <maz@kernel.org>
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
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/folio.c    |    2 -
 mm/internal.h |   10 ++++++---
 mm/mlock.c    |   51 +++++++++++++++++-------------------------------
 mm/rmap.c     |    4 ++-
 4 files changed, 30 insertions(+), 37 deletions(-)

--- a/mm/folio.c~mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify
+++ a/mm/folio.c
@@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *fol
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
--- a/mm/internal.h~mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify
+++ a/mm/internal.h
@@ -971,8 +971,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/* The VM_IO check prevents migration from double-counting during mlock. */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -989,7 +988,12 @@ static inline void munlock_vma_folio(str
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	/*
+	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+	 * mlock_vma_pages_range(). An unmap racing with the walk must still
+	 * munlock folios the walk has already counted.
+	 */
+	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
 		munlock_folio(folio);
 }
 
--- a/mm/mlock.c~mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify
+++ a/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_s
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, u
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
--- a/mm/rmap.c~mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify
+++ a/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct foli
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*
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
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
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

