Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FBFC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B23F761CA0
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhGFTXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231764AbhGFTXF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6709C61C9A;
        Tue,  6 Jul 2021 19:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599226;
        bh=DE6UY5LxoE10cDeqc7yPcpDqgwHOfdkGqKi1nb7ZN4c=;
        h=Date:From:To:Subject:From;
        b=UiVEUm5KWa32HfJOLsqHogxmhb6l3amyoN6n7E6uxMbw7O6z1fqcJajKJGwWf8qBu
         DZYpRFn8LP7S9lqEE2Bw7kh8ya9eNweoYxnwyDeW+j33C1maTK9WOavaC/+Zow97uK
         Vzc+uURDY+uDtUqbm5QfQeIWm4KqxI/lt8DAP51c=
Date:   Tue, 06 Jul 2021 12:20:26 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, georgi.djakov@linaro.org, lmark@codeaurora.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-memory_hotplug-rate-limit-page-migration-warnings.patch removed from -mm
 tree
Message-ID: <20210706192026.fsknvtRNv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: rate limit page migration warnings
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-rate-limit-page-migration-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Mark <lmark@codeaurora.org>
Subject: mm/memory_hotplug: rate limit page migration warnings

When offlining memory the system can attempt to migrate a lot of pages, if
there are problems with migration this can flood the logs.  Printing all
the data hogs the CPU and cause some RT threads to run for a long time,
which may have some bad consequences.

Rate limit the page migration warnings in order to avoid this.

Link: https://lkml.kernel.org/r/20210505140542.24935-1-georgi.djakov@linaro.org
Signed-off-by: Liam Mark <lmark@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-rate-limit-page-migration-warnings
+++ a/mm/memory_hotplug.c
@@ -1406,6 +1406,8 @@ do_migrate_range(unsigned long start_pfn
 	struct page *page, *head;
 	int ret = 0;
 	LIST_HEAD(source);
+	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		if (!pfn_valid(pfn))
@@ -1452,8 +1454,10 @@ do_migrate_range(unsigned long start_pfn
 						    page_is_file_lru(page));
 
 		} else {
-			pr_warn("failed to isolate pfn %lx\n", pfn);
-			dump_page(page, "isolation failed");
+			if (__ratelimit(&migrate_rs)) {
+				pr_warn("failed to isolate pfn %lx\n", pfn);
+				dump_page(page, "isolation failed");
+			}
 		}
 		put_page(page);
 	}
@@ -1482,9 +1486,11 @@ do_migrate_range(unsigned long start_pfn
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret) {
 			list_for_each_entry(page, &source, lru) {
-				pr_warn("migrating pfn %lx failed ret:%d ",
-				       page_to_pfn(page), ret);
-				dump_page(page, "migration failure");
+				if (__ratelimit(&migrate_rs)) {
+					pr_warn("migrating pfn %lx failed ret:%d\n",
+						page_to_pfn(page), ret);
+					dump_page(page, "migration failure");
+				}
 			}
 			putback_movable_pages(&source);
 		}
_

Patches currently in -mm which might be from lmark@codeaurora.org are


