Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19ED1C64EC7
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjBTUr1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjBTUrI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:47:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC24115
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:47:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 37778CE10A1
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BEBC433EF;
        Mon, 20 Feb 2023 20:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926024;
        bh=zWUmu/ac9g2iALNwLl3zs39PEp8Er1oFLh3KNGnsSFc=;
        h=Date:To:From:Subject:From;
        b=V/ENJU1tgdOZZtn9i3gD1aXkyQ26tosSpEjERs6ER0cZzgfzRSdEtZjHfn/SVqF1E
         RSagOszlGw+4Ura4zpL6pZG98o02Jf1mBuA9sCa84kWKN/IARrlu+klasVv4rxVM81
         Tz87sflGkrmgo9fZsDg86dewfCOwZKIp5JCiq51c=
Date:   Mon, 20 Feb 2023 12:47:04 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        baolin.wang@linux.alibaba.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-cleanup-return-value-handing-in-do_migrate_range.patch removed from -mm tree
Message-Id: <20230220204704.B6BEBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: cleanup return value handing in do_migrate_range()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-cleanup-return-value-handing-in-do_migrate_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


