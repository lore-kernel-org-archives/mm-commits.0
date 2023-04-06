Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2891C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbjDFCcF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbjDFCcC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D25283E1
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 961F764122
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99D7C433EF;
        Thu,  6 Apr 2023 02:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748320;
        bh=ukH1ILqpFWvowqoxrqcVCyfauoCChRoX7JcveQRdxdQ=;
        h=Date:To:From:Subject:From;
        b=TOmlA/JIgi5y0iYSvQcGVkhetGzpzO0+YcozAfQWJWyp9pxEjvowSAQk9QP+GoW58
         j1XHFFwnmgzkWnpp30i1d+x3hGXlcxi9MYD2iq5+1qvwom8BesYqIyaoGmOd273GxS
         +/cw/q/5PP9GEDwfHvovkxU4xektBf+bylawbt3c=
Date:   Wed, 05 Apr 2023 19:31:59 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        rppt@linux.vnet.ibm.com, pgofman@codeweavers.com,
        nadav.amit@gmail.com, david@redhat.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-uffd-uffd_feature_wp_unpopulated-fix.patch removed from -mm tree
Message-Id: <20230406023159.E99D7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-uffd-uffd_feature_wp_unpopulated-fix
has been removed from the -mm tree.  Its filename was
     mm-uffd-uffd_feature_wp_unpopulated-fix.patch

This patch was dropped because it was folded into mm-uffd-uffd_feature_wp_unpopulated.patch

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
@@ -1183,7 +1183,7 @@ static int hpage_collapse_scan_pmd(struc
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

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

