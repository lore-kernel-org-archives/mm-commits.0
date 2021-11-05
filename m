Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F75C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40ABF61159
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhKESLT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231981AbhKESLS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:11:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CDDD61053;
        Fri,  5 Nov 2021 18:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636135710;
        bh=1sTBDfloW2whKpyygU5uoUiD+DQjeRHkmvAXLXTJDiY=;
        h=Date:From:To:Subject:From;
        b=q/tJ306oyTBGnR6d7AQvCijRdzRM1LIXRhxKd55l35gYMOJMyjJogM6hchCwB+cb2
         MkNEde8CaOGo7tdVsWEewY++GRM9UiGu8jrM9XYGVKM8iarXYMSPaLHHoohcjNClw3
         on3kSdIlZ0iChqT9mPhyq/2inbpxVFmthbNlUHgs=
Date:   Fri, 05 Nov 2021 11:08:29 -0700
From:   akpm@linux-foundation.org
To:     ira.weiny@intel.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, prathu.baronia@oneplus.com,
        rdunlap@infradead.org, tglx@linutronix.de, willy@infradead.org
Subject:  + mm-highmem-remove-deprecated-kmap_atomic-fix.patch
 added to -mm tree
Message-ID: <20211105180829.VBKO7LSr6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-highmem-remove-deprecated-kmap_atomic-fix
has been added to the -mm tree.  Its filename is
     mm-highmem-remove-deprecated-kmap_atomic-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-remove-deprecated-kmap_atomic-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-remove-deprecated-kmap_atomic-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-highmem-remove-deprecated-kmap_atomic-fix

fix zero_user_segments().

Link: https://lkml.kernel.org/r/YYVhHCJcm2DM2G9u@casper.infradead.org
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Prathu Baronia <prathu.baronia@oneplus.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/highmem.c~mm-highmem-remove-deprecated-kmap_atomic-fix
+++ a/mm/highmem.c
@@ -383,7 +383,7 @@ void zero_user_segments(struct page *pag
 			unsigned this_end = min_t(unsigned, end1, PAGE_SIZE);
 
 			if (end1 > start1) {
-				kaddr = kmap_atomic(page + i);
+				kaddr = kmap_local_page(page + i);
 				memset(kaddr + start1, 0, this_end - start1);
 			}
 			end1 -= this_end;
@@ -398,7 +398,7 @@ void zero_user_segments(struct page *pag
 
 			if (end2 > start2) {
 				if (!kaddr)
-					kaddr = kmap_atomic(page + i);
+					kaddr = kmap_local_page(page + i);
 				memset(kaddr + start2, 0, this_end - start2);
 			}
 			end2 -= this_end;
@@ -406,7 +406,7 @@ void zero_user_segments(struct page *pag
 		}
 
 		if (kaddr) {
-			kunmap_atomic(kaddr);
+			kunmap_local(kaddr);
 			flush_dcache_page(page + i);
 		}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-move-kvmalloc-related-functions-to-slabh.patch
kasan-fix-tag-for-large-allocations-when-using-config_slab.patch
mm-remove-bogus-vm_bug_on.patch
mm-optimise-put_pages_list.patch
mm-highmem-remove-deprecated-kmap_atomic-fix.patch

