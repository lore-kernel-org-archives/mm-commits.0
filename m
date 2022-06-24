Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB9CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 21:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiFXVMN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 17:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiFXVLs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 17:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E38285D22
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 14:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F28962364
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 21:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F62C34114;
        Fri, 24 Jun 2022 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656105106;
        bh=BnD1egjP8V7D2etBB0hAkcTuS9iJb4JvqQ8Brc2gvmc=;
        h=Date:To:From:Subject:From;
        b=ZbrOH4L3lFz57acgspDY5QrgFljE4Y+qlXQ2l5pWOXIbxPce79Xe4zKom29BMQwF+
         IFz8MrmK04DjYE7BjarxRpiBQRogz8cFltA5p4ntUV5eBPHEqeTT9Clrnc0kMGW3Cj
         nYhIuQ+gEzfgrCcArv/H/qEeAzOSycRanOvpfnrk=
Date:   Fri, 24 Jun 2022 14:11:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        cgel.zte@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-the-annotations-of-available-memory-more-accurate.patch added to mm-unstable branch
Message-Id: <20220624211146.02F62C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: make the annotations of available memory more accurate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-the-annotations-of-available-memory-more-accurate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-the-annotations-of-available-memory-more-accurate.patch

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
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/page_alloc: make the annotations of available memory more accurate
Date: Thu, 23 Jun 2022 02:08:34 +0000

Not all systems use swap, so estimating available memory would help to
prevent swapping or OOM of system that not use swap.

And we need to reserve some page cache to prevent swapping or thrashing. 
If somebody is accessing the pages in pagecache, and if too much would be
freed, most accesses might mean reading data from disk, i.e.  thrashing.

Link: https://lkml.kernel.org/r/20220623020833.972979-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-the-annotations-of-available-memory-more-accurate
+++ a/mm/page_alloc.c
@@ -5879,14 +5879,14 @@ long si_mem_available(void)
 
 	/*
 	 * Estimate the amount of memory available for userspace allocations,
-	 * without causing swapping.
+	 * without causing swapping or OOM.
 	 */
 	available = global_zone_page_state(NR_FREE_PAGES) - totalreserve_pages;
 
 	/*
 	 * Not all the page cache can be freed, otherwise the system will
-	 * start swapping. Assume at least half of the page cache, or the
-	 * low watermark worth of cache, needs to stay.
+	 * start swapping or thrashing. Assume at least half of the page
+	 * cache, or the low watermark worth of cache, needs to stay.
 	 */
 	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
 	pagecache -= min(pagecache / 2, wmark_low);
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

mm-page_alloc-make-the-annotations-of-available-memory-more-accurate.patch

