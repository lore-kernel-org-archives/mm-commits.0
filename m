Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DB8C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjBCGno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjBCGmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78F31BAC1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B727E61DB1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CA0C4339B;
        Fri,  3 Feb 2023 06:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406302;
        bh=0XkvzYa+ZHPv1fYcgOMG5Alu/8oEGw57D8NrMg+zv5c=;
        h=Date:To:From:Subject:From;
        b=gEvNg01Q0fevrwz0d5kOBJi3v2H+ufE3mvUc79sozkj07StwqRRK458S+TyLVmi5k
         phofYlyx3jsNh2vzBJPU8JZTaeyGUzPq8iBnGmAoT19g8mJlLZqlJQKJ7cP4GWxf4X
         1KI3h1gJkrRFgIGe8y1Z3CuNeiMYPBrBURWa3+aY=
Date:   Thu, 02 Feb 2023 22:38:21 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-reset-page-tags-properly-with-sampling.patch removed from -mm tree
Message-Id: <20230203063822.15CA0C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: reset page tags properly with sampling
has been removed from the -mm tree.  Its filename was
     kasan-reset-page-tags-properly-with-sampling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: reset page tags properly with sampling
Date: Tue, 24 Jan 2023 21:35:26 +0100

The implementation of page_alloc poisoning sampling assumed that
tag_clear_highpage resets page tags for __GFP_ZEROTAGS allocations. 
However, this is no longer the case since commit 70c248aca9e7 ("mm: kasan:
Skip unpoisoning of user pages").

This leads to kernel crashes when MTE-enabled userspace mappings are used
with Hardware Tag-Based KASAN enabled.

Reset page tags for __GFP_ZEROTAGS allocations in post_alloc_hook().

Also clarify and fix related comments.

[andreyknvl@google.com: update comment]
 Link: https://lkml.kernel.org/r/5dbd866714b4839069e2d8469ac45b60953db290.1674592780.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/24ea20c1b19c2b4b56cf9f5b354915f8dbccfc77.1674592496.git.andreyknvl@google.com
Fixes: 44383cef54c0 ("kasan: allow sampling page_alloc allocations for HW_TAGS")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Peter Collingbourne <pcc@google.com>
Tested-by: Peter Collingbourne <pcc@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~kasan-reset-page-tags-properly-with-sampling
+++ a/mm/page_alloc.c
@@ -2476,7 +2476,7 @@ inline void post_alloc_hook(struct page
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
 	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
-	bool reset_tags = !zero_tags;
+	bool reset_tags = true;
 	int i;
 
 	set_page_private(page, 0);
@@ -2503,7 +2503,7 @@ inline void post_alloc_hook(struct page
 	 * (which happens only when memory should be initialized as well).
 	 */
 	if (zero_tags) {
-		/* Initialize both memory and tags. */
+		/* Initialize both memory and memory tags. */
 		for (i = 0; i != 1 << order; ++i)
 			tag_clear_highpage(page + i);
 
@@ -2521,14 +2521,15 @@ inline void post_alloc_hook(struct page
 		} else {
 			/*
 			 * KASAN decided to exclude this allocation from being
-			 * poisoned due to sampling. Skip poisoning as well.
+			 * (un)poisoned due to sampling. Make KASAN skip
+			 * poisoning when the allocation is freed.
 			 */
 			SetPageSkipKASanPoison(page);
 		}
 	}
 	/*
-	 * If memory tags have not been set, reset the page tags to ensure
-	 * page_address() dereferencing does not fault.
+	 * If memory tags have not been set by KASAN, reset the page tags to
+	 * ensure page_address() dereferencing does not fault.
 	 */
 	if (reset_tags) {
 		for (i = 0; i != 1 << order; ++i)
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-fix-setting-next_slab_inited-in-init_stack_slab.patch
lib-stackdepot-put-functions-in-logical-order.patch
lib-stackdepot-use-pr_fmt-to-define-message-format.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init.patch
lib-stackdepot-rename-stack_depot_disable.patch
lib-stackdepot-annotate-init-and-early-init-functions.patch
lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch
lib-stackdepot-reorder-and-annotate-global-variables.patch
lib-stackdepot-rename-hash-table-constants-and-variables.patch
lib-stackdepot-rename-init_stack_slab.patch
lib-stackdepot-rename-slab-variables.patch
lib-stackdepot-rename-handle-and-slab-constants.patch
lib-stacktrace-drop-impossible-warn_on-for-depot_init_slab.patch
lib-stackdepot-annotate-depot_init_slab-and-depot_alloc_stack.patch
lib-stacktrace-kasan-kmsan-rework-extra_bits-interface.patch
lib-stackdepot-annotate-racy-slab_index-accesses.patch
lib-stackdepot-various-comments-clean-ups.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth.patch

