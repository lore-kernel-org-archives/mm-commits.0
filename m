Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2E4C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B93CA61421
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhEIDpD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhEIDpD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5B72613EC;
        Sun,  9 May 2021 03:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620531840;
        bh=15IrFLtzFODe/bGbXmQT15TeiTtwwNcapOZigeDb2Go=;
        h=Date:From:To:Subject:From;
        b=lBgpAo9JdqoGJJZZYW67dXLuJQhEQ+qtct2A1TOQo6Sko3cqM2VmmwPqH06K/SJRz
         AOx0/JDoS7nSqWahdCt8PCYGWwr+eXJgv0htil1HqypqGm10xv4kbS5O0IZkDRMkTn
         KLxJZMrzWASLQSSi+jvVXfxg7+vBX9ZknfPheuKI=
Date:   Sat, 08 May 2021 20:44:00 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, georgi.djakov@linaro.org, lmark@codeaurora.org,
        mm-commits@vger.kernel.org
Subject:  +
 mm-memory_hotplug-rate-limit-page-migration-warnings.patch added to -mm
 tree
Message-ID: <20210509034400.Qo7ipOD5B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: rate limit page migration warnings
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-rate-limit-page-migration-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-rate-limit-page-migration-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-rate-limit-page-migration-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1521,6 +1521,8 @@ do_migrate_range(unsigned long start_pfn
 	struct page *page, *head;
 	int ret = 0;
 	LIST_HEAD(source);
+	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		if (!pfn_valid(pfn))
@@ -1567,8 +1569,10 @@ do_migrate_range(unsigned long start_pfn
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
@@ -1597,9 +1601,11 @@ do_migrate_range(unsigned long start_pfn
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

mm-memory_hotplug-rate-limit-page-migration-warnings.patch

