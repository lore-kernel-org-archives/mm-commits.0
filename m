Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552E0C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjBCGmO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbjBCGku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E488FB59
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E317261D99
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43057C433D2;
        Fri,  3 Feb 2023 06:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406265;
        bh=WtE1gm4RH3RkJO+x1DBBrdBv0s8UBLfNExtgQxKjllE=;
        h=Date:To:From:Subject:From;
        b=EfYNSrR8Il+uocE7Un5AwRAOsFdnvSYN4kaMXPU3PZRmrbU90B7Zpe24s+tboOVE1
         HVNkqWbfjbqn2kd7RU+VMJosveeBsN7LYTNhac2MQsNBhfiwvQY2L8HhdjvPRsMAws
         N7ATvZ2hvNUyiNcknN251vCznMjmMwvIWQ+gjeX0=
Date:   Thu, 02 Feb 2023 22:37:44 -0800
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-convert-readahead_expand-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230203063745.43057C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: readahead: convert readahead_expand() to use a folio
has been removed from the -mm tree.  Its filename was
     readahead-convert-readahead_expand-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: readahead: convert readahead_expand() to use a folio
Date: Mon, 16 Jan 2023 19:39:41 +0000

Replace the uses of page with a folio.  Also add a missing test for
workingset in the leading edge expansion.

Link: https://lkml.kernel.org/r/20230116193941.2148487-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/readahead.c~readahead-convert-readahead_expand-to-use-a-folio
+++ a/mm/readahead.c
@@ -801,21 +801,25 @@ void readahead_expand(struct readahead_c
 	/* Expand the leading edge downwards */
 	while (ractl->_index > new_index) {
 		unsigned long index = ractl->_index - 1;
-		struct page *page = xa_load(&mapping->i_pages, index);
+		struct folio *folio = xa_load(&mapping->i_pages, index);
 
-		if (page && !xa_is_value(page))
-			return; /* Page apparently present */
+		if (folio && !xa_is_value(folio))
+			return; /* Folio apparently present */
 
-		page = __page_cache_alloc(gfp_mask);
-		if (!page)
+		folio = filemap_alloc_folio(gfp_mask, 0);
+		if (!folio)
 			return;
-		if (add_to_page_cache_lru(page, mapping, index, gfp_mask) < 0) {
-			put_page(page);
+		if (filemap_add_folio(mapping, folio, index, gfp_mask) < 0) {
+			folio_put(folio);
 			return;
 		}
-
+		if (unlikely(folio_test_workingset(folio)) &&
+				!ractl->_workingset) {
+			ractl->_workingset = true;
+			psi_memstall_enter(&ractl->_pflags);
+		}
 		ractl->_nr_pages++;
-		ractl->_index = page->index;
+		ractl->_index = folio->index;
 	}
 
 	new_len += new_start - readahead_pos(ractl);
@@ -824,19 +828,20 @@ void readahead_expand(struct readahead_c
 	/* Expand the trailing edge upwards */
 	while (ractl->_nr_pages < new_nr_pages) {
 		unsigned long index = ractl->_index + ractl->_nr_pages;
-		struct page *page = xa_load(&mapping->i_pages, index);
+		struct folio *folio = xa_load(&mapping->i_pages, index);
 
-		if (page && !xa_is_value(page))
-			return; /* Page apparently present */
+		if (folio && !xa_is_value(folio))
+			return; /* Folio apparently present */
 
-		page = __page_cache_alloc(gfp_mask);
-		if (!page)
+		folio = filemap_alloc_folio(gfp_mask, 0);
+		if (!folio)
 			return;
-		if (add_to_page_cache_lru(page, mapping, index, gfp_mask) < 0) {
-			put_page(page);
+		if (filemap_add_folio(mapping, folio, index, gfp_mask) < 0) {
+			folio_put(folio);
 			return;
 		}
-		if (unlikely(PageWorkingset(page)) && !ractl->_workingset) {
+		if (unlikely(folio_test_workingset(folio)) &&
+				!ractl->_workingset) {
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
_

Patches currently in -mm which might be from willy@infradead.org are


