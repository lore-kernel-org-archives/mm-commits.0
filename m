Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAA4C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjBCGgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjBCGfk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250227E075
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4226B82980
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3D1C433D2;
        Fri,  3 Feb 2023 06:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406135;
        bh=aZ0c+RwgItp7LCuishFnR1Fe5AVRBq+rXEMeVDV5P9I=;
        h=Date:To:From:Subject:From;
        b=KTs8SJnI78XvjKNvs63eXtnNiQUgniFqdXGuqLp2OBkKNNmH4eVb91rsmNiAaWkq6
         0OJf09Nqb+/m2+RoIje58GPs3skSo7MUFWLSxST+KVsbKg5UQ+EjwaQcPhqsTctjMA
         Y0kVmayckWcmIzSjH/o+eaKE5kpVL0znRsI0NwbM=
Date:   Thu, 02 Feb 2023 22:35:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] doc-clarify-refcount-section-by-referring-to-folios-pages.patch removed from -mm tree
Message-Id: <20230203063535.7A3D1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: doc: clarify refcount section by referring to folios & pages
has been removed from the -mm tree.  Its filename was
     doc-clarify-refcount-section-by-referring-to-folios-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: doc: clarify refcount section by referring to folios & pages
Date: Wed, 11 Jan 2023 14:28:49 +0000

Include the rename of subpages_mapcount to _nr_pages_mapped.

Link: https://lkml.kernel.org/r/20230111142915.1001531-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/transhuge.rst~doc-clarify-refcount-section-by-referring-to-folios-pages
+++ a/Documentation/mm/transhuge.rst
@@ -112,20 +112,20 @@ Refcounts and transparent huge pages
 Refcounting on THP is mostly consistent with refcounting on other compound
 pages:
 
-  - get_page()/put_page() and GUP operate on head page's ->_refcount.
+  - get_page()/put_page() and GUP operate on the folio->_refcount.
 
   - ->_refcount in tail pages is always zero: get_page_unless_zero() never
     succeeds on tail pages.
 
-  - map/unmap of PMD entry for the whole compound page increment/decrement
-    ->compound_mapcount, stored in the first tail page of the compound page;
-    and also increment/decrement ->subpages_mapcount (also in the first tail)
-    by COMPOUND_MAPPED when compound_mapcount goes from -1 to 0 or 0 to -1.
+  - map/unmap of a PMD entry for the whole THP increment/decrement
+    folio->_entire_mapcount and also increment/decrement
+    folio->_nr_pages_mapped by COMPOUND_MAPPED when _entire_mapcount
+    goes from -1 to 0 or 0 to -1.
 
-  - map/unmap of sub-pages with PTE entry increment/decrement ->_mapcount
-    on relevant sub-page of the compound page, and also increment/decrement
-    ->subpages_mapcount, stored in first tail page of the compound page, when
-    _mapcount goes from -1 to 0 or 0 to -1: counting sub-pages mapped by PTE.
+  - map/unmap of individual pages with PTE entry increment/decrement
+    page->_mapcount and also increment/decrement folio->_nr_pages_mapped
+    when page->_mapcount goes from -1 to 0 or 0 to -1 as this counts
+    the number of pages mapped by PTE.
 
 split_huge_page internally has to distribute the refcounts in the head
 page to the tail pages before clearing all PG_head/tail bits from the page
_

Patches currently in -mm which might be from willy@infradead.org are


