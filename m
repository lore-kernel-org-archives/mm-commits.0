Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E9FC43217
	for <mm-commits@archiver.kernel.org>; Fri,  4 Feb 2022 04:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241715AbiBDEtT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiBDEtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 23:49:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE317C061714
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 20:49:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E4F061AAC
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 04:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FECC004E1;
        Fri,  4 Feb 2022 04:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643950157;
        bh=CwXvMW0kzg+EbExulgkv4VP+W8ZnB/a12489SOXC0sI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=srG60j7NHHwdQIta+vPF4zTILUwqGwcC13W6AiTNar27nitn6oyxP23eiUHctYMLp
         Q9//bWGA75nkUkH7yENKzHQom43Cn9gbpCkuU54Sk7866MxkMvmkMWPvnJX2HSmuO1
         gYH9O6VkV54BzuxksschF43IuAXmma3S8mWR+V+I=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 20:49:15 -0800
Date:   Thu, 03 Feb 2022 20:49:15 -0800
To:     ziy@nvidia.com, will@kernel.org, weixugc@google.com,
        songmuchun@bytedance.com, rppt@kernel.org, rientjes@google.com,
        pjt@google.com, mingo@redhat.com, jirislaby@kernel.org,
        hughd@google.com, hpa@zytor.com, gthelen@google.com,
        dave.hansen@linux.intel.com, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 03/10] mm/page_table_check: use unsigned long for page counters and cleanup
Message-Id: <20220204044916.06FECC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm/page_table_check: use unsigned long for page counters and cleanup

For consistency, use "unsigned long" for all page counters.

Also, reduce code duplication by calling
__page_table_check_*_clear() from __page_table_check_*_set() functions.

Link: https://lkml.kernel.org/r/20220131203249.2832273-3-pasha.tatashin@soleen.com
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
