Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF14C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47A0A20768
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529502;
	bh=4gUH5r9Rmyz4qBoRBb3or7wxet4s+5ZjYSJEvmCHUD4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SddCKoSwyqVMpJt4xNUUELTaXpu8jcGtUt3+dFWnTDz+ODlZKd6Phv8mmMY5pD8E0
	 ys5E7ZKaQdLjllS42DoIXXBkDWse9pZp3Mpk26fXBk4GMMvxlMh9nFOxc6jO0IqEQn
	 zP378f4j/QeS6/d8R6/umiVZSOnzMwJ+sIoAxg0M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgHOWLh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbgHOWKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A003522B4E;
        Sat, 15 Aug 2020 00:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451441;
        bh=4gUH5r9Rmyz4qBoRBb3or7wxet4s+5ZjYSJEvmCHUD4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zR2JFeg0N9WmFUie4nqi0Cy//8WBEvuztRwK2M+pFHFJk2qrY+cAXqU4ZOJJMUEmc
         4EPwK0DbGMQrje1lNM+9jawXcE15GNRzaMOc9TPSPtua5rRMCvICIPAgypxlTSPzy0
         6kusoqzspLjkmPqDGbw2+X4qyytyki8D4zVXm6wA=
Date:   Fri, 14 Aug 2020 17:30:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 12/39] mm: add thp_head
Message-ID: <20200815003040.fakiVe6j8%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add thp_head

This is like compound_head() but compiles away when
CONFIG_TRANSPARENT_HUGEPAGE is not enabled.

Link: http://lkml.kernel.org/r/20200629151959.15779-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-thp_head
+++ a/include/linux/huge_mm.h
@@ -260,6 +260,15 @@ static inline spinlock_t *pud_trans_huge
 }
 
 /**
+ * thp_head - Head page of a transparent huge page.
+ * @page: Any page (tail, head or regular) found in the page cache.
+ */
+static inline struct page *thp_head(struct page *page)
+{
+	return compound_head(page);
+}
+
+/**
  * thp_order - Order of a transparent huge page.
  * @page: Head page of a transparent huge page.
  */
@@ -335,6 +344,12 @@ static inline struct list_head *page_def
 #define HPAGE_PUD_MASK ({ BUILD_BUG(); 0; })
 #define HPAGE_PUD_SIZE ({ BUILD_BUG(); 0; })
 
+static inline struct page *thp_head(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	return page;
+}
+
 static inline unsigned int thp_order(struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(PageTail(page), page);
_
