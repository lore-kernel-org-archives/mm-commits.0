Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701F5C3527D
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456795AbiDFB5v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241002AbiDEUpv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:45:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD240DA0A5
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 273FFB81FE5
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9CAC385A0;
        Tue,  5 Apr 2022 20:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189841;
        bh=OXKPOjRhdQaiunTKXjv2c0q4w3RjCe0hDMubmvzqG9I=;
        h=Date:To:From:Subject:From;
        b=wDMcF72pvTic9+pgigyfDlNX9Ymir+AfL4jyDtjHvfBDtzLYSD2R5TEGSO32Bqagz
         8zTF7T2DEmZCSr7re+s51wcgrjfQi2ExsehQc81B3OEZISnLxav4h0pI1vwU8MSPNn
         urCucGEmvj4lxWZMNFSyXtZ4BGQmPB+sMz12GlQg=
Date:   Tue, 05 Apr 2022 13:17:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-pte-markers-by-default.patch added to -mm tree
Message-Id: <20220405201721.AE9CAC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enable PTE markers by default
has been added to the -mm tree.  Its filename is
     mm-enable-pte-markers-by-default.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-enable-pte-markers-by-default.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-enable-pte-markers-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: enable PTE markers by default

Enable PTE markers by default.  On x86_64 it means it'll auto-enable
PTE_MARKER_UFFD_WP as well.

Link: https://lkml.kernel.org/r/20220405014929.15158-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/Kconfig~mm-enable-pte-markers-by-default
+++ a/mm/Kconfig
@@ -911,12 +911,14 @@ config ANON_VMA_NAME
 
 config PTE_MARKER
 	bool "Marker PTEs support"
+	default y
 
 	help
 	  Allows to create marker PTEs for file-backed memory.
 
 config PTE_MARKER_UFFD_WP
 	bool "Marker PTEs support for userfaultfd write protection"
+	default y
 	depends on PTE_MARKER && HAVE_ARCH_USERFAULTFD_WP
 
 	help
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

