Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AF7C43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiKIBkg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiKIBju (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FAE6711D
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9402CB81CDA
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CB9C4347C;
        Wed,  9 Nov 2022 01:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957943;
        bh=YUO3SvVC2moLB4rpdDk16qKj4YvlGZvV5TwaB75lK0M=;
        h=Date:To:From:Subject:From;
        b=Iz6cX0xBKtOW1ogZk77E5I7w+w6FXFzDC4p2lcSuNCm+dagAo7WKg/zpz3oPTX0k9
         Sbwq/ZmGFdpCwJDIIdWyy9vQL/h9E3AVULOPL6CM684wW8BQyVjdX9lDxW1EEF00bF
         OoMjzfVWFFhzIyRggHL7xa6JF8/Yos7PMgBPjgwk=
Date:   Tue, 08 Nov 2022 17:39:02 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221109013903.42CB9C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: convert split_huge_pages_in_file() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3066,28 +3066,28 @@ static int split_huge_pages_in_file(cons
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


