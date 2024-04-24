Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF891772F
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 20:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713991550; cv=none; b=ZYzSH9QcP6xA0flzjAtN6arBvFZpPZrd6wK4/FhBnRAza9jPCrPdHoI3YHzr6TliDNMm6aQn41D8iLVGKPm7fBteiSRd1gkuC0Ntv7uT88EicgwURtiLrsXJegBpquq7XCAKkhS79jgw8S8uRgAEjflOSuJvjLRFLvqJeEV76xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713991550; c=relaxed/simple;
	bh=ouVS++2YfFDhXPOhJd5PdLNPVjNVrNrKadtfXlvZ4b4=;
	h=Date:To:From:Subject:Message-Id; b=FbxKpC3aornUzR3dgTNE6zQwW/cHbaxVVdicnzYgX+t+ocLyUcfepKLv3qhFilQhdaThht0bO5vpqTvOd97HkI4mxFtzenC5Ne1IC0MVwZknllTaJ+EfPJUyx1iN2K/Qcc6XMD3pJah/JioiwSd+pkQov5eH6yHMj2F//bJYy64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/bc9FxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/bc9FxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B558BC113CD;
	Wed, 24 Apr 2024 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713991549;
	bh=ouVS++2YfFDhXPOhJd5PdLNPVjNVrNrKadtfXlvZ4b4=;
	h=Date:To:From:Subject:From;
	b=a/bc9FxK50E1uQ0PFSJFvhmmwO5+M5W5ykZ1j8QujClryISX5pL3vnQJDd43omhW/
	 Zvli/WSPdopXcKerA5u4kLXKpRMVSq2yGv5feupeTUaSOqfL2TvvVHVDJoyPhU8xhV
	 wcMc4fXyMHXiDisaSqoIe2BbqtLNm0u8M/AlZcuo=
Date: Wed, 24 Apr 2024 13:45:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,alex.williamson@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-non-hugetlb-large-folios-in-a-batch-fix.patch added to mm-unstable branch
Message-Id: <20240424204549.B558BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-free-non-hugetlb-large-folios-in-a-batch-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-non-hugetlb-large-folios-in-a-batch-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-non-hugetlb-large-folios-in-a-batch-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-free-non-hugetlb-large-folios-in-a-batch-fix
Date: Wed, 24 Apr 2024 11:20:28 -0400

