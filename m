Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050FBC6FA8E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCCCM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCCCM6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:12:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DF46A71
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:12:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9720EB8161F
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E50BC433D2;
        Fri,  3 Mar 2023 02:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809574;
        bh=T9lwow+5B7CGOHBZavwO6gJsmilep3jO/6zp0aVK2a0=;
        h=Date:To:From:Subject:From;
        b=r/KHZGBhceZp1bnr6P66em0d0V7Uu7IKFxtTHuAD6bnkU0YbEqaYBf8ajlJaMeKNQ
         qpbqYC3KHjoOCbOnPh1awLLoNNv61/6qnvtgedzRvKGWpYbJ+MUa+7k6hfiLU8kKbs
         a437SeAe86RuSOWr6fmpbavtVM70bjPMsLNpXTys=
Date:   Thu, 02 Mar 2023 18:12:53 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, torvalds@linux-foundation.org,
        shy828301@gmail.com, osalvador@suse.de, bharata@amd.com,
        baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-silence-gcc-notes-for-mis-casting.patch added to mm-hotfixes-unstable branch
Message-Id: <20230303021254.4E50BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: silence gcc notes for mis-casting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     migrate_pages-silence-gcc-notes-for-mis-casting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-silence-gcc-notes-for-mis-casting.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages: silence gcc notes for mis-casting
Date: Thu, 2 Mar 2023 09:26:10 +0800

The following GCC notes was reported for commit 64c8902ed441
("migrate_pages: split unmap_and_move() to _unmap() and _move()").

    mm/migrate.c: In function `__migrate_folio_extract':
    mm/migrate.c:1050:20: note: randstruct: casting between randomized
structure pointer types (ssa): `struct anon_vma' and `struct
address_space'

     1050 |         *anon_vmap = (void *)dst->mapping;
          |         ~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~

The casting itself is safe.  Because we only use dst->mapping to store the
pointer itself temporarily and dst is a newly allocated folio and not used
by anyone else during that.  But the notes should be silenced and some
comments are deserved.  So, we do that in this patch.

Link: https://lkml.kernel.org/r/20230302012610.17055-1-ying.huang@intel.com
Fixes: 64c8902ed441 ("migrate_pages: split unmap_and_move() to _unmap() and _move()")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~migrate_pages-silence-gcc-notes-for-mis-casting
+++ a/mm/migrate.c
@@ -1047,7 +1047,16 @@ static void __migrate_folio_extract(stru
 				   int *page_was_mappedp,
 				   struct anon_vma **anon_vmap)
 {
-	*anon_vmap = (void *)dst->mapping;
+	struct anon_vma *anon_vma;
+
+	/*
+	 * 2 steps assignment to silence gcc notes for mis-casting. The
+	 * casting is safe.  Because we only use dst->mapping to store
+	 * the pointer itself temporarily and dst is a newly allocated
+	 * folio and not used by anyone else during that.
+	 */
+	anon_vma = (void *)dst->mapping;
+	*anon_vmap = anon_vma;
 	*page_was_mappedp = (unsigned long)dst->private;
 	dst->mapping = NULL;
 	dst->private = NULL;
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages-fix-deadlock-in-batched-migration.patch
migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch
migrate_pages-try-migrate-in-batch-asynchronously-firstly.patch
migrate_pages-silence-gcc-notes-for-mis-casting.patch

