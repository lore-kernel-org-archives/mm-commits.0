Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CDBC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E20821744
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596225622;
	bh=3Ahmw/k4Bs7N7FX0EmrYvhd82821R1B7OlRN+xYY08U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=y6eH3n3I2pADfWjTliBxGGAPLiWbhphy0FFUHqfur8Iw3nw+KAskWOvZ5t4y+SAjc
	 +sKwpGS6NtVD1kSt46JPDgPzuUU5OxtYgJQh28/zwuIHiY0LnvtasjIo0tR3Hi9oP0
	 Vld4vwJniWQRD1JUTOOjKnko2F3tOUhCluJno5Tk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgGaUAV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgGaUAV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:00:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0291206FA;
        Fri, 31 Jul 2020 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225620;
        bh=3Ahmw/k4Bs7N7FX0EmrYvhd82821R1B7OlRN+xYY08U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zvjrpk0ulcNb2xKPYkcbQwxNnfB1XERlkiTyPk1f352qwNN95ayzi+XBBLa1fppcI
         9TMvmqRd2mi2kK7hmvHy7bN1aDIRDGBG5+ykAxun012J4CuYqf+gnaUJ2MXR/KM8Gd
         c4B8cXlgEvsm9nXmGktm5HtjZa3QMMi+sjM6lDZU=
Date:   Fri, 31 Jul 2020 13:00:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, rdunlap@infradead.org
Subject:  [obsolete]
 mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch removed from -mm
 tree
Message-ID: <20200731200020.zK1GqVPU7%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-rework-soft-offline-for-in-use-pages-fix
has been removed from the -mm tree.  Its filename was
     mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmhwpoison-rework-soft-offline-for-in-use-pages-fix

fix build

../mm/hugetlb.c:1302:20: error: redefinition of `destroy_compound_gigantic_page'
 static inline void destroy_compound_gigantic_page(struct hstate *h,
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../mm/hugetlb.c:1223:13: note: previous definition of `destroy_compound_gigantic_page' was here
 static void destroy_compound_gigantic_page(struct hstate *h, struct page *page,
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Link: http://lkml.kernel.org/r/267a50e8-b7b2-b095-d62e-6e95313bc4c2@infradead.org
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   51 +++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

--- a/mm/hugetlb.c~mmhwpoison-rework-soft-offline-for-in-use-pages-fix
+++ a/mm/hugetlb.c
@@ -1231,30 +1231,6 @@ static inline void ClearPageHugePoisoned
 	page[3].mapping = NULL;
 }
 
-static void destroy_compound_gigantic_page(struct hstate *h, struct page *page,
-					   unsigned int order)
-{
-	int i;
-	int nr_pages = 1 << order;
-	struct page *p = page + 1;
-
-	atomic_set(compound_mapcount_ptr(page), 0);
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
-
-	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
-		if (!hstate_is_gigantic(h))
-			 p->mapping = NULL;
-		clear_compound_head(p);
-		set_page_refcounted(p);
-	}
-
-	if (PageHugePoisoned(page))
-		ClearPageHugePoisoned(page);
-	set_compound_order(page, 0);
-	__ClearPageHead(page);
-}
-
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 static void free_gigantic_page(struct page *page, unsigned int order)
 {
@@ -1313,11 +1289,32 @@ static struct page *alloc_gigantic_page(
 	return NULL;
 }
 static inline void free_gigantic_page(struct page *page, unsigned int order) { }
-static inline void destroy_compound_gigantic_page(struct hstate *h,
-						  struct page *page,
-						  unsigned int order) { }
 #endif
 
+static void destroy_compound_gigantic_page(struct hstate *h, struct page *page,
+					   unsigned int order)
+{
+	int i;
+	int nr_pages = 1 << order;
+	struct page *p = page + 1;
+
+	atomic_set(compound_mapcount_ptr(page), 0);
+	if (hpage_pincount_available(page))
+		atomic_set(compound_pincount_ptr(page), 0);
+
+	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		if (!hstate_is_gigantic(h))
+			 p->mapping = NULL;
+		clear_compound_head(p);
+		set_page_refcounted(p);
+	}
+
+	if (PageHugePoisoned(page))
+		ClearPageHugePoisoned(page);
+	set_compound_order(page, 0);
+	__ClearPageHead(page);
+}
+
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

