Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADA2C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJCVEu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiJCVEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9146F5FD4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D2F0610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3ABC433C1;
        Mon,  3 Oct 2022 21:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831079;
        bh=sHyk/qPBr94qBAJ8oWgQhNXl67AiVnLhaw3X/odc4fg=;
        h=Date:To:From:Subject:From;
        b=yxMkElg/Bc9vM6cIYPVAlHz3ZvjdeE7pNL/1yAwMxGQ88EAVbLO674lCl1jIWvv58
         /RHZMYXSTWsHA67kySW6B3yVOsjSENiiuCc+dmP3shKQiceusOUmz7F+ildIix42tZ
         mRcfB9OF2eV4cjXob7xgcF+khBMM3z/bI/yL5pUM=
Date:   Mon, 03 Oct 2022 14:04:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reimplement-folio_order-and-folio_nr_pages.patch removed from -mm tree
Message-Id: <20221003210439.6D3ABC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: reimplement folio_order() and folio_nr_pages()
has been removed from the -mm tree.  Its filename was
     mm-reimplement-folio_order-and-folio_nr_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: reimplement folio_order() and folio_nr_pages()
Date: Fri, 2 Sep 2022 20:45:59 +0100

Instead of calling compound_order() and compound_nr_pages(), use the folio
directly.  Saves 1905 bytes from mm/filemap.o due to folio_test_large()
now being a cheaper check than PageHead().

Link: https://lkml.kernel.org/r/20220902194653.1739778-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-reimplement-folio_order-and-folio_nr_pages
+++ a/include/linux/mm.h
@@ -729,7 +729,9 @@ static inline unsigned int compound_orde
  */
 static inline unsigned int folio_order(struct folio *folio)
 {
-	return compound_order(&folio->page);
+	if (!folio_test_large(folio))
+		return 0;
+	return folio->_folio_order;
 }
 
 #include <linux/huge_mm.h>
@@ -1659,7 +1661,13 @@ static inline void set_page_links(struct
  */
 static inline long folio_nr_pages(struct folio *folio)
 {
-	return compound_nr(&folio->page);
+	if (!folio_test_large(folio))
+		return 1;
+#ifdef CONFIG_64BIT
+	return folio->_folio_nr_pages;
+#else
+	return 1L << folio->_folio_order;
+#endif
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are


