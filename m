Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A56D2DEA93
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 00:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791072024; cv=none; b=Lm9HcfQDUm8Ii0tZEUrXerSLwaY1WLB59B+wg6ahEkhM1mDPRlOqFa08xfhiIGtQ92Al7F93o5ZbqBmKJfEDSfsvb26wDicDqwrxd5gYSCSwhyuSdcepJ3x6KTqw5MiX9tYFSiEiUlCh3jgo//LFGOpEmZ3DcEXkp1yNLJhCeSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791072024; c=relaxed/simple;
	bh=7XoOFk8DqcYSOF3tgIXKgqVbk9wu7d+YZ35BtqaYF8w=;
	h=Date:To:From:Subject:Message-Id; b=NoROolh5zbKQNQoYblOAnZRm8yjsmPggwcVELf+f7nP8wK9KxhyvItjDJnfdWtchGbCww2HC/XvdOsTzwrjgJHB/LZJ56X8Ba6wnDQmEzKuPiLhoOT5a3s/C61dTv2JHWQ4ZMeJ565cr3i2zTMiplH9lbbkhcKlsV3V1xreCb0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ul5FsLt8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ul5FsLt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E7F1F0089B;
	Sun,  4 Oct 2026 00:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791072019;
	bh=PIk+DDvF9M49PsBBR/bFvXR7Wk9FCad4pInaea8tvWU=;
	h=Date:To:From:Subject;
	b=ul5FsLt8jJ5+guyBTvqfeW6GPwH59ClxNwdURYt8/YRvbxo3g+RChKJe5Ixfht6TJ
	 mHQnhbTdnH0oXCFkGWvSjU44OTn9BthWLouNeKvwvtGIUMPGUPoh6GL7uFRI3mMSDh
	 4eiEB9qDgOzH7b6Sz6T5uyGGyFOQI0qBX/rZl0hY=
Date: Sat, 03 Oct 2026 17:00:19 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-introduce-vma_is_mm_backed.patch added to mm-unstable branch
Message-Id: <20261004000019.B3E7F1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: introduce vma[_flags]_is_mm_backed()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-introduce-vma_is_mm_backed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-introduce-vma_is_mm_backed.patch

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
Subject: mm/vma: introduce vma[_flags]_is_mm_backed()
Date: Sat, 03 Oct 2026 17:33:01 +0100

Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
mappings which are mm-managed and whose contents were placed there by core
mm's own fault path - rather than a custom ->fault handler - and which core
mm has not reserved the right to discard.

Mappings not managed by core mm do not fall into this category, as they are
populated by their owner, and nor of course does memory-mapped I/O.

We exclude fixed mappings as these have a layout core mm cannot assume
ordinary fault semantics over.

hugetlb mappings are fixed mappings, but core mm owns them entirely, so
they are explicitly carved out as mm-backed, as the MADV_DODUMP check
already does.

Droppable mappings are excluded as core mm has promised it may discard them
at any time.

Use this functionality to update the madvise MADV_DODUMP check to test for
this rather than open-coding it.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-30-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
---

 include/linux/mm.h |   50 +++++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c       |    4 +--
 2 files changed, 52 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-vma-introduce-vma_is_mm_backed
+++ a/include/linux/mm.h
@@ -1740,6 +1740,56 @@ static inline bool vma_can_merge(const s
 }
 
 /**
+ * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
+ * backed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * An mm-backed mapping is one managed by core mm (see
+ * vma_flags_is_mm_managed()) for which two further things are true:
+ *
+ * 1. Everything mapped was placed there by core mm's fault path (no custom
+ *    ->fault).
+ * 2. What is mapped stays there until it is zapped or unmapped by the user.
+ *
+ * These mappings are the only ones which can be sensibly locked, merged, dumped
+ * or be subject to uffd faulting, as all of these assume core mm and core mm
+ * alone manages these, and that the mappings will remain there.
+ *
+ * Returns: true if the flags imply an mm-backed mapping, otherwise false.
+ */
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	if (!vma_flags_is_mm_managed(flags) ||
+	    vma_flags_is_fixed_mapping(flags))
+		return false;
+	/* Core mm may discard droppable memory at any time. */
+	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
+}
+
+/**
+ * vma_is_mm_backed() - Is @vma backed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_backed() for details.
+ *
+ * Returns: true if the VMA is mm-backed, otherwise false.
+ */
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
+/**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
  *
--- a/mm/madvise.c~mm-vma-introduce-vma_is_mm_backed
+++ a/mm/madvise.c
@@ -1585,8 +1585,8 @@ static int madvise_vma_behavior(struct m
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Only mm-backed memory can be meaningfully dumped. */
+		if (!vma_is_mm_backed(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;
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
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
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
mm-vma-add-vma_is_mm_managed-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-not-mm-managed.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-mm-managed-mappings-may-not-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_mm_managed.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_mm_backed.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

