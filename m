Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBACC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32CD6100C
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWmx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWmw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90942613EA;
        Sat,  8 May 2021 22:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513710;
        bh=KKWkgkM1xiM+VHREO9LMdl20bAr4PCwmlE+5WdaumTM=;
        h=Date:From:To:Subject:From;
        b=Ipcu7PKB5Hfe9a6XwqLuyMsW+e1xwfBrZhD7abNH8YSSSn7js7Aj2SRrkaaB8RyNi
         vXKESBbWs77VbHdfR6u4KDzC9M6Vs1nHmuenkdFZERJCq8Yq/qbBCSNa+lOuWcUAFy
         DJBYMqr17WWskwl6NPgxoTgTY+mZiTcY1IXsVC7E=
Date:   Sat, 08 May 2021 15:41:49 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, dave.hansen@linux.intel.com, david@redhat.com,
        hpa@zytor.com, luto@kernel.org, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, tglx@linutronix.de, ziy@nvidia.com
Subject:  [merged]
 x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch removed from -mm tree
Message-ID: <20210508224149.dCPCWeErd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/vmemmap: drop handling of 1GB vmemmap ranges
has been removed from the -mm tree.  Its filename was
     x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from osalvador@suse.de are


