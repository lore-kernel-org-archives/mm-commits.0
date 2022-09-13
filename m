Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57ACCECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 22:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiIMWkH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIMWkG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 18:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496794D26E
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 15:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5C8661277
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 22:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23939C433C1;
        Tue, 13 Sep 2022 22:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663108804;
        bh=mrT9G8nwRHpU3Wsr15c8QAtX3p1haMojKWya+ClegVs=;
        h=Date:To:From:Subject:From;
        b=xRjzYOCV18FcmaHV06XqcwG7GDaeeBkSPHM+x4aguRZ/jHe9k6T0TEmsSqnDOs5Bp
         X9ZFlcA2TJ7MAL9E/Rax7CbA7/yPFx4G2GRJqb9iN3w01W7NXQM0Ow5Zd+/VOR69/l
         sZ3VlgNMBZbFU8dDiscUI8ZCy2m5uLRWSMV8d/2Q=
Date:   Tue, 13 Sep 2022 15:40:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch added to mm-unstable branch
Message-Id: <20220913224004.23939C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: rename check_free_page() to free_page_is_bad()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_alloc.c: rename check_free_page() to free_page_is_bad()
Date: Tue Sep 13 03:20:48 PM PDT 2022

The name "check_free_page()" provides no information regarding its return
value when the page is indeed found to be bad.

Renaming it to "free_page_is_bad()" makes it clear that a `true' return
value means the page was bad.

And make it return a bool, not an int.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-rename-check_free_page-to-free_page_is_bad
+++ a/mm/page_alloc.c
@@ -1290,20 +1290,20 @@ static const char *page_bad_reason(struc
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
@@ -1436,7 +1436,7 @@ static __always_inline bool free_pages_p
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-			if (unlikely(check_free_page(page + i))) {
+			if (unlikely(free_page_is_bad(page + i))) {
 				bad++;
 				continue;
 			}
@@ -1448,7 +1448,7 @@ static __always_inline bool free_pages_p
 	if (memcg_kmem_enabled() && PageMemcgKmem(page))
 		__memcg_kmem_uncharge_page(page, order);
 	if (check_free)
-		bad += check_free_page(page);
+		bad += free_page_is_bad(page);
 	if (bad)
 		return false;
 
@@ -1510,7 +1510,7 @@ static bool free_pcp_prepare(struct page
 static bool bulkfree_pcp_prepare(struct page *page)
 {
 	if (debug_pagealloc_enabled_static())
-		return check_free_page(page);
+		return free_page_is_bad(page);
 	else
 		return false;
 }
@@ -1531,7 +1531,7 @@ static bool free_pcp_prepare(struct page
 
 static bool bulkfree_pcp_prepare(struct page *page)
 {
-	return check_free_page(page);
+	return free_page_is_bad(page);
 }
 #endif /* CONFIG_DEBUG_VM */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch

