Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C49C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 518DF20738
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597791945;
	bh=xqS/BsBLIjTwh+n+qWSUkPEzbjhrGprWJ+aexA5BU4U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=w93zkGqYQ609ub19niNUVvOCK4mlcWTHtAmt7iEQSxagpUHNDkgwt52LK4S3/Up6D
	 Lob9W1tc09qjb3cxkW6FHVsax+1+g5XDCZosv2qIlaud2BaFWbdcvEnb28jhgzpffi
	 ibS/qbH19ctOqYCTBy+GIQtpQnDHQVVio5OqcrkA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgHRXFp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgHRXFo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:05:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A53912065D;
        Tue, 18 Aug 2020 23:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597791944;
        bh=xqS/BsBLIjTwh+n+qWSUkPEzbjhrGprWJ+aexA5BU4U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=p0Xehy5We06gQwj1bfJToHnBDTHE39dDme33HQekWbBxj39q6+AyOXK0Le4QeBNVp
         SYWC8229onND7fBz3w6YiN+TuMucdP1I1r2Y5NjBrIJEK3lMsTa/XiW1sPO6Qwd4/j
         J9Ao8gmG2FOm7EJkO57brWHsJLSe8zHiSng/vrXo=
Date:   Tue, 18 Aug 2020 16:05:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abdhalee@linux.vnet.ibm.com, arnd@arndb.de,
        christophe.leroy@csgroup.eu, jcmvbkbc@gmail.com, joro@8bytes.org,
        luto@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org,
        rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com, shorne@gmail.com,
        willy@infradead.org
Subject:  + mm-account-pmd-tables-like-pte-tables.patch added to
 -mm tree
Message-ID: <20200818230543.H2OAv9kfU%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: account PMD tables like PTE tables
has been added to the -mm tree.  Its filename is
     mm-account-pmd-tables-like-pte-tables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-account-pmd-tables-like-pte-tables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-account-pmd-tables-like-pte-tables.patch

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
Subject: mm: account PMD tables like PTE tables

We account the PTE level of the page tables to the process in order to
make smarter OOM decisions and help diagnose why memory is fragmented. 
For these same reasons, we should account pages allocated for PMDs.  With
larger process address spaces and ASLR, the number of PMDs in use is
higher than it used to be so the inaccuracy is starting to matter.

Link: http://lkml.kernel.org/r/20200627184642.GF25039@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-account-pmd-tables-like-pte-tables
+++ a/include/linux/mm.h
@@ -2239,7 +2239,7 @@ static inline spinlock_t *pmd_lockptr(st
 	return ptlock_ptr(pmd_to_page(pmd));
 }
 
-static inline bool pgtable_pmd_page_ctor(struct page *page)
+static inline bool pmd_ptlock_init(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	page->pmd_huge_pte = NULL;
@@ -2247,7 +2247,7 @@ static inline bool pgtable_pmd_page_ctor
 	return ptlock_init(page);
 }
 
-static inline void pgtable_pmd_page_dtor(struct page *page)
+static inline void pmd_ptlock_free(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	VM_BUG_ON_PAGE(page->pmd_huge_pte, page);
@@ -2264,8 +2264,8 @@ static inline spinlock_t *pmd_lockptr(st
 	return &mm->page_table_lock;
 }
 
-static inline bool pgtable_pmd_page_ctor(struct page *page) { return true; }
-static inline void pgtable_pmd_page_dtor(struct page *page) {}
+static inline bool pmd_ptlock_init(struct page *page) { return true; }
+static inline void pmd_ptlock_free(struct page *page) {}
 
 #define pmd_huge_pte(mm, pmd) ((mm)->pmd_huge_pte)
 
@@ -2278,6 +2278,22 @@ static inline spinlock_t *pmd_lock(struc
 	return ptl;
 }
 
+static inline bool pgtable_pmd_page_ctor(struct page *page)
+{
+	if (!pmd_ptlock_init(page))
+		return false;
+	__SetPageTable(page);
+	inc_zone_page_state(page, NR_PAGETABLE);
+	return true;
+}
+
+static inline void pgtable_pmd_page_dtor(struct page *page)
+{
+	pmd_ptlock_free(page);
+	__ClearPageTable(page);
+	dec_zone_page_state(page, NR_PAGETABLE);
+}
+
 /*
  * No scalability reason to split PUD locks yet, but follow the same pattern
  * as the PMD locks to make it easier if we decide to.  The VM should not be
_

Patches currently in -mm which might be from willy@infradead.org are

mm-account-pmd-tables-like-pte-tables.patch

