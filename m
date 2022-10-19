Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBEBC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiJSXFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiJSXFW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:05:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A9D15B30A
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 372B3CE2493
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A36AC433C1;
        Wed, 19 Oct 2022 23:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666220677;
        bh=Z8vP8h8ue/wKlJSnR/00u73QBbdGgsg7NUkysMNKQBY=;
        h=Date:To:From:Subject:From;
        b=mFLwIVxsWWQ7U8EeL44Nb0r5gUevUD+cgahBrm4hWz1utOu5aON4paQ+cCmED6S8d
         X/KuaO8SC0Dey1IBI9jwz0L/dxLzh4TVb1c78ODFPzNWFS6013Ob1Nvf8X8M536fkI
         8cNgtlwsqDHsDzQjGizRZ7J1gmXrL5tWl2o8zv90=
Date:   Wed, 19 Oct 2022 16:04:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20221019230437.8A36AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: convert split_huge_pages_in_file() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/huge_memory: convert split_huge_pages_in_file() to use a folio
Date: Wed, 19 Oct 2022 19:33:29 +0100

Patch series "Remove FGP_HEAD flag".

We have just two users left of the FGP_HEAD flag and both of them are
better off; sometimes startlingly so as a result of conversion to use
folios.


This patch (of 4):

Removes a number of calls to compound_head() and a call to
pagecache_get_page().

Link: https://lkml.kernel.org/r/20221019183332.2802139-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20221019183332.2802139-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -3011,28 +3011,28 @@ static int split_huge_pages_in_file(cons
 	mapping = candidate->f_mapping;
 
 	for (index = off_start; index < off_end; index += nr_pages) {
-		struct page *fpage = pagecache_get_page(mapping, index,
-						FGP_ENTRY | FGP_HEAD, 0);
+		struct folio *folio = __filemap_get_folio(mapping, index,
+						FGP_ENTRY, 0);
 
 		nr_pages = 1;
-		if (xa_is_value(fpage) || !fpage)
+		if (xa_is_value(folio) || !folio)
 			continue;
 
-		if (!is_transparent_hugepage(fpage))
+		if (!folio_test_large(folio))
 			goto next;
 
 		total++;
-		nr_pages = thp_nr_pages(fpage);
+		nr_pages = folio_nr_pages(folio);
 
-		if (!trylock_page(fpage))
+		if (!folio_trylock(folio))
 			goto next;
 
-		if (!split_huge_page(fpage))
+		if (!split_folio(folio))
 			split++;
 
-		unlock_page(fpage);
+		folio_unlock(folio);
 next:
-		put_page(fpage);
+		folio_put(folio);
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch
mm-swap-convert-find_get_incore_page-to-use-folios.patch
mm-convert-find_get_incore_page-to-filemap_get_incore_folio.patch
mm-remove-fgp_head.patch

