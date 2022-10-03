Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC55C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiJCVOZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJCVMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:12:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AC552454
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EBABB815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048DDC433D6;
        Mon,  3 Oct 2022 21:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831262;
        bh=rjBqBiwxeUQjEmsoMS07GAL3SYLeoYfkP6pMU3wEZMU=;
        h=Date:To:From:Subject:From;
        b=XBc9NWZSGyOvsy52d1taif2WqmYp5+pjVOJdwzOtS4awAjfYYYnIHFr/cPECqk5yX
         bPMYJ6IIpYVsB1bTQLaCqNAq8JSc9UZU6ssk9hjnSpJGKRv2Mj4wwp+Tflx1Vb0bl/
         vhrluG7C3uQmcjc4PcG1tP8m4o0Y9PYc0TsKJsWA=
Date:   Mon, 03 Oct 2022 14:07:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch removed from -mm tree
Message-Id: <20221003210742.048DDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc.c: rename check_free_page() to free_page_is_bad()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_alloc.c: rename check_free_page() to free_page_is_bad()
Date: Tue Sep 13 03:20:48 PM PDT 2022

The name "check_free_page()" provides no information regarding its return
value when the page is indeed found to be bad.

Renaming it to "free_page_is_bad()" makes it clear that a `true' return
value means the page was bad.

And make it return a bool, not an int.

[akpm@linux-foundation.org: don't use bool as int]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-rename-check_free_page-to-free_page_is_bad
+++ a/mm/page_alloc.c
@@ -1285,20 +1285,20 @@ static const char *page_bad_reason(struc
 	return bad_reason;
 }
 
-static void check_free_page_bad(struct page *page)
+static void free_page_is_bad_report(struct page *page)
 {
 	bad_page(page,
 		 page_bad_reason(page, PAGE_FLAGS_CHECK_AT_FREE));
 }
 
-static inline int check_free_page(struct page *page)
+static inline bool free_page_is_bad(struct page *page)
 {
 	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)))
-		return 0;
+		return false;
 
 	/* Something has gone sideways, find it */
-	check_free_page_bad(page);
-	return 1;
+	free_page_is_bad_report(page);
+	return true;
 }
 
 static int free_tail_pages_check(struct page *head_page, struct page *page)
@@ -1430,7 +1430,7 @@ static __always_inline bool free_pages_p
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-			if (unlikely(check_free_page(page + i))) {
+			if (unlikely(free_page_is_bad(page + i))) {
 				bad++;
 				continue;
 			}
@@ -1441,8 +1441,8 @@ static __always_inline bool free_pages_p
 		page->mapping = NULL;
 	if (memcg_kmem_enabled() && PageMemcgKmem(page))
 		__memcg_kmem_uncharge_page(page, order);
-	if (check_free)
-		bad += check_free_page(page);
+	if (check_free && free_page_is_bad(page))
+		bad++;
 	if (bad)
 		return false;
 
@@ -1504,7 +1504,7 @@ static bool free_pcp_prepare(struct page
 static bool bulkfree_pcp_prepare(struct page *page)
 {
 	if (debug_pagealloc_enabled_static())
-		return check_free_page(page);
+		return free_page_is_bad(page);
 	else
 		return false;
 }
@@ -1525,7 +1525,7 @@ static bool free_pcp_prepare(struct page
 
 static bool bulkfree_pcp_prepare(struct page *page)
 {
-	return check_free_page(page);
+	return free_page_is_bad(page);
 }
 #endif /* CONFIG_DEBUG_VM */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

