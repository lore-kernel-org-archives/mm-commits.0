Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C55C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbjBCGmN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjBCGku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68508FB5A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9761AB8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E6AC433EF;
        Fri,  3 Feb 2023 06:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406264;
        bh=sEbtcJkslBadnJRhD26EFvWOI/TfPelLaFYxZExTMsw=;
        h=Date:To:From:Subject:From;
        b=XGy7WqGMgojIp0S/BiVQHJ3NJSisBCCkmPDfSb56ipv/SXPJkVqfS7rcTAEPeRyvp
         yWv9WyuPzoVFN+OgYIYmNpY4gNxpXwfDMmOz/K7wRWQsejy97rwz6X6SHn2D990lB7
         ig4CUarZ/hOM9+KKYM/5u1qDzsjFo86SzyuPF5yQ=
Date:   Thu, 02 Feb 2023 22:37:43 -0800
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-convert-filemap_range_has_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230203063744.47E6AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: convert filemap_range_has_page() to use a folio
has been removed from the -mm tree.  Its filename was
     filemap-convert-filemap_range_has_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: convert filemap_range_has_page() to use a folio
Date: Mon, 16 Jan 2023 19:39:40 +0000

The folio isn't returned from this function, so this is an entirely
internal change.

Link: https://lkml.kernel.org/r/20230116193941.2148487-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/filemap.c~filemap-convert-filemap_range_has_page-to-use-a-folio
+++ a/mm/filemap.c
@@ -470,7 +470,7 @@ EXPORT_SYMBOL(filemap_flush);
 bool filemap_range_has_page(struct address_space *mapping,
 			   loff_t start_byte, loff_t end_byte)
 {
-	struct page *page;
+	struct folio *folio;
 	XA_STATE(xas, &mapping->i_pages, start_byte >> PAGE_SHIFT);
 	pgoff_t max = end_byte >> PAGE_SHIFT;
 
@@ -479,11 +479,11 @@ bool filemap_range_has_page(struct addre
 
 	rcu_read_lock();
 	for (;;) {
-		page = xas_find(&xas, max);
-		if (xas_retry(&xas, page))
+		folio = xas_find(&xas, max);
+		if (xas_retry(&xas, folio))
 			continue;
 		/* Shadow entries don't count */
-		if (xa_is_value(page))
+		if (xa_is_value(folio))
 			continue;
 		/*
 		 * We don't need to try to pin this page; we're about to
@@ -494,7 +494,7 @@ bool filemap_range_has_page(struct addre
 	}
 	rcu_read_unlock();
 
-	return page != NULL;
+	return folio != NULL;
 }
 EXPORT_SYMBOL(filemap_range_has_page);
 
_

Patches currently in -mm which might be from willy@infradead.org are


