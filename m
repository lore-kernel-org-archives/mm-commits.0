Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12436C2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 20:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E163261177
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 20:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhEVUQT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 16:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhEVUQS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 16:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4B2D61164;
        Sat, 22 May 2021 20:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621714492;
        bh=Q8uvd0ecPb/NLnZkPmOQ0evR/5v0RlOhm/ZkQ2xcnT4=;
        h=Date:From:To:Subject:From;
        b=Cl6h/c8buhs1Mqb76UHn7weB4w0m8WLxD4yxbe+osuG6Zqqqr/rfH1VNkoAXOBty0
         DwyQkb3sUx1auc00a7jYsWzoathlXMfbaJzmQk8MR1YS28tityYC/RNU1Swr2s6YSy
         lC8HMMHm2mcTNFPpRfyztbTNi2YetBI2tdO6k9o4=
Date:   Sat, 22 May 2021 13:14:51 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma.patch
 added to -mm tree
Message-ID: <20210522201451.BDcyLlzmK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/kvm/book3s: use vma_lookup() in kvmppc_hv_setup_htab_rma()
has been added to the -mm tree.  Its filename is
     arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/powerpc/kvm/book3s: use vma_lookup() in kvmppc_hv_setup_htab_rma()

Using vma_lookup() removes the requirement to check if the address is
within the returned vma.  The code is easier to understand and more
compact.

Link: https://lkml.kernel.org/r/20210521174745.2219620-7-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c~arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma
+++ a/arch/powerpc/kvm/book3s_hv.c
@@ -4759,8 +4759,8 @@ static int kvmppc_hv_setup_htab_rma(stru
 	/* Look up the VMA for the start of this memory slot */
 	hva = memslot->userspace_addr;
 	mmap_read_lock(kvm->mm);
-	vma = find_vma(kvm->mm, hva);
-	if (!vma || vma->vm_start > hva || (vma->vm_flags & VM_IO))
+	vma = vma_lookup(kvm->mm, hva);
+	if (!vma || (vma->vm_flags & VM_IO))
 		goto up_out;
 
 	psize = vma_kernel_pagesize(vma);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mm-mmap-introduce-unlock_range-for-code-cleanup.patch
mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap.patch
mm-add-vma_lookup-update-find_vma_intersection-comments.patch
drm-i915-selftests-use-vma_lookup-in-__igt_mmap.patch
arch-arc-kernel-troubleshoot-use-vma_lookup-instead-of-find_vma.patch
arch-arm64-kvm-use-vma_lookup-instead-of-find_vma_intersection.patch
arch-powerpc-kvm-book3s_hv_uvmem-use-vma_lookup-instead-of-find_vma_intersection.patch
arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma.patch
arch-mips-kernel-traps-use-vma_lookup-instead-of-find_vma.patch
arch-m68k-kernel-sys_m68k-use-vma_lookup-in-sys_cacheflush.patch
x86-sgx-use-vma_lookup-in-sgx_encl_find.patch
virt-kvm-use-vma_lookup-instead-of-find_vma_intersection.patch
vfio-use-vma_lookup-instead-of-find_vma_intersection.patch
net-ipv5-tcp-use-vma_lookup-in-tcp_zerocopy_receive.patch
drm-amdgpu-use-vma_lookup-in-amdgpu_ttm_tt_get_user_pages.patch
media-videobuf2-use-vma_lookup-in-get_vaddr_frames.patch
misc-sgi-gru-grufault-use-vma_lookup-in-gru_find_vma.patch
kernel-events-uprobes-use-vma_lookup-in-find_active_uprobe.patch
lib-test_hmm-use-vma_lookup-in-dmirror_migrate.patch
mm-ksm-use-vma_lookup-in-find_mergeable_vma.patch
mm-migrate-use-vma_lookup-in-do_pages_stat_array.patch
mm-mremap-use-vma_lookup-in-vma_to_resize.patch
mm-memoryc-use-vma_lookup-in-__access_remote_vm.patch
mm-mempolicy-use-vma_lookup-in-__access_remote_vm.patch