On Fri, Apr 05, 2024 at 04:32:23PM +0100, Matthew Wilcox (Oracle) wrote:
> free_unref_folios() can now handle non-hugetlb large folios, so keep
> normal large folios in the batch.  hugetlb folios still need to be
> handled specially.  I believe that folios freed using put_pages_list()
> cannot be accounted to a memcg (or the small folios would trip the "page
> still charged to cgroup" warning), but put an assertion in to check that.

There's such user, iommu uses put_pages_list() to free IOMMU pgtables, and
they can be memcg accounted; since 2023 iommu_map switched to use
GFP_KERNEL_ACCOUNT.

I hit below panic when testing my local branch over mm-everthing when
running some VFIO workloads.

For this specific vfio use case, see 160912fc3d4a ("vfio/type1: account
iommu allocations").

I think we should remove the VM_BUG_ON_FOLIO() line, as the memcg will then
be properly taken care of later in free_pages_prepare().  Fixup attached at
the end that will fix this crash for me.

[   10.092411] kernel BUG at mm/swap.c:152!
[   10.092686] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   10.093034] CPU: 3 PID: 634 Comm: vfio-pci-mmap-t Tainted: G        W          6.9.0-rc4-peterx+ #2
[   10.093628] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   10.094361] RIP: 0010:put_pages_list+0x12b/0x150
[   10.094675] Code: 6d 08 48 81 c4 00 01 00 00 5b 5d c3 cc cc cc cc 48 c7 c6 f0 fd 9f 82 e8 63 e8 03 00 0f 0b 48 c7 c6 48 00 a0 82 e8 55 e8 03 00 <0f> 0b 48 c7 c6 28 fe 9f 82 e8 47f
[   10.095896] RSP: 0018:ffffc9000221bc50 EFLAGS: 00010282
[   10.096242] RAX: 0000000000000038 RBX: ffffea00042695c0 RCX: 0000000000000000
[   10.096707] RDX: 0000000000000001 RSI: 0000000000000027 RDI: 00000000ffffffff
[   10.097177] RBP: ffffc9000221bd68 R08: 0000000000000000 R09: 0000000000000003
[   10.097642] R10: ffffc9000221bb08 R11: ffffffff8335db48 R12: ffff8881070172c0
[   10.098113] R13: ffff888102fd0000 R14: ffff888107017210 R15: ffff888110a6c7c0
[   10.098586] FS:  0000000000000000(0000) GS:ffff888276a00000(0000) knlGS:0000000000000000
[   10.099117] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.099494] CR2: 00007f1910000000 CR3: 000000000323c006 CR4: 0000000000770ef0
[   10.099972] PKRU: 55555554
[   10.100154] Call Trace:
[   10.100321]  <TASK>
[   10.100466]  ? die+0x32/0x80
[   10.100666]  ? do_trap+0xd9/0x100
[   10.100897]  ? put_pages_list+0x12b/0x150
[   10.101168]  ? put_pages_list+0x12b/0x150
[   10.101434]  ? do_error_trap+0x81/0x110
[   10.101688]  ? put_pages_list+0x12b/0x150
[   10.101957]  ? exc_invalid_op+0x4c/0x60
[   10.102216]  ? put_pages_list+0x12b/0x150
[   10.102484]  ? asm_exc_invalid_op+0x16/0x20
[   10.102771]  ? put_pages_list+0x12b/0x150
[   10.103026]  ? 0xffffffff81000000
[   10.103246]  ? dma_pte_list_pagetables.isra.0+0x38/0xa0
[   10.103592]  ? dma_pte_list_pagetables.isra.0+0x9b/0xa0
[   10.103933]  ? dma_pte_clear_level+0x18c/0x1a0
[   10.104228]  ? domain_unmap+0x65/0x130
[   10.104481]  ? domain_unmap+0xe6/0x130
[   10.104735]  domain_exit+0x47/0x80
[   10.104968]  vfio_iommu_type1_detach_group+0x3f1/0x5f0
[   10.105308]  ? vfio_group_detach_container+0x3c/0x1a0
[   10.105644]  vfio_group_detach_container+0x60/0x1a0
[   10.105977]  vfio_group_fops_release+0x46/0x80
[   10.106274]  __fput+0x9a/0x2d0
[   10.106479]  task_work_run+0x55/0x90
[   10.106717]  do_exit+0x32f/0xb70
[   10.106945]  ? _raw_spin_unlock_irq+0x24/0x50
[   10.107237]  do_group_exit+0x32/0xa0
[   10.107481]  __x64_sys_exit_group+0x14/0x20
[   10.107760]  do_syscall_64+0x75/0x190
[   10.108007]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Link: https://lkml.kernel.org/r/ZikjPB0Dt5HA8-uL@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swap.c~mm-free-non-hugetlb-large-folios-in-a-batch-fix
+++ a/mm/swap.c
@@ -162,7 +162,6 @@ void put_pages_list(struct list_head *pa
 			free_huge_folio(folio);
 			continue;
 		}
-		VM_BUG_ON_FOLIO(folio_memcg(folio), folio);
 		/* LRU flag must be clear because it's passed using the lru */
 		if (folio_batch_add(&fbatch, folio) > 0)
 			continue;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-missing-hugetlb_lock-for-resv-uncharge.patch
mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
mm-always-initialise-folio-_deferred_list-fix.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-arch-provide-pud_pfn-fallback-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch
mm-free-non-hugetlb-large-folios-in-a-batch-fix.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

