Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C731C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjBCGgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjBCGfp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F0D2687A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2190EB8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9FCC433D2;
        Fri,  3 Feb 2023 06:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406141;
        bh=Gx+ku84xjnAPqWLL8NGTmVuy9tIbdyJToYFOk/xNwHQ=;
        h=Date:To:From:Subject:From;
        b=LOYmsggz/KhIBwKE25LWrSupn6h1Ax0foXoM0M75jNJ6EraR+3l1MGuexTc3d9XLJ
         AZIKCj8md+r16lO6nXURzlAXw/OzfO+LZtMLi1sL8XvSz7Y7wfwwd4KeA/7/YgWTNs
         K9aPsltb78DtCDDtHDgsVs+ATyIUiH7prHQ8XHQ8=
Date:   Thu, 02 Feb 2023 22:35:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] page_alloc-use-folio-fields-directly.patch removed from -mm tree
Message-Id: <20230203063541.BE9FCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: page_alloc: use folio fields directly
has been removed from the -mm tree.  Its filename was
     page_alloc-use-folio-fields-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: page_alloc: use folio fields directly
Date: Wed, 11 Jan 2023 14:28:55 +0000

Rmove the uses of compound_mapcount_ptr(), head_compound_mapcount() and
subpages_mapcount_ptr()

Link: https://lkml.kernel.org/r/20230111142915.1001531-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~page_alloc-use-folio-fields-directly
+++ a/mm/page_alloc.c
@@ -779,8 +779,8 @@ static void prep_compound_head(struct pa
 
 	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
 	set_compound_order(page, order);
-	atomic_set(compound_mapcount_ptr(page), -1);
-	atomic_set(subpages_mapcount_ptr(page), 0);
+	atomic_set(&folio->_entire_mapcount, -1);
+	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
 }
 
@@ -1309,12 +1309,12 @@ static int free_tail_pages_check(struct
 	switch (page - head_page) {
 	case 1:
 		/* the first tail page: these may be in place of ->mapping */
-		if (unlikely(head_compound_mapcount(head_page))) {
-			bad_page(page, "nonzero compound_mapcount");
+		if (unlikely(folio_entire_mapcount(folio))) {
+			bad_page(page, "nonzero entire_mapcount");
 			goto out;
 		}
-		if (unlikely(atomic_read(subpages_mapcount_ptr(head_page)))) {
-			bad_page(page, "nonzero subpages_mapcount");
+		if (unlikely(atomic_read(&folio->_nr_pages_mapped))) {
+			bad_page(page, "nonzero nr_pages_mapped");
 			goto out;
 		}
 		if (unlikely(atomic_read(&folio->_pincount))) {
_

Patches currently in -mm which might be from willy@infradead.org are


