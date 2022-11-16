Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBA6C43217
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiKPWop (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbiKPWoU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4109BF4B
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:44:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 918A1B81EE6
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F820C433C1;
        Wed, 16 Nov 2022 22:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638639;
        bh=gXNVSHgp+LAOVgV18hWsHYw8pvlUxuIMOqhhIns8Ixk=;
        h=Date:To:From:Subject:From;
        b=R5Q9SQ8+PyPwIk34+/64rY5aZs7OT9wIJIXOdLf2S0eT/KXkXHuN44bW/46shVmrb
         fzHLazxonwjEKne5TU4MbBmL/wrDIDPgBw+8sq+nm5emnM874uo9oLmaUI6f5p8sjS
         BBDfvrrXsxBIQw6HuFb5ShCiSxwvo2vi5tVGS8Yk=
Date:   Wed, 16 Nov 2022 14:43:58 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch added to mm-unstable branch
Message-Id: <20221116224359.2F820C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: extend FAULT_FLAG_UNSHARE support to anything in a COW mapping
has been added to the -mm mm-unstable branch.  Its filename is
     mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: extend FAULT_FLAG_UNSHARE support to anything in a COW mapping
Date: Wed, 16 Nov 2022 11:26:47 +0100

Extend FAULT_FLAG_UNSHARE to break COW on anything mapped into a
COW (i.e., private writable) mapping and adjust the documentation
accordingly.

FAULT_FLAG_UNSHARE will now also break COW when encountering the shared
zeropage, a pagecache page, a PFNMAP, ... inside a COW mapping, by
properly replacing the mapped page/pfn by a private copy (an exclusive
anonymous page).

Note that only do_wp_page() needs care: hugetlb_wp() already handles
FAULT_FLAG_UNSHARE correctly. wp_huge_pmd()/wp_huge_pud() also handles it
correctly, for example, splitting the huge zeropage on FAULT_FLAG_UNSHARE
such that we can handle FAULT_FLAG_UNSHARE on the PTE level.

This change is a requirement for reliable long-term R/O pinning in
COW mappings.

Link: https://lkml.kernel.org/r/20221116102659.70287-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 ++++----
 mm/memory.c              |    4 ----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping
+++ a/include/linux/mm_types.h
@@ -1036,9 +1036,9 @@ typedef struct {
  * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
  * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
  * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
- * @FAULT_FLAG_UNSHARE: The fault is an unsharing request to unshare (and mark
- *                      exclusive) a possibly shared anonymous page that is
- *                      mapped R/O.
+ * @FAULT_FLAG_UNSHARE: The fault is an unsharing request to break COW in a
+ *                      COW mapping, making sure that an exclusive anon page is
+ *                      mapped after the fault.
  * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
  *                        We should only access orig_pte if this flag set.
  *
@@ -1063,7 +1063,7 @@ typedef struct {
  *
  * The combination FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE is illegal.
  * FAULT_FLAG_UNSHARE is ignored and treated like an ordinary read fault when
- * no existing R/O-mapped anonymous page is encountered.
+ * applied to mappings that are not COW mappings.
  */
 enum fault_flag {
 	FAULT_FLAG_WRITE =		1 << 0,
--- a/mm/memory.c~mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping
+++ a/mm/memory.c
@@ -3432,10 +3432,6 @@ reuse:
 		}
 		wp_page_reuse(vmf);
 		return 0;
-	} else if (unshare) {
-		/* No anonymous page -> nothing to do. */
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return 0;
 	}
 copy:
 	/*
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch
selftests-vm-anon_cow-prepare-for-non-anonymous-cow-tests.patch
selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch
selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch
mm-add-early-fault_flag_unshare-consistency-checks.patch
mm-add-early-fault_flag_write-consistency-checks.patch
mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch
mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch
mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch
mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings.patch
rdma-umem-remove-foll_force-usage.patch
rdma-usnic-remove-foll_force-usage.patch
rdma-siw-remove-foll_force-usage.patch
media-videobuf-dma-sg-remove-foll_force-usage.patch
drm-etnaviv-remove-foll_force-usage.patch
media-pci-ivtv-remove-foll_force-usage.patch
mm-frame-vector-remove-foll_force-usage.patch
drm-exynos-remove-foll_force-usage.patch
rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch
habanalabs-remove-foll_force-usage.patch

