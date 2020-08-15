Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0331C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D6BE20657
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529508;
	bh=CVslb6CC+9gDItRk12qCWMZx1uHETuLm4WSjDJFhgD8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DT3SA2H/Zju7EpUguujvSkXWxFlRhaS7MukRHgN5ROXyC2W2/LBMU+LCZO+XyOOKV
	 aeADrVPSj1EHeowcvofBP8YoS6XH4DNdiV2nDGyCgYC+jlfEObWsQe5bmSGNRPlImI
	 Zj7XgC2PDQ9ZjQXieLwaM4bCOYD4c433rDmUQXCg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgHOWKa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgHOWK2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B4822BF5;
        Sat, 15 Aug 2020 00:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451431;
        bh=CVslb6CC+9gDItRk12qCWMZx1uHETuLm4WSjDJFhgD8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1OtGZLK663dXj62keN6VCshusQcF7PMZ2s3V6+SrL3rUIgqrmtRZw1DpVChWJyyHq
         tdQ7YGbs125x4yg3llKeIOmfSorlnxANgZqBcfAKo7ykzT8YGbMNiRioFUvDOkXqnO
         uPNE13XZV3pHhVghBA6pcFmBjKZE4uUUGy26iAio=
Date:   Fri, 14 Aug 2020 17:30:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 09/39] mm: add thp_order
Message-ID: <20200815003030.WpMt3aGto%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add thp_order

This function returns the order of a transparent huge page.  It compiles
to 0 if CONFIG_TRANSPARENT_HUGEPAGE is disabled.

Link: http://lkml.kernel.org/r/20200629151959.15779-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-thp_order
+++ a/include/linux/huge_mm.h
@@ -258,6 +258,19 @@ static inline spinlock_t *pud_trans_huge
 	else
 		return NULL;
 }
+
+/**
+ * thp_order - Order of a transparent huge page.
+ * @page: Head page of a transparent huge page.
+ */
+static inline unsigned int thp_order(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	if (PageHead(page))
+		return HPAGE_PMD_ORDER;
+	return 0;
+}
+
 static inline int hpage_nr_pages(struct page *page)
 {
 	if (unlikely(PageTransHuge(page)))
@@ -317,6 +330,12 @@ static inline struct list_head *page_def
 #define HPAGE_PUD_MASK ({ BUILD_BUG(); 0; })
 #define HPAGE_PUD_SIZE ({ BUILD_BUG(); 0; })
 
+static inline unsigned int thp_order(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	return 0;
+}
+
 static inline int hpage_nr_pages(struct page *page)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
_
