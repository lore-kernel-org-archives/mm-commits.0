Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E3B7C636CC
	for <mm-commits@archiver.kernel.org>; Thu, 16 Feb 2023 22:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjBPWH2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 17:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBPWH2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 17:07:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C672D43914
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 14:07:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D64360C64
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 22:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A9CC433EF;
        Thu, 16 Feb 2023 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676585245;
        bh=dyUBP6YPnZeNmWhyRJ/v0sVaJuSDqhVoL9g6htI9Mcc=;
        h=Date:To:From:Subject:From;
        b=Zbx3OeuUF7808efhOWMmWIPoHBXy7dW6uWB+nyppx5+ZL+KMreEWrtY8JxkzPJESV
         blVVUy4f4/TtdSQvPXOS7EvwbVhlbGExICrxBoyWxpsDmTIz/E47roJ6vfPnrT5/Fe
         ch8DLPtpJ7nf8OuqAtfwr1ApD9y7GFVJgMw1ILJ8=
Date:   Thu, 16 Feb 2023 14:07:24 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        baolin.wang@linux.alibaba.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-cleanup-return-value-handing-in-do_migrate_range.patch added to mm-unstable branch
Message-Id: <20230216220725.A1A9CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: cleanup return value handing in do_migrate_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-cleanup-return-value-handing-in-do_migrate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-cleanup-return-value-handing-in-do_migrate_range.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/memory_hotplug: cleanup return value handing in do_migrate_range()
Date: Thu, 16 Feb 2023 17:07:03 +0000

Return value mechanism of do_migrate_range() is not very simple, while no
caller of the function checks the return value.  Make the function return
nothing to be more simple, and cleanup related unnecessary code.

Link: https://lkml.kernel.org/r/20230216170703.64574-1-sj@kernel.org
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory_hotplug.c~mm-memory_hotplug-cleanup-return-value-handing-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1620,12 +1620,10 @@ found:
 	return 0;
 }
 
-static int
-do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
+static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
 	struct page *page, *head;
-	int ret = 0;
 	LIST_HEAD(source);
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
@@ -1679,7 +1677,6 @@ do_migrate_range(unsigned long start_pfn
 						    page_is_file_lru(page));
 
 		} else {
-			ret = -EBUSY;
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n", pfn);
 				dump_page(page, "isolation failed");
@@ -1693,6 +1690,7 @@ do_migrate_range(unsigned long start_pfn
 			.nmask = &nmask,
 			.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 		};
+		int ret;
 
 		/*
 		 * We have checked that migration range is on a single zone so
@@ -1721,8 +1719,6 @@ do_migrate_range(unsigned long start_pfn
 			putback_movable_pages(&source);
 		}
 	}
-
-	return ret;
 }
 
 static int __init cmdline_parse_movable_node(char *p)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-memory_hotplug-cleanup-return-value-handing-in-do_migrate_range.patch
mm-memory_hotplug-return-nothing-from-do_migrate_range.patch
mm-memory_hotplug-cleanup-ret-variable-usage-in-do_migrate_range.patch

