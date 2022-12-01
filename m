Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D208BC4708D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiLAAGp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiLAAEk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A519076A
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 762BE61E6B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48C2C433B5;
        Thu,  1 Dec 2022 00:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852931;
        bh=7zsOFIzFIjNVompvJEkh267jICarEaqRZQKl+yaRAQg=;
        h=Date:To:From:Subject:From;
        b=VIuxvROHDpy3ML2wJDhi2TmhKGS/WjcpxslfbgUfYuzqfuKkfzTVZlUOG2rlMlTVl
         LUmnEmwwe7hX/8PtbyuRsQoPrl3O/ZkXku89WUu9NHSK6Kg92gFiofd2d3VF8Tp6eO
         TT7Ul39SFz6927/ReIxCWrW6ZcF8qNpzSlgSxUwc=
Date:   Wed, 30 Nov 2022 16:02:11 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch removed from -mm tree
Message-Id: <20221201000211.A48C2C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: extend FAULT_FLAG_UNSHARE support to anything in a COW mapping
has been removed from the -mm tree.  Its filename was
     mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 ++++----
 mm/memory.c              |    4 ----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping
+++ a/include/linux/mm_types.h
@@ -1039,9 +1039,9 @@ typedef struct {
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
@@ -1066,7 +1066,7 @@ typedef struct {
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
@@ -3431,10 +3431,6 @@ reuse:
 		}
 		wp_page_reuse(vmf);
 		return VM_FAULT_WRITE;
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

