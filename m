Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED8DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377885AbiATV2J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58816 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377882AbiATV2J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8173B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AF5C340E0;
        Thu, 20 Jan 2022 21:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714086;
        bh=7j/XdfqzFjJOSXNFwQ1J8umPtcDVLvpY977bFWTSCsE=;
        h=Date:From:To:Subject:From;
        b=0+IgPNZWo3p+3rMO1TvIT1O0WIO6wWhXqQ/918WsDW79xLtKezUBc7Tb4MxcOTITv
         CVQRkPd340AU7w4Vaa49ZydGOC0ZB2kzEPWxnDzOnyB9xoQ/IAUwGpFQzZOa8bDUZM
         EWLqX3DG7VPWVhKr9AzXf5syzoYc58Xv8PdCpVrk=
Date:   Thu, 20 Jan 2022 13:28:06 -0800
From:   akpm@linux-foundation.org
To:     fuqf0919@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] writeback-fix-some-comment-errors.patch removed
 from -mm tree
Message-ID: <20220120212806.-TaT_PkKz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some comment errors
has been removed from the -mm tree.  Its filename was
     writeback-fix-some-comment-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Quanfa Fu <fuqf0919@gmail.com>
Subject: mm: fix some comment errors

Link: https://lkml.kernel.org/r/20211101040208.460810-1-fuqf0919@gmail.com
Signed-off-by: Quanfa Fu <fuqf0919@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c     |    2 +-
 mm/memory-failure.c |    2 +-
 mm/slab_common.c    |    2 +-
 mm/swap.c           |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~writeback-fix-some-comment-errors
+++ a/mm/khugepaged.c
@@ -1303,7 +1303,7 @@ static int khugepaged_scan_pmd(struct mm
 		/*
 		 * Record which node the original page is from and save this
 		 * information to khugepaged_node_load[].
-		 * Khupaged will allocate hugepage from the node has the max
+		 * Khugepaged will allocate hugepage from the node has the max
 		 * hit record.
 		 */
 		node = page_to_nid(page);
--- a/mm/memory-failure.c~writeback-fix-some-comment-errors
+++ a/mm/memory-failure.c
@@ -1306,7 +1306,7 @@ static int __get_unpoison_page(struct pa
  *
  * get_hwpoison_page() takes a page refcount of an error page to handle memory
  * error on it, after checking that the error page is in a well-defined state
- * (defined as a page-type we can successfully handle the memor error on it,
+ * (defined as a page-type we can successfully handle the memory error on it,
  * such as LRU page and hugetlb page).
  *
  * Memory error handling could be triggered at any time on any type of page,
--- a/mm/slab_common.c~writeback-fix-some-comment-errors
+++ a/mm/slab_common.c
@@ -819,7 +819,7 @@ void __init setup_kmalloc_cache_index_ta
 
 	if (KMALLOC_MIN_SIZE >= 64) {
 		/*
-		 * The 96 byte size cache is not used if the alignment
+		 * The 96 byte sized cache is not used if the alignment
 		 * is 64 byte.
 		 */
 		for (i = 64 + 8; i <= 96; i += 8)
--- a/mm/swap.c~writeback-fix-some-comment-errors
+++ a/mm/swap.c
@@ -882,7 +882,7 @@ void lru_cache_disable(void)
 	 * all online CPUs so any calls of lru_cache_disabled wrapped by
 	 * local_lock or preemption disabled would be ordered by that.
 	 * The atomic operation doesn't need to have stronger ordering
-	 * requirements because that is enforeced by the scheduling
+	 * requirements because that is enforced by the scheduling
 	 * guarantees.
 	 */
 	__lru_add_drain_all(true);
_

Patches currently in -mm which might be from fuqf0919@gmail.com are


