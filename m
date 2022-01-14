Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25FFC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiANWJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:29 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38186 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5A34CE24A5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E26C36AE9;
        Fri, 14 Jan 2022 22:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198166;
        bh=40c4mcsd+CSi9CF5yfo+Yph8I7LpRIVF0s/UlOw6gGk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ejdpZ9+z13uj5HtCRt7ST5GrC0YiQenHndbiTBn3DJL394SK19RMDi4uJgK+xlpqY
         atME2XC7A1FSPJ3pKupyTDm0TB10aw+lEt3igXOUnkGUFrYocSkXILblsxaFPSApUc
         Q0BJ+LEickDs1NU/GxKvfu6V8mM1J47HLrxXbqvY=
Date:   Fri, 14 Jan 2022 14:09:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fuqf0919@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 118/146] mm: fix some comment errors
Message-ID: <20220114220925.I63gWTTtt%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
