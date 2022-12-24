Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCDBC4332F
	for <mm-commits@archiver.kernel.org>; Sat, 24 Dec 2022 22:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiLXWUS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 24 Dec 2022 17:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiLXWUR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 24 Dec 2022 17:20:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F5A9FC7
        for <mm-commits@vger.kernel.org>; Sat, 24 Dec 2022 14:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45585B802C3
        for <mm-commits@vger.kernel.org>; Sat, 24 Dec 2022 22:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D315CC433D2;
        Sat, 24 Dec 2022 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671920413;
        bh=cCwZctiYy1YuhScRvuquXRIo9XV9fKHnkH2jHCHJZcE=;
        h=Date:To:From:Subject:From;
        b=WDy547rrX7qQBuLkwJc/Q5C85uS8jEyos6B0GeGNY36ZQkLusg8b8yZWx985mgJVf
         o3+KD5/QpnjQucuk++9/x4xiQfDOvwgfO86VNOEdFCRVPNRpSPBX2+FKU9o3pL9S87
         E05L5cwXrc1zww75gUnnSyCITvGDrw4m4rbkzQig=
Date:   Sat, 24 Dec 2022 14:20:10 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, peterx@redhat.com, pasha.tatashin@soleen.com,
        liam.howlett@oracle.com, hughd@google.com, david@redhat.com,
        ccross@google.com, arnd@arndb.de, kele.huang@columbia.edu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-comment-of-page-table-counter.patch added to mm-unstable branch
Message-Id: <20221224222013.D315CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix comment of page table counter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-comment-of-page-table-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-comment-of-page-table-counter.patch

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
From: Kele Huang <kele.huang@columbia.edu>
Subject: mm: fix comment of page table counter
Date: Sat, 24 Dec 2022 01:02:33 -0500

Commit af5b0f6a09e42 ("mm: consolidate page table accounting")
consolidates page table accounting to a single counter in struct mm_struct
{} as mm->pgtables_bytes.  So the meanning of this counter should be the
size of all page tables now.

Link: https://lkml.kernel.org/r/20221224060233.417827-1-kele.huang@columbia.edu
Signed-off-by: Kele Huang <kele.huang@columbia.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm_types.h~mm-fix-comment-of-page-table-counter
+++ a/include/linux/mm_types.h
@@ -647,7 +647,7 @@ struct mm_struct {
 		atomic_t mm_count;
 
 #ifdef CONFIG_MMU
-		atomic_long_t pgtables_bytes;	/* PTE page table pages */
+		atomic_long_t pgtables_bytes;	/* size of all page tables */
 #endif
 		int map_count;			/* number of VMAs */
 
_

Patches currently in -mm which might be from kele.huang@columbia.edu are

mm-fix-comment-of-page-table-counter.patch

