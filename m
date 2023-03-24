Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDBBC6FD1C
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 19:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjCXTXw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjCXTXv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 15:23:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805ECEC70
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 12:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7604D62BDF
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 19:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00D3C4339C;
        Fri, 24 Mar 2023 19:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679685720;
        bh=opXDcG65ZjJEb6gSQC+mgtkJGJHyr8oIE4R59/zENDo=;
        h=Date:To:From:Subject:From;
        b=A7rRSmki7ScUblpWG26RcH4bXzDaKuzYW4LAmteOF8Zw2ZZThNycJ/T54ixSBROPb
         FawVsnGsNmkoUfywVp2b5yD1NHGIdNWi5ZmnnKGeGYDCl/ZM7FBeAixBxFt/BCkIRd
         HTNAMKzES3R3p5rJg8O8HpnyyQsObADPvh1D6+Zs=
Date:   Fri, 24 Mar 2023 12:22:00 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        rppt@linux.vnet.ibm.com, pgofman@codeweavers.com,
        nadav.amit@gmail.com, david@redhat.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-uffd_feature_wp_unpopulated-fix.patch added to mm-unstable branch
Message-Id: <20230324192200.C00D3C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-uffd-uffd_feature_wp_unpopulated-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-uffd-uffd_feature_wp_unpopulated-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-uffd_feature_wp_unpopulated-fix.patch

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
Subject: mm-uffd-uffd_feature_wp_unpopulated-fix
Date: Tue, 21 Mar 2023 16:09:26 -0400

Two comment changes suggested by David, and also a oneliner fix to
khugepaged (to bail out anon thp collapsing when seeing pte markers).  

Link: https://lkml.kernel.org/r/ZB2/8jPhD3fpx5U8@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Paul Gofman <pgofman@codeweavers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/userfaultfd.rst |    2 +-
 mm/khugepaged.c                              |    2 +-
 mm/mprotect.c                                |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~mm-uffd-uffd_feature_wp_unpopulated-fix
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -226,7 +226,7 @@ For anonymous memory, ``ioctl(UFFDIO_WRI
 (e.g. when pages are missing and not populated).  For file-backed memories
 like shmem and hugetlbfs, none ptes will be write protected just like a
 present pte.  In other words, there will be a userfaultfd write fault
-message generated when writting to a missing page on file typed memories,
+message generated when writing to a missing page on file typed memories,
 as long as the page range was write-protected before.  Such a message will
 not be generated on anonymous memories by default.
 
--- a/mm/khugepaged.c~mm-uffd-uffd_feature_wp_unpopulated-fix
+++ a/mm/khugepaged.c
@@ -1282,7 +1282,7 @@ static int hpage_collapse_scan_pmd(struc
 				 * enabled swap entries.  Please see
 				 * comment below for pte_uffd_wp().
 				 */
-				if (pte_swp_uffd_wp(pteval)) {
+				if (pte_swp_uffd_wp_any(pteval)) {
 					result = SCAN_PTE_UFFD_WP;
 					goto out_unmap;
 				}
--- a/mm/mprotect.c~mm-uffd-uffd_feature_wp_unpopulated-fix
+++ a/mm/mprotect.c
@@ -329,8 +329,8 @@ static inline int pmd_none_or_clear_bad_
 }
 
 /*
- * Return true if we want to split huge thps in change protection
- * procedure, false otherwise.
+ * Return true if we want to split THPs into PTE mappings in change
+ * protection procedure, false otherwise.
  */
 static inline bool
 pgtable_split_needed(struct vm_area_struct *vma, unsigned long cp_flags)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

