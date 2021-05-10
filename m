Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D222C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 549CA613CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhEJEXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhEJEXr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:23:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1683D60232;
        Mon, 10 May 2021 04:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620620563;
        bh=3vrXzwy74+5uu9e69YQ5zdEGG38ja/iPhFSuygXP7JA=;
        h=Date:From:To:Subject:From;
        b=Sn1sWNzs9/QxgOaWIWLilms5b3wfaeUNFir04SHJxFuXBx6agqsPUvaOs1OBNe6rO
         T8OmYrKbQurgfJA1kbT7qlfqqUrQLbcSjjQPW1CSUtDY/xg16iTU3f8Y87LUb9ti1d
         G0FHV/nADLQBqpAW732fb2RKIbb+n8gtQ0M6tui8=
Date:   Sun, 09 May 2021 21:22:42 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-madvise-introduce-madv=5Fpopulate=5Freadwrite-to-prefaul?=
 =?US-ASCII?Q?t-page-tables-checkpatch-fixes.patch?= added to -mm tree
Message-ID: <20210510042242.XkEemgl7v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes

WARNING: please, no space before tabs
#506: FILE: mm/gup.c:1513:
+^I * ^I       the page dirty with FOLL_WRITE -- which doesn't make a$

WARNING: please, no space before tabs
#507: FILE: mm/gup.c:1514:
+^I * ^I       difference with !FOLL_FORCE, because the page is writable$

WARNING: please, no space before tabs
#508: FILE: mm/gup.c:1515:
+^I * ^I       in the page table.$

total: 0 errors, 3 warnings, 214 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes
+++ a/mm/gup.c
@@ -1510,9 +1510,9 @@ long faultin_vma_page_range(struct vm_ar
 
 	/*
 	 * FOLL_TOUCH: Mark page accessed and thereby young; will also mark
-	 * 	       the page dirty with FOLL_WRITE -- which doesn't make a
-	 * 	       difference with !FOLL_FORCE, because the page is writable
-	 * 	       in the page table.
+	 *	       the page dirty with FOLL_WRITE -- which doesn't make a
+	 *	       difference with !FOLL_FORCE, because the page is writable
+	 *	       in the page table.
 	 * FOLL_HWPOISON: Return -EHWPOISON instead of -EFAULT when we hit
 	 *		  a poisoned page.
 	 * FOLL_POPULATE: Always populate memory with VM_LOCKONFAULT.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

