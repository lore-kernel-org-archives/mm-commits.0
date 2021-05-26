Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427E2C47087
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 00:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18FA861284
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 00:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhEZASJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 20:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhEZASJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 20:18:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AE4561028;
        Wed, 26 May 2021 00:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621988197;
        bh=QYK6ZuxMHuSXdyrRlA7CaN1cXZ32AnNH28rFDvcVRic=;
        h=Date:From:To:Subject:From;
        b=E3qZVd0D3PEPYK8V/9MPo1CYZy8nUbuIECXDUr1TSqPk/j4ihMeVqHZ/aCg++Pq+/
         EfVBk1R//f573TQTjZjErRdXW1sBO4T4n3JcEbMTh1Pgc+zLkP1aRmWxh9WSB0jNBx
         Lo7G42j2r6JGAZR5kyzvG+FEDpiX3bQKIUWxAJyA=
Date:   Tue, 25 May 2021 17:16:36 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        almasrymina@google.com, apopple@nvidia.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  +
 mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch added to -mm
 tree
Message-ID: <20210526001636.dLunQ0Kl0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix
has been added to the -mm tree.  Its filename is
     mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix

fix it for "mm: Device exclusive memory access".

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix
+++ a/mm/memory.c
@@ -850,8 +850,8 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 * exclusive entries currently only support private writable
 		 * (ie. COW) mappings.
 		 */
-		VM_BUG_ON(!is_cow_mapping(vma->vm_flags));
-		if (try_restore_exclusive_pte(src_mm, src_pte, vma, addr))
+		VM_BUG_ON(!is_cow_mapping(dst_vma->vm_flags));
+		if (try_restore_exclusive_pte(src_mm, src_pte, dst_vma, addr))
 			return -EBUSY;
 		return -ENOENT;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-pre.patch
linux-next-post.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

