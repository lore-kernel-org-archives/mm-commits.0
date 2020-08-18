Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851CBC433E3
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6489320786
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790430;
	bh=u92yGYqmRn1h2dEjbClwAVj7biiVxlYI6dKTnOAa5MQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=p99ZdTlp0O43lpJJQB7i3qfC0Qy3M+yB2hKjC9vLohXHhswrYeSJ1fDY+OhUITU27
	 Yy8kiQTwNut9TLp7lGSHSv4pesfl4f/CgDE7v6U141zPkPozZadyCzVzvhJt7EFEPF
	 PSpqOYT0JXg3dunQsoc4I7V+YeN42TMRS2hf4IO0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgHRWk3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgHRWk0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F9DD20674;
        Tue, 18 Aug 2020 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790425;
        bh=u92yGYqmRn1h2dEjbClwAVj7biiVxlYI6dKTnOAa5MQ=;
        h=Date:From:To:Subject:From;
        b=B3PwNa9BvPk96wgdu5LoTCMhxGdmiZz414kXt7N5ZXHuzNXManEsGHooJRonP/zAV
         JZgJ3sCFScnqeuKLkzzaP8AyVBUlhJ5ntXFszKkoTGcRI4xtIEw748ZbeoEDgELxVg
         LkTYTL6jNTEHEVJNsQ71W1zxzcpKLwaO4+eMz89o=
Date:   Tue, 18 Aug 2020 15:40:25 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-add-thp_order.patch removed from -mm tree
Message-ID: <20200818224025.6EBAi4zU1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add thp_order
has been removed from the -mm tree.  Its filename was
     mm-add-thp_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are


