Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5ACC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88C6720674
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790437;
	bh=2ErhYNp3UqS807TJAxBo50UacYbzT3+4fO9H3m2OQpQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SYMVsOPi5wDtL6kkSBv2C5bCK+TN/Xh5IuDxGMiUMdfOiPvDPpcTCoYwwHgNK/PRc
	 Su3DT7tmM85zCT0wC/uxnigccu85szeqHRxK6cHKZAxDma+r4Jo9LbqKfILEHjgIcT
	 uNPK5hZRgnWG9VM7N63NaVE9sJ1xRmP8cWrFkpFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgHRWkg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgHRWkc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAAF20674;
        Tue, 18 Aug 2020 22:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790431;
        bh=2ErhYNp3UqS807TJAxBo50UacYbzT3+4fO9H3m2OQpQ=;
        h=Date:From:To:Subject:From;
        b=R8jJChL7JnpoeeVn3GBqYV7uMVtU1GAGqTfywyxgxzUL2WvOk5stcFDVdxgrGZOM8
         dahG657zHv/UK0i5R0etssuaLnM3oJBTgigjDSPWsUMs09q9d2RTstj+5dV747JeEy
         vkozdv3ZrdyHnWOy4WHxeTuKiW13CH6138Imb1RE=
Date:   Tue, 18 Aug 2020 15:40:31 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-add-thp_head.patch removed from -mm tree
Message-ID: <20200818224031.E_F0YTBxU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add thp_head
has been removed from the -mm tree.  Its filename was
     mm-add-thp_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are


