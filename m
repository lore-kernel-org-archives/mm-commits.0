Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D88C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB8D611C1
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhKESs3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231904AbhKESs3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:48:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56BB86023D;
        Fri,  5 Nov 2021 18:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137949;
        bh=0QrOfhwLNakVwdqCfPtQjuG62/M7Wyj9MH3k2GZjNSY=;
        h=Date:From:To:Subject:From;
        b=AvcsuYqaSDLPrRHHdSSmVocBO20DNd7QoglsPpQcIVp0B10gXZJUGAdzp2MAQhOZ6
         fiUAJxGBr41CV7jK4lFAOX7c7cTcTEO86zPdGhD86oHCkMDIeakwxdzIkcLACGWTyz
         XIdhZqxB90AFmGiiXhRDRuNZKQ7IsYdUIKlLbimA=
Date:   Fri, 05 Nov 2021 11:45:48 -0700
From:   akpm@linux-foundation.org
To:     ira.weiny@intel.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, prathu.baronia@oneplus.com,
        rdunlap@infradead.org, tglx@linutronix.de, willy@infradead.org
Subject:  [folded-merged]
 mm-highmem-remove-deprecated-kmap_atomic-fix.patch removed from -mm tree
Message-ID: <20211105184548.y5Ry5rqbk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-highmem-remove-deprecated-kmap_atomic-fix
has been removed from the -mm tree.  Its filename was
     mm-highmem-remove-deprecated-kmap_atomic-fix.patch

This patch was dropped because it was folded into mm-highmem-remove-deprecated-kmap_atomic.patch

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
mm-highmem-remove-deprecated-kmap_atomic.patch

