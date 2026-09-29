Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543B5339394
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 00:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641635; cv=none; b=FMaN0fc0HAz8nC24D4crNDkzZRbMUOYdNrYEuNWqqpx7URFvj2XYqNbcjl0eFfPs75/jWo1CBQ9JtTtkJ/Vvs2DhHofvm4cu9cCqj0iPeIFkpiBfQhrulMA6PLu0ISUed4vXXDr4q9zamV8ks7URQ+lpOkJLzgiaQhOyrDRiL9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641635; c=relaxed/simple;
	bh=YdtmpTsqHeMCDokXrxSawYWHzD3k0GBjClyyHakCSH8=;
	h=Date:To:From:Subject:Message-Id; b=ict3FuFHEKvtfSt7XAXY43WluodiMxFenZY71uEj+nNYAVMAVH6NPikt0axIPuhWLTMQcdQq5VPtxC8J9Ca7btNEG7ZCWjuVW6wshsxf2mZzBhDxnsbdn/+5T0+4qGdNz4pICh0qn9AMbyenD9ayRXzd6mkSp5mkVnYDFQOVJSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uk0Z+7Fa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uk0Z+7Fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC001F00893;
	Tue, 29 Sep 2026 00:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790641632;
	bh=s9vbok1Aay4g8kwxWOlSFfLCFh7n95xshKCa0uhETPc=;
	h=Date:To:From:Subject;
	b=Uk0Z+7Faqw8e27Ob6mhJ8uATyRa6/aHISj2U3Vg6XGkt9zkRfCarrV2VPpQ7DLeBk
	 aoVqtLCp23wKaIWCUr6zvFGKMyDKRBCKvalXEZsdmi8p1hqDKSfZmL47XHWGrQiFhe
	 FvrH2UIf9/IItlCvPACDXWazx3OLw8OFeyrWw1mI=
Date: Mon, 28 Sep 2026 17:27:12 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,gregkh@linuxfoundation.org,david@kernel.org,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch added to mm-hotfixes-unstable branch
Message-Id: <20260929002712.AAC001F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero correctly
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero correctly
Date: Thu, 24 Sep 2026 15:48:24 +0100

Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
MAP_SHARED gets you true anonymous memory (albeit in a VMA with non-NULL
vma->vm_file).

This is a by-product of MAP_PRIVATE-/dev/zero being how anonymous memory
was mapped in Linux's distant past.

It happens because mmap_zero_prepare() gates on VMA_SHARED_BIT and when
mapping a read-only file MAP_SHARED, do_mmap() clears VMA_SHARED_BIT and
VMA_MAYWRITE_BIT.

The gating is incorrect - the (poorly named) VMA_MAYSHARE_BIT flag exists
explicitly to tell you if something was originally mapped MAP_SHARED.

So the fix is simple - gate on this instead.

This isn't exactly a common use case, but it's unexpected behaviour which
now causes an assert if CONFIG_DEBUG_VM is set.

While this bug has existed since the dawn of time for linux (or at least
since 2.6.12), it hasn't caused issues in the past, so while it's
incorrect behaviour, it doesn't seem necessary to backport that far.

The mapping is now accounted at mmap time and can fail with -ENOMEM under
strict overcommit, and read faults allocate folios.  However this is
normal behaviour for a read-only shmem mapping.

Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
file-backed anon folios") is the first patch at which the debug assert
fires, so target that instead.

Link: https://lore.kernel.org/20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org
Fixes: 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/linux-mm/6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com/
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 drivers/char/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/mem.c~drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly
+++ a/drivers/char/mem.c
@@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_a
 #ifndef CONFIG_MMU
 	return -ENOSYS;
 #endif
-	if (vma_desc_test(desc, VMA_SHARED_BIT))
+	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
 		return shmem_zero_setup_desc(desc);
 
 	/*
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
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

