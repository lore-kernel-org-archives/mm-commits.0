Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DBFC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjBCGgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjBCGf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E398C1F6
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 15BA4CE2EA1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79466C433D2;
        Fri,  3 Feb 2023 06:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406151;
        bh=ugNyyGw4QgJLJV/9RLYTp5GuUIBIZ/QsUBeO25p7YJE=;
        h=Date:To:From:Subject:From;
        b=OkfRSbuB8ZgvmX6y5Bn8wYoGRRxMzzAHIB/uK9X10uaF+IYg3/kzMJilUkAixG1BJ
         yDXy+GLJVJ1w0iBjDdsf5B4ePguVMMPA+sos6A3twa/Cw3kg1X7uOJX+WOHGKfzwA7
         aWvMIzv4IVb/+hxjdGHRTUK2ynU1Nc1nGpO0hNqg=
Date:   Thu, 02 Feb 2023 22:35:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch removed from -mm tree
Message-Id: <20230203063551.79466C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert set_compound_page_dtor() and set_compound_order() to folios
has been removed from the -mm tree.  Its filename was
     mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert set_compound_page_dtor() and set_compound_order() to folios
Date: Wed, 11 Jan 2023 14:29:04 +0000

Replace uses of compound_dtor, compound_order and compound_nr by their
folio equivalents.

Link: https://lkml.kernel.org/r/20230111142915.1001531-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios
+++ a/include/linux/mm.h
@@ -984,8 +984,11 @@ extern compound_page_dtor * const compou
 static inline void set_compound_page_dtor(struct page *page,
 		enum compound_dtor_id compound_dtor)
 {
+	struct folio *folio = (struct folio *)page;
+
 	VM_BUG_ON_PAGE(compound_dtor >= NR_COMPOUND_DTORS, page);
-	page[1].compound_dtor = compound_dtor;
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	folio->_folio_dtor = compound_dtor;
 }
 
 static inline void folio_set_compound_dtor(struct folio *folio,
@@ -999,9 +1002,11 @@ void destroy_large_folio(struct folio *f
 
 static inline void set_compound_order(struct page *page, unsigned int order)
 {
-	page[1].compound_order = order;
+	struct folio *folio = (struct folio *)page;
+
+	folio->_folio_order = order;
 #ifdef CONFIG_64BIT
-	page[1].compound_nr = 1U << order;
+	folio->_folio_nr_pages = 1U << order;
 #endif
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


