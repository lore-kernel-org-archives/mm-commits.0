Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4E4C74A4B
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 19:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjCMTbn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 15:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCMTbm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 15:31:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2367D551
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 12:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91CB8614A8
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 19:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BE1C433D2;
        Mon, 13 Mar 2023 19:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678735900;
        bh=gp5bzGegjkFg89WunHgjnmoO3I2X3Hld9NobgSApnIY=;
        h=Date:To:From:Subject:From;
        b=FzrdYCK56ySJc2tXFcNc325OPlsnBhdvyjJfZ4R1EKoEO+cBbqxhnD+agvIDbueas
         gGN6vylUghr9lmhVZ6ir0iLimEBrZ668nYWxEJOVEf7y0bGnGZrxMphUiVNTdSL9wm
         CDbELO36gTSec0W1znu4iCxf0lY85ta3kKQmxexg=
Date:   Mon, 13 Mar 2023 12:31:39 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        vbabka@suse.cz, osalvador@suse.de, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch added to mm-unstable branch
Message-Id: <20230313193139.E7BE1C433D2@smtp.kernel.org>
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
Date: Mon, 13 Mar 2023 18:37:17 +0800

When trying to isolate a migratable pageblock, it can contain several
normal pages or several hugetlb pages (e.g.  CONT-PTE 64K hugetlb on
arm64) in a pageblock.  That means we may hold the lru lock of a normal
page to continue to isolate the next hugetlb page by
isolate_or_dissolve_huge_page() in the same migratable pageblock.

However in isolate_or_dissolve_huge_page(), it may allocate a new hugetlb
page and dissolve the old one via alloc_and_dissolve_hugetlb_folio() if
the hugetlb's refcount is zero.  That means we can still enter the direct
compaction path to allocate a new hugetlb page under the current lru lock,
which may cause a deadlock.

To avoid this possible deadlock, we should release the lru lock when
trying to isolate a hugetbl page.  Moreover it does not make sense to take
the lru lock to isolate a hugetlb, which is not in the lru list.

Link: https://lkml.kernel.org/r/a24a86fbae09711e61dc4424aa7aebff718e9995.1678703534.git.baolin.wang@linux.alibaba.com
Fixes: 369fa227c219 ("mm: make alloc_contig_range handle free hugetlb pages")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Lam <william.lam@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages
+++ a/mm/compaction.c
@@ -893,6 +893,11 @@ isolate_migratepages_block(struct compac
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

