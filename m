Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8403C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 01:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiA0Bwd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 20:52:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58856 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiA0Bwb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 20:52:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F015161C11
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 01:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C863DC340E7;
        Thu, 27 Jan 2022 01:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643248350;
        bh=fR9b/hn3syq5cy/2jdJ9ogj/t/vjkXKhbhNbTpdBMOU=;
        h=Date:From:To:Subject:From;
        b=q2o7b/w9AXLCnGteZB1I1T2HiIsY+koVL5B2lGcXKoCAlN/4Ky/JvJ0KYG6E6H5nL
         nCKs7aTqUtlpq4uQGyu7YkJHfG9nQ3qt6Xsi6To44o6egebaT5AMjVIu7NIdawKFGN
         ns24ALvWK6vT+yWTNBH+ijdSh9YuBjiTbmfI0cDY=
Date:   Wed, 26 Jan 2022 17:52:29 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        dave.hansen@linux.intel.com, gthelen@google.com, hpa@zytor.com,
        hughd@google.com, jirislaby@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        pjt@google.com, rientjes@google.com, rppt@kernel.org,
        songmuchun@bytedance.com, weixugc@google.com, will@kernel.org,
        ziy@nvidia.com
Subject:  +
 mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup.patch
 added to -mm tree
Message-ID: <20220127015229.5K-QidcqU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: use unsigned long for page counters and cleanup
has been added to the -mm tree.  Its filename is
     mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm/page_table_check: use unsigned long for page counters and cleanup

For consistency, use "unsigned long" for all page counters.

Also, reduce code duplication by calling __page_table_check_*_clear() from
__page_table_check_*_set() functions.

Link: https://lkml.kernel.org/r/20220126183637.1840960-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Wei Xu <weixugc@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Paul Turner <pjt@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup
+++ a/mm/page_table_check.c
@@ -86,8 +86,8 @@ static void page_table_check_clear(struc
 {
 	struct page_ext *page_ext;
 	struct page *page;
+	unsigned long i;
 	bool anon;
-	int i;
 
 	if (!pfn_valid(pfn))
 		return;
@@ -121,8 +121,8 @@ static void page_table_check_set(struct
 {
 	struct page_ext *page_ext;
 	struct page *page;
+	unsigned long i;
 	bool anon;
-	int i;
 
 	if (!pfn_valid(pfn))
 		return;
@@ -152,10 +152,10 @@ static void page_table_check_set(struct
 void __page_table_check_zero(struct page *page, unsigned int order)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
-	int i;
+	unsigned long i;
 
 	BUG_ON(!page_ext);
-	for (i = 0; i < (1 << order); i++) {
+	for (i = 0; i < (1ul << order); i++) {
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 
 		BUG_ON(atomic_read(&ptc->anon_map_count));
@@ -206,17 +206,10 @@ EXPORT_SYMBOL(__page_table_check_pud_cle
 void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte)
 {
-	pte_t old_pte;
-
 	if (&init_mm == mm)
 		return;
 
-	old_pte = *ptep;
-	if (pte_user_accessible_page(old_pte)) {
-		page_table_check_clear(mm, addr, pte_pfn(old_pte),
-				       PAGE_SIZE >> PAGE_SHIFT);
-	}
-
+	__page_table_check_pte_clear(mm, addr, *ptep);
 	if (pte_user_accessible_page(pte)) {
 		page_table_check_set(mm, addr, pte_pfn(pte),
 				     PAGE_SIZE >> PAGE_SHIFT,
@@ -228,17 +221,10 @@ EXPORT_SYMBOL(__page_table_check_pte_set
 void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
-	pmd_t old_pmd;
-
 	if (&init_mm == mm)
 		return;
 
-	old_pmd = *pmdp;
-	if (pmd_user_accessible_page(old_pmd)) {
-		page_table_check_clear(mm, addr, pmd_pfn(old_pmd),
-				       PMD_PAGE_SIZE >> PAGE_SHIFT);
-	}
-
+	__page_table_check_pmd_clear(mm, addr, *pmdp);
 	if (pmd_user_accessible_page(pmd)) {
 		page_table_check_set(mm, addr, pmd_pfn(pmd),
 				     PMD_PAGE_SIZE >> PAGE_SHIFT,
@@ -250,17 +236,10 @@ EXPORT_SYMBOL(__page_table_check_pmd_set
 void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
-	pud_t old_pud;
-
 	if (&init_mm == mm)
 		return;
 
-	old_pud = *pudp;
-	if (pud_user_accessible_page(old_pud)) {
-		page_table_check_clear(mm, addr, pud_pfn(old_pud),
-				       PUD_PAGE_SIZE >> PAGE_SHIFT);
-	}
-
+	__page_table_check_pud_clear(mm, addr, *pudp);
 	if (pud_user_accessible_page(pud)) {
 		page_table_check_set(mm, addr, pud_pfn(pud),
 				     PUD_PAGE_SIZE >> PAGE_SHIFT,
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch
mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup.patch
mm-khugepaged-unify-collapse-pmd-clear-flush-and-free.patch
mm-page_table_check-check-entries-at-pmd-levels.patch

