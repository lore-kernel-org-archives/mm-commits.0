Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E53C4743D
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B5A46120A
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFDUTl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 16:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhFDUTl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 16:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26D9A61153;
        Fri,  4 Jun 2021 20:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622837859;
        bh=dQ0M99GIW6NMi/HBr5U3VmqjDnn2y3iB9mkLLHC6SUk=;
        h=Date:From:To:Subject:From;
        b=HDYZAkmlpJSkr09SbeEOHkg/dfGEmMb7x2TSgJZdR02ZQkFQnMwfB4pwkgosRKPEp
         xzUxL8O7K7pN7/SVPl8tdMpaqq/uNUeARyLphYIIcDorqPu9wXoj/Vv1W20GpulP2P
         QxE9zBqPG7fdffakxA8aI6wmcKltyIxZYGYiXLzk=
Date:   Fri, 04 Jun 2021 13:17:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  + mm-nommu-unexport-do_munmap.patch added to -mm tree
Message-ID: <20210604201738.vns1e4aLA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: unexport do_munmap()
has been added to the -mm tree.  Its filename is
     mm-nommu-unexport-do_munmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-nommu-unexport-do_munmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-nommu-unexport-do_munmap.patch

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
Subject: mm/nommu: unexport do_munmap()

do_munmap() does not take the mmap_write_lock().  vm_munmap() should be
used instead.

Link: https://lkml.kernel.org/r/20210604194002.648037-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/nommu.c~mm-nommu-unexport-do_munmap
+++ a/mm/nommu.c
@@ -1501,7 +1501,6 @@ erase_whole_vma:
 	delete_vma(mm, vma);
 	return 0;
 }
-EXPORT_SYMBOL(do_munmap);
 
 int vm_munmap(unsigned long addr, size_t len)
 {
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
mm-nommu-unexport-do_munmap.patch

