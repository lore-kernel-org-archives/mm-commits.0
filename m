Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83729C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 664F563217
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhKPFPU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhKPFN4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 00:13:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B4AC61BF9;
        Tue, 16 Nov 2021 05:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637039459;
        bh=snjeAmc3A2w84hjAzQZcuCSE5tdlxqPe2tES7V6pXsM=;
        h=Date:From:To:Subject:From;
        b=wnwjZhNqhQk8uBketnmcyWf548v5FZI+Na1khq0IXWGBnYQMiFtXGZKyJwvXaqFuU
         yI1ctQnMZicFYrXXLLSSxzph3BrVFRUWIvkrXP1l2pP6tm7LRFHsmN2DZPrlQ9URFT
         E8Fcwy7LgvwLQOpMobnVSunkWoIIzHTDieQDtqh4=
Date:   Mon, 15 Nov 2021 21:10:59 -0800
From:   akpm@linux-foundation.org
To:     fuqf0919@gmail.com, mm-commits@vger.kernel.org
Subject:  + writeback-fix-some-comment-errors.patch added to -mm
 tree
Message-ID: <20211116051059.p13Y4_SOC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some comment errors
has been added to the -mm tree.  Its filename is
     writeback-fix-some-comment-errors.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-fix-some-comment-errors.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-fix-some-comment-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1306,7 +1306,7 @@ static int khugepaged_scan_pmd(struct mm
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
@@ -1298,7 +1298,7 @@ static int __get_unpoison_page(struct pa
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

writeback-fix-some-comment-errors.patch

