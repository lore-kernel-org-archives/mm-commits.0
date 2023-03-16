Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F56FC6FD1F
	for <mm-commits@archiver.kernel.org>; Thu, 16 Mar 2023 22:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjCPW4i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Mar 2023 18:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjCPW4h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2023 18:56:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC7F87A23
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 15:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793FA62100
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 22:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE69DC433D2;
        Thu, 16 Mar 2023 22:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679007392;
        bh=D4wH1qGdflRCELthpR85UuqUaHfFZB3DLAcMv4yyWEc=;
        h=Date:To:From:Subject:From;
        b=Q/uPqD5kUXILdCfVr9DQmp8Tz7yrkLtvU4Rupp6MfsPpnoUh9nu38sb2KtA+I7Cb1
         iM4CVpNTRWTmEnKreQ4cuU8cm3gPCTTlS1fd2Awh6qo3iZHgTZ8l4AoY1JU/k29NGi
         4nkKASX0z6ZEup5X/nooutKNJtesbQ5yAtBeEyGk=
Date:   Thu, 16 Mar 2023 15:56:32 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        vbabka@suse.cz, osalvador@suse.de, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch added to mm-unstable branch
Message-Id: <20230316225632.CE69DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix the possible deadlock when isolating hugetlb pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: fix the possible deadlock when isolating hugetlb pages
Date: Thu, 16 Mar 2023 19:06:47 +0800

When trying to isolate a migratable pageblock, it can contain several
normal pages or several hugetlb pages (e.g. CONT-PTE 64K hugetlb on arm64)
in a pageblock. That means we may hold the lru lock of a normal page to
continue to isolate the next hugetlb page by isolate_or_dissolve_huge_page()
in the same migratable pageblock.

However in the isolate_or_dissolve_huge_page(), it may allocate a new hugetlb
page and dissolve the old one by alloc_and_dissolve_hugetlb_folio() if the
hugetlb's refcount is zero. That means we can still enter the direct compaction
path to allocate a new hugetlb page under the current lru lock, which
may cause possible deadlock.

To avoid this possible deadlock, we should release the lru lock when
trying to isolate a hugetbl page.  Moreover it does not make sense to take
the lru lock to isolate a hugetlb, which is not in the lru list.

Link: https://lkml.kernel.org/r/7ab3bffebe59fb419234a68dec1e4572a2518563.1678962352.git.baolin.wang@linux.alibaba.com
Fixes: 369fa227c219 ("mm: make alloc_contig_range handle free hugetlb pages")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: William Lam <william.lam@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages
+++ a/mm/compaction.c
@@ -894,6 +894,11 @@ isolate_migratepages_block(struct compac
 		}
 
 		if (PageHuge(page) && cc->alloc_contig) {
+			if (locked) {
+				unlock_page_lruvec_irqrestore(locked, flags);
+				locked = NULL;
+			}
+
 			ret = isolate_or_dissolve_huge_page(page, &cc->migratepages);
 
 			/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch
mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch

