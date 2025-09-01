Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F97C32A817
	for <mm-commits@vger.kernel.org>; Mon,  1 Sep 2025 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756752138; cv=none; b=jnRzGOjjnoD1E3K0/jz/soW6VlW8iahLRgnxG1VwkuF9+a5DZ9buZYfej2Yi2FgDxYMq4Y10/Ys65Y+raSxKu/VhS5YBwcbGOTIiWVkGqhyS63UsCYcQHI8ZDXnIR0V21NnbHAthcJNx46ROkykp0Z3oPo5gTvTkbKLhDJN1pXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756752138; c=relaxed/simple;
	bh=BxsUjvcsbclMoFS/NJtYNKqZ9tLHRGw+KrzSVBniwl0=;
	h=Date:To:From:Subject:Message-Id; b=SLrE2ICDts4lGA3aV/n7r7x5FWJETvWWIOMhKM2ZFl70oq3iqDtHjiPeYwQY+b9412phtsfJFUlXMbOFXOYD94fa5ACtpLWS1UJAl+dHoeL278O2MXEhy7SAzZpcA818RJIUR07BaYlf6DxIa0c5Hv9jfvJz3F8tz7WvFBnvph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kCyk0cKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kCyk0cKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044AFC4CEF0;
	Mon,  1 Sep 2025 18:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756752138;
	bh=BxsUjvcsbclMoFS/NJtYNKqZ9tLHRGw+KrzSVBniwl0=;
	h=Date:To:From:Subject:From;
	b=kCyk0cKTwrtlIcOpPKHaDd6gYIZ8q3lmxpzr7G+JkUKdKrSHIVO4L+xMd2BusX5Fk
	 K1dKpVKHFo3kiyPUDD0o/z+2sJjpx9dD5ejwPlnkjNel6o/ZS/khn8um2Wm8bEuP2L
	 Lb0ju4fWvyojEQswl679RQbMslaw8QiZcar8Wr5Y=
Date: Mon, 01 Sep 2025 11:42:17 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,Jason@zx2c4.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch added to mm-new branch
Message-Id: <20250901184218.044AFC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
has been added to the -mm mm-new branch.  Its filename is
     wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Hildenbrand <david@redhat.com>
Subject: wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Date: Mon, 1 Sep 2025 17:03:26 +0200

It's no longer user-selectable (and the default was already "y"), so let's
just drop it.

It was never really relevant to the wireguard selftests either way.

Link: https://lkml.kernel.org/r/20250901150359.867252-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/wireguard/qemu/kernel.config |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/wireguard/qemu/kernel.config~wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config
+++ a/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
 CONFIG_FUTEX=y
 CONFIG_SHMEM=y
 CONFIG_SLUB=y
-CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_SMP=y
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
mm-migrate-remove-migratepage_unmap-fix.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch
mm-stop-making-sparsemem_vmemmap-user-selectable.patch
arm64-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
s390-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
x86-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch
mm-page_alloc-reject-unreasonable-folio-compound-page-sizes-in-alloc_contig_range_noprof.patch
mm-memremap-reject-unreasonable-folio-compound-page-sizes-in-memremap_pages.patch
mm-hugetlb-check-for-unreasonable-folio-sizes-when-registering-hstate.patch
mm-mm_init-make-memmap_init_compound-look-more-like-prep_compound_page.patch
mm-sanity-check-maximum-folio-size-in-folio_set_order.patch
mm-limit-folio-compound-page-sizes-in-problematic-kernel-configs.patch
mm-simplify-folio_page-and-folio_page_idx.patch
mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch
mm-mm-percpu-km-drop-nth_page-usage-within-single-allocation.patch
fs-hugetlbfs-remove-nth_page-usage-within-folio-in-adjust_range_hwpoison.patch
fs-hugetlbfs-cleanup-folio-in-adjust_range_hwpoison.patch
mm-pagewalk-drop-nth_page-usage-within-folio-in-folio_walk_start.patch
mm-gup-drop-nth_page-usage-within-folio-when-recording-subpages.patch
mm-gup-remove-record_subpages.patch
io_uring-zcrx-remove-nth_page-usage-within-folio.patch
mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages.patch
mm-cma-refuse-handing-out-non-contiguous-page-ranges.patch
dma-remap-drop-nth_page-in-dma_common_contiguous_remap.patch
scatterlist-disallow-non-contigous-page-ranges-in-a-single-sg-entry.patch
ata-libata-sff-drop-nth_page-usage-within-sg-entry.patch
drm-i915-gem-drop-nth_page-usage-within-sg-entry.patch
mspro_block-drop-nth_page-usage-within-sg-entry.patch
memstick-drop-nth_page-usage-within-sg-entry.patch
mmc-drop-nth_page-usage-within-sg-entry.patch
scsi-scsi_lib-drop-nth_page-usage-within-sg-entry.patch
scsi-sg-drop-nth_page-usage-within-sg-entry.patch
vfio-pci-drop-nth_page-usage-within-sg-entry.patch
crypto-remove-nth_page-usage-within-sg-entry.patch
mm-gup-drop-nth_page-usage-in-unpin_user_page_range_dirty_lock.patch
kfence-drop-nth_page-usage.patch
block-update-comment-of-struct-bio_vec-regarding-nth_page.patch
mm-remove-nth_page.patch

