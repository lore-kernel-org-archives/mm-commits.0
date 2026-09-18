Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9E94C6D
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 00:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789690138; cv=none; b=AYo6Y0J3wDXolRu8ZDacvnK4Jg9vZmBM8qpWCaMq+zOreSH2Dky+uHUtcxEXzY3Qj2vBcYL9Uuv/37Z0xz8+p5w7+iXNStCJ3EDB9qKGjZEfP+0U1M55zztXMuoJyst8mfuQZQyeYbDO5VVy2EjuGQRALqG1u/GYG0OBhsB+W2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789690138; c=relaxed/simple;
	bh=7z8CLyyaFbDhSwESO4pVzaPSDn+c6E9OYh9g2P1BiX0=;
	h=Date:To:From:Subject:Message-Id; b=m6FJKuf/W7YNXNBNJciBYy7MlO9Iac/LQSRXaNN1U82YE9cBYbt8slXO4+MN4ta5MfJ9on75PDOdNzB+z+zi6L7QeSTD1UZ65SGATOghUn0QgazlOubmOPuXOzR8qMIBscQxGtBir5SMd2ctUdpSf8qp1x2XHr3x4queDUfgSRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PRNGcvU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PRNGcvU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08D51F00893;
	Fri, 18 Sep 2026 00:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789690135;
	bh=boyisrT2chZf8lJbgF0n6Js8u7O5ET4rzjH5lfR/r+8=;
	h=Date:To:From:Subject;
	b=PRNGcvU4yWKnWfnzLZ6eg0bPsi24l1OUTzjgFXVCsUe+i4XTNHuBQlw2CQ1APM3UL
	 eMKSpH3c46LjYfUt03+LAnXL+obgucJgoMLQxgbaboXBlNuS1OfNEmbIMuj6XL43e0
	 ewY8VFORrqbFpAi0uBb1c5UGfk85qC5bzzJ4OFcc=
Date: Thu, 17 Sep 2026 17:08:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,vbabka@kernel.org,trintaeoitogc@gmail.com,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,matthew.brost@intel.com,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,jannh@google.com,harry@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch added to mm-new branch
Message-Id: <20260918000855.D08D51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: const-ify vma_assert_stabilised() and associated functions
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: const-ify vma_assert_stabilised() and associated functions
Date: Thu, 17 Sep 2026 20:47:41 +0100

Patch series "mm: implement and use vma_has_anon_rmap(), silence KCSAN".

Provide a function to abstract the common task of checking whether a VMA
has an anonymous reverse mapping associated with it.

In the first patch, const-ify vma_assert_stabilised() and related
functions so that vma_has_anon_rmap() can reference a const vma pointer.

In the second patch, introduce vma_has_anon_rmap().

Finally in the third patch, update comments referencing anon_vma to
instead reference the anon rmap to abstract this conceptually to avoid
confusion.

There are still other functions which reference anon_vma directly, those
can be addressed in a follow up.


This patch (of 3):

The vma pointers are not modified in any of these functions so make it
official by const-ify them.

Propagate this throughout the call stack.

No functional change intended.

Link: https://lore.kernel.org/20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org
Link: https://lore.kernel.org/20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
---

 include/linux/mmap_lock.h       |   12 ++++++------
 tools/testing/vma/include/dup.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-const-ify-vma_assert_stabilised-and-associated-functions
+++ a/include/linux/mmap_lock.h
@@ -273,7 +273,7 @@ static inline void vma_end_read(struct v
 	vma_refcount_put(vma);
 }
 
-static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
+static inline unsigned int __vma_raw_mm_seqnum(const struct vm_area_struct *vma)
 {
 	const struct mm_struct *mm = vma->vm_mm;
 
@@ -288,7 +288,7 @@ static inline unsigned int __vma_raw_mm_
  *
  * Returns true if write-locked, otherwise false.
  */
-static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
+static inline bool __is_vma_write_locked(const struct vm_area_struct *vma)
 {
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
@@ -344,7 +344,7 @@ int vma_start_write_killable(struct vm_a
  * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
  * @vma: The VMA to assert.
  */
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
 {
 	if (!IS_ENABLED(CONFIG_MMU)) {
 		mmap_assert_write_locked(vma->vm_mm);
@@ -359,7 +359,7 @@ static inline void vma_assert_write_lock
  * lock and is not detached.
  * @vma: The VMA to assert.
  */
-static inline void vma_assert_locked(struct vm_area_struct *vma)
+static inline void vma_assert_locked(const struct vm_area_struct *vma)
 {
 	unsigned int refcnt;
 
@@ -410,7 +410,7 @@ static inline void vma_assert_locked(str
  * With lockdep disabled we may sometimes race with other threads acquiring the
  * mmap read lock simultaneous with our VMA read lock.
  */
-static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
 {
 	/*
 	 * If another thread owns an mmap lock, it may go away at any time, and
@@ -445,7 +445,7 @@ static inline void vma_assert_stabilised
 	vma_assert_locked(vma);
 }
 
-static inline bool vma_is_attached(struct vm_area_struct *vma)
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
 }
--- a/tools/testing/vma/include/dup.h~mm-vma-const-ify-vma_assert_stabilised-and-associated-functions
+++ a/tools/testing/vma/include/dup.h
@@ -1178,7 +1178,7 @@ static inline struct vm_area_struct *vma
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
-static inline bool vma_is_attached(struct vm_area_struct *vma)
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
 }
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

