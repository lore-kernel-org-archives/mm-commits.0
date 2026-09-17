Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6A84E4C3A
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789680342; cv=none; b=q0bw5TRwrvypDNjagEDjHYEf08RzGZCeQO4LvWQCi4hsh9qSW49SvAqMADdsAraxW4kIMj2vF7Czh6ZCHvMsHGF9q4WGRmhfjigmWcNpCpP/ZtPRzy6YISM8zs6SO4qc8L1gG4VqlJXcByr12sdVP0IbW3LDN6i0rOL4iBpPH78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789680342; c=relaxed/simple;
	bh=Upy2ZMg3WtgYvsgK6qKpjcsRIO5tCkWES2veij/9Vg4=;
	h=Date:To:From:Subject:Message-Id; b=L9ww57K4mSnVLfdrOKLk8l767EStq8+56uwcWSDVV3pj1mVgYPJR2jgvMfvwRmTI1y6z0aWq+m/MK2DfzcaCiL3n94L2MW1H+el77rFlQMM/KCF76BEySJp7hvaWC4zYZ1ULO1hEJe5mh564GGGpPpfMxvbx9T/0X1lIQtOni20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ii9f8IzE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ii9f8IzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6194D1F000FF;
	Thu, 17 Sep 2026 21:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789680340;
	bh=LsbBOB+yYHzlLhlSrMtKUcCUmZuI2PtMZhas/wNaZ04=;
	h=Date:To:From:Subject;
	b=ii9f8IzEsJ9gaL+TFYEvMZ3ToCH/P14kQYDQBurbGnz+ym4DT/A9iOgBJXe7oCHhI
	 RkHyhoLLDVbD/uYapXjW/WBoGcuoM8YwEtyRjt3PmmZs073llKg087QPGkzKwxbeI2
	 rWszDmICJf2/HM3r3+Wj983ddEuWTFupxy+io8cY=
Date: Thu, 17 Sep 2026 14:25:39 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-hugetlb_inlineh.patch added to mm-unstable branch
Message-Id: <20260917212540.6194D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove hugetlb_inline.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-hugetlb_inlineh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-hugetlb_inlineh.patch

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
Subject: mm: remove hugetlb_inline.h
Date: Thu, 17 Sep 2026 17:22:36 +0100

This header really makes little sense - every place it is included mm.h is
also included, and the header itself includes mm.h, so it does nothing to
reduce header size.

It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
VMA_HUGETLB_BIT is unconditionally available, and will never be set if
hugetlb is not enabled.

Simply remove the header, eliminate the odd ifdeffery and place the
predicates in mm.h.

The naming of these predicates is odd, but to keep changes separate, we
will address this in a separate patch.

The file was never put into MAINTAINERS so there's no change required
there.

No functional change intended.

Link: https://lore.kernel.org/20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org
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

 drivers/gpu/drm/drm_gpusvm.c   |    2 +-
 include/asm-generic/tlb.h      |    2 +-
 include/linux/hugetlb.h        |    1 -
 include/linux/hugetlb_inline.h |   28 ----------------------------
 include/linux/mm.h             |   11 +++++++++++
 include/linux/pagemap.h        |    1 -
 include/linux/userfaultfd_k.h  |    1 -
 kernel/sched/fair.c            |    1 -
 mm/vma_internal.h              |    1 -
 9 files changed, 13 insertions(+), 35 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~mm-remove-hugetlb_inlineh
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -9,9 +9,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/hmm.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/memremap.h>
 #include <linux/mm_types.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 
 #include <drm/drm_device.h>
--- a/include/asm-generic/tlb.h~mm-remove-hugetlb_inlineh
+++ a/include/asm-generic/tlb.h
@@ -11,9 +11,9 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
-#include <linux/hugetlb_inline.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
--- a/include/linux/hugetlb.h~mm-remove-hugetlb_inlineh
+++ a/include/linux/hugetlb.h
@@ -7,7 +7,6 @@
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
 #include <linux/fs.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
 #include <linux/page_ref.h>
 #include <linux/list.h>
diff --git a/include/linux/hugetlb_inline.h a/include/linux/hugetlb_inline.h
deleted file mode 100644
--- a/include/linux/hugetlb_inline.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_HUGETLB_INLINE_H
-#define _LINUX_HUGETLB_INLINE_H
-
-#include <linux/mm.h>
-
-#ifdef CONFIG_HUGETLB_PAGE
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return vma_flags_test(flags, VMA_HUGETLB_BIT);
-}
-
-#else
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return false;
-}
-
-#endif
-
-static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
-{
-	return is_vma_hugetlb_flags(&vma->flags);
-}
-
-#endif
--- a/include/linux/mm.h~mm-remove-hugetlb_inlineh
+++ a/include/linux/mm.h
@@ -1609,6 +1609,17 @@ static inline bool vma_is_shared_maywrit
 	return is_shared_maywrite(&vma->flags);
 }
 
+static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
+{
+	return is_vma_hugetlb_flags(&vma->flags);
+}
+
 /**
  * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
  * contents of the VMA are owned by the kernel rather than the core mm?
--- a/include/linux/pagemap.h~mm-remove-hugetlb_inlineh
+++ a/include/linux/pagemap.h
@@ -14,7 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
-#include <linux/hugetlb_inline.h>
 
 struct folio_batch;
 
--- a/include/linux/userfaultfd_k.h~mm-remove-hugetlb_inlineh
+++ a/include/linux/userfaultfd_k.h
@@ -18,7 +18,6 @@
 #include <linux/swap.h>
 #include <linux/leafops.h>
 #include <asm-generic/pgtable_uffd.h>
-#include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
--- a/kernel/sched/fair.c~mm-remove-hugetlb_inlineh
+++ a/kernel/sched/fair.c
@@ -22,7 +22,6 @@
  */
 #include <linux/energy_model.h>
 #include <linux/mmap_lock.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/jiffies.h>
 #include <linux/mm_api.h>
 #include <linux/highmem.h>
--- a/mm/vma_internal.h~mm-remove-hugetlb_inlineh
+++ a/mm/vma_internal.h
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/kernel.h>
 #include <linux/ksm.h>
 #include <linux/khugepaged.h>
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

