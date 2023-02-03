Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369C1C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjBCGgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjBCGf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2CE1C591
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD7A2CE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A040C433EF;
        Fri,  3 Feb 2023 06:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406149;
        bh=Qj/B/mY/VxcIMnUyUI1o1zMjOrGX9VWtzgOeePsBrxE=;
        h=Date:To:From:Subject:From;
        b=vvB/+0SQcpA3Dd8dJLBtl4SYrn3b+IMxtELl9H/G7OC/G2l+p01ZLW9wa8xwZAHzI
         SzHXylLbSjuD6nosytJ9Xpdwh+no7H6y9BIfwMWigsiueHSx5TmF/nPjfabiZpL3do
         x92i3c6TbFbLwJ2cK0h2Mjs+2FzbilDaHYHEliQ8=
Date:   Thu, 02 Feb 2023 22:35:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reimplement-compound_order.patch removed from -mm tree
Message-Id: <20230203063549.1A040C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: reimplement compound_order()
has been removed from the -mm tree.  Its filename was
     mm-reimplement-compound_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: reimplement compound_order()
Date: Wed, 11 Jan 2023 14:29:02 +0000

Make compound_order() use struct folio.  It can't be turned into a wrapper
around folio_order() as a page can be turned into a tail page between a
check in compound_order() and the assertion in folio_test_large().

Link: https://lkml.kernel.org/r/20230111142915.1001531-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-reimplement-compound_order
+++ a/include/linux/mm.h
@@ -719,11 +719,20 @@ int vma_is_stack_for_current(struct vm_a
 struct mmu_gather;
 struct inode;
 
+/*
+ * compound_order() can be called without holding a reference, which means
+ * that niceties like page_folio() don't work.  These callers should be
+ * prepared to handle wild return values.  For example, PG_head may be
+ * set before _folio_order is initialised, or this may be a tail page.
+ * See compaction.c for some good examples.
+ */
 static inline unsigned int compound_order(struct page *page)
 {
-	if (!PageHead(page))
+	struct folio *folio = (struct folio *)page;
+
+	if (!test_bit(PG_head, &folio->flags))
 		return 0;
-	return page[1].compound_order;
+	return folio->_folio_order;
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are


