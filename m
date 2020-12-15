Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78771C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52277224D4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgLODF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgLODFF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:05 -0500
Date:   Mon, 14 Dec 2020 19:04:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001490;
        bh=jpJ2IxBdcRv5YSRw4N/68PixbFZCYKiTWOz78t7Hobg=;
        h=From:To:Subject:In-Reply-To:From;
        b=oWYyVWTO1Lk3mgo52vIAM60vBXa23blrKHbpxlpbRwjotcG8jnsvCLhDjqGfz5yEO
         LRfqyc+lGq9KxTOiZHSZiY9Bc5tVMBFVa/l6GXNEP1lqKgAQDz6tbeRXyPD/OxX7lH
         wPNKLsM0r1tccGuSbu98QfLf2SWB/1l4hOYBBf10=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        georgi.djakov@linaro.org, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, lmark@codeaurora.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 027/200] mm/page_owner: record timestamp and pid
Message-ID: <20201215030449.bnJPu0SKj%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Mark <lmark@codeaurora.org>
Subject: mm/page_owner: record timestamp and pid

Collect the time for each allocation recorded in page owner so that
allocation "surges" can be measured.

Record the pid for each allocation recorded in page owner so that the
source of allocation "surges" can be better identified.

The above is very useful when doing memory analysis.  On a crash for
example, we can get this information from kdump (or ramdump) and parse it
to figure out memory allocation problems.

Please note that on x86_64 this increases the size of struct page_owner
from 16 bytes to 32.

Vlastimil: it's not a functionality intended for production, so unless
somebody says they need to enable page_owner for debugging and this
increase prevents them from fitting into available memory, let's not
complicate things with making this optional.

[lmark@codeaurora.org: v3]
  Link: https://lkml.kernel.org/r/20201210160357.27779-1-georgi.djakov@linaro.org
Link: https://lkml.kernel.org/r/20201209125153.10533-1-georgi.djakov@linaro.org
Signed-off-by: Liam Mark <lmark@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |   12 ++++++------
 mm/page_owner.c                 |   17 +++++++++++++----
 2 files changed, 19 insertions(+), 10 deletions(-)

--- a/Documentation/vm/page_owner.rst~mm-page_owner-record-timestamp-and-pid
+++ a/Documentation/vm/page_owner.rst
@@ -41,17 +41,17 @@ size change due to this facility.
 - Without page owner::
 
    text    data     bss     dec     hex filename
-   40662   1493     644   42799    a72f mm/page_alloc.o
+   48392   2333     644   51369    c8a9 mm/page_alloc.o
 
 - With page owner::
 
    text    data     bss     dec     hex filename
-   40892   1493     644   43029    a815 mm/page_alloc.o
-   1427      24       8    1459     5b3 mm/page_ext.o
-   2722      50       0    2772     ad4 mm/page_owner.o
+   48800   2445     644   51889    cab1 mm/page_alloc.o
+   6574     108      29    6711    1a37 mm/page_owner.o
+   1025       8       8    1041     411 mm/page_ext.o
 
-Although, roughly, 4 KB code is added in total, page_alloc.o increase by
-230 bytes and only half of it is in hotpath. Building the kernel with
+Although, roughly, 8 KB code is added in total, page_alloc.o increase by
+520 bytes and less than half of it is in hotpath. Building the kernel with
 page owner and turning it on if needed would be great option to debug
 kernel memory problem.
 
--- a/mm/page_owner.c~mm-page_owner-record-timestamp-and-pid
+++ a/mm/page_owner.c
@@ -10,6 +10,7 @@
 #include <linux/migrate.h>
 #include <linux/stackdepot.h>
 #include <linux/seq_file.h>
+#include <linux/sched/clock.h>
 
 #include "internal.h"
 
@@ -25,6 +26,8 @@ struct page_owner {
 	gfp_t gfp_mask;
 	depot_stack_handle_t handle;
 	depot_stack_handle_t free_handle;
+	u64 ts_nsec;
+	pid_t pid;
 };
 
 static bool page_owner_enabled = false;
@@ -172,6 +175,8 @@ static inline void __set_page_owner_hand
 		page_owner->order = order;
 		page_owner->gfp_mask = gfp_mask;
 		page_owner->last_migrate_reason = -1;
+		page_owner->pid = current->pid;
+		page_owner->ts_nsec = local_clock();
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 
@@ -236,6 +241,8 @@ void __copy_page_owner(struct page *oldp
 	new_page_owner->last_migrate_reason =
 		old_page_owner->last_migrate_reason;
 	new_page_owner->handle = old_page_owner->handle;
+	new_page_owner->pid = old_page_owner->pid;
+	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
 
 	/*
 	 * We don't clear the bit on the oldpage as it's going to be freed
@@ -349,9 +356,10 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = snprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg)\n",
+			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
-			&page_owner->gfp_mask);
+			&page_owner->gfp_mask, page_owner->pid,
+			page_owner->ts_nsec);
 
 	if (ret >= count)
 		goto err;
@@ -427,8 +435,9 @@ void __dump_page_owner(struct page *page
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg)\n",
-		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask);
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, ts %llu\n",
+		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
+		 page_owner->pid, page_owner->ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle) {
_
