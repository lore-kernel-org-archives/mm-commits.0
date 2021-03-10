Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB09FC43381
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 22:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF94964FCD
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 22:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhCJWyV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234001AbhCJWyF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 17:54:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC0DA64FC9;
        Wed, 10 Mar 2021 22:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615416845;
        bh=DQcAJVu6QiN7ng26YxUT7AUPxnBZ9JKKzMPVdm8ilS8=;
        h=Date:From:To:Subject:From;
        b=IpMjAAUC9xlBvBn0QDj6JtpVfCy/DUH0siAJ3CiaNbjr58gfDxyZDXgbhykb2lZ/U
         YSk1ufBH9QPcItNq1oQOLVUtjorlWZwX4Y4ZfCUjiQcO+v5TLkfIUXPFFuw9e1RHnY
         GeX+pllDkFgP5alQwzD8FnXXdwqQzb/BycSw1BxM=
Date:   Wed, 10 Mar 2021 14:54:04 -0800
From:   akpm@linux-foundation.org
To:     bp@alien8.de, dave.hansen@linux.intel.com, david@redhat.com,
        hpa@zytor.com, luto@kernel.org, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, tglx@linutronix.de
Subject:  [to-be-updated]
 x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch removed from -mm tree
Message-ID: <20210310225404.2d9u2QAgw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/vmemmap: drop handling of 1GB vmemmap ranges
has been removed from the -mm tree.  Its filename was
     x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: x86/vmemmap: drop handling of 1GB vmemmap ranges

We never get to allocate 1GB pages when mapping the vmemmap range.  Drop
the dead code both for the aligned and unaligned cases and leave only the
direct map handling.

Link: https://lkml.kernel.org/r/20210301083230.30924-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
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

x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch

