Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004F6C43470
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3FCE6147F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhD3F6F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhD3F6E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7451B61482;
        Fri, 30 Apr 2021 05:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762236;
        bh=gOnRE6P5JP9oCS8OhjH8wYX29VHBWas9YFWpK9HtXSY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gGYiKY1iBgsjs7p8QU1+A2vWT8jCe+NI070nYIJEewqAzaYLIanA6us9VaX8/15Wm
         lofQVbg0FX5Bdbe2KSYVgHNz4TKpLCnTTbyhqrUU/A55fYQ3e+u3H1RpAfrGmCQaDQ
         tyhooUsrpdXY/crzbgkawZLP83zB2DiciysVF8Co=
Date:   Thu, 29 Apr 2021 22:57:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de,
        dave.hansen@linux.intel.com, david@redhat.com, hpa@zytor.com,
        linux-mm@kvack.org, luto@kernel.org, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 080/178] x86/vmemmap: drop handling of 1GB vmemmap
 ranges
Message-ID: <20210430055716.rCW7Gu1lT%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: x86/vmemmap: drop handling of 1GB vmemmap ranges

There is no code to allocate 1GB pages when mapping the vmemmap range as
this might waste some memory and requires more complexity which is not
really worth.

Drop the dead code both for the aligned and unaligned cases and leave only
the direct map handling.

Link: https://lkml.kernel.org/r/20210309214050.4674-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges
+++ a/arch/x86/mm/init_64.c
@@ -1062,7 +1062,6 @@ remove_pud_table(pud_t *pud_start, unsig
 	unsigned long next, pages = 0;
 	pmd_t *pmd_base;
 	pud_t *pud;
-	void *page_addr;
 
 	pud = pud_start + pud_index(addr);
 	for (; addr < end; addr = next, pud++) {
@@ -1071,33 +1070,13 @@ remove_pud_table(pud_t *pud_start, unsig
 		if (!pud_present(*pud))
 			continue;
 
-		if (pud_large(*pud)) {
-			if (IS_ALIGNED(addr, PUD_SIZE) &&
-			    IS_ALIGNED(next, PUD_SIZE)) {
-				if (!direct)
-					free_pagetable(pud_page(*pud),
-						       get_order(PUD_SIZE));
-
-				spin_lock(&init_mm.page_table_lock);
-				pud_clear(pud);
-				spin_unlock(&init_mm.page_table_lock);
-				pages++;
-			} else {
-				/* If here, we are freeing vmemmap pages. */
-				memset((void *)addr, PAGE_INUSE, next - addr);
-
-				page_addr = page_address(pud_page(*pud));
-				if (!memchr_inv(page_addr, PAGE_INUSE,
-						PUD_SIZE)) {
-					free_pagetable(pud_page(*pud),
-						       get_order(PUD_SIZE));
-
-					spin_lock(&init_mm.page_table_lock);
-					pud_clear(pud);
-					spin_unlock(&init_mm.page_table_lock);
-				}
-			}
-
+		if (pud_large(*pud) &&
+		    IS_ALIGNED(addr, PUD_SIZE) &&
+		    IS_ALIGNED(next, PUD_SIZE)) {
+			spin_lock(&init_mm.page_table_lock);
+			pud_clear(pud);
+			spin_unlock(&init_mm.page_table_lock);
+			pages++;
 			continue;
 		}
 
_
