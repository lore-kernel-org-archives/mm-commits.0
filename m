Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3DEECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiILD36 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA3F27CD8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5416B8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F38C433D7;
        Mon, 12 Sep 2022 03:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953325;
        bh=tFGIGa8kTCAvio4B/7n2sONFSZEGPAzt5n8mnk3GWmY=;
        h=Date:To:From:Subject:From;
        b=kpDaMEgX664Q6kJAKilGFXinhQPaLy2kfsquHBYcaNzkt9NmWdEF8FiUoI8844TMb
         2m/zIBLQx3JsmwfNFiPe1CFDUKrDz5ZL4pNvDVNAXQ+MjQ91jEF3E39Ud2Fo9z0EP5
         OX7U+4b8SV51HsLezL2oiQfnITMAtXIWhfR09nrE=
Date:   Sun, 11 Sep 2022 20:28:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-util-reduce-stack-usage-of-folio_mapcount.patch removed from -mm tree
Message-Id: <20220912032845.80F38C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/util: reduce stack usage of folio_mapcount
has been removed from the -mm tree.  Its filename was
     mm-util-reduce-stack-usage-of-folio_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/util: reduce stack usage of folio_mapcount
Date: Tue, 2 Aug 2022 01:31:55 +0800

folio_test_hugetlb() will call PageHeadHuge which is a function call,
and blocks the compiler from recognizing this redundant load.

After rearranging the code, stack usage is dropped from 32 to 24, and
the function size is smaller (tested on GCC 12):

Before:
Stack usage:
mm/util.c:845:5:folio_mapcount  32      static
Size:
0000000000000ea0 00000000000000c7 T folio_mapcount

After:
Stack usage:
mm/util.c:845:5:folio_mapcount  24      static
Size:
0000000000000ea0 00000000000000b0 T folio_mapcount

Link: https://lkml.kernel.org/r/20220801173155.92008-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-util-reduce-stack-usage-of-folio_mapcount
+++ a/mm/util.c
@@ -850,10 +850,10 @@ int folio_mapcount(struct folio *folio)
 		return atomic_read(&folio->_mapcount) + 1;
 
 	compound = folio_entire_mapcount(folio);
-	nr = folio_nr_pages(folio);
 	if (folio_test_hugetlb(folio))
 		return compound;
 	ret = compound;
+	nr = folio_nr_pages(folio);
 	for (i = 0; i < nr; i++)
 		ret += atomic_read(&folio_page(folio, i)->_mapcount) + 1;
 	/* File pages has compound_mapcount included in _mapcount */
_

Patches currently in -mm which might be from kasong@tencent.com are


