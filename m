Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92416C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiJCVFz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJCVFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1F711C03
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7846F610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08DFC433C1;
        Mon,  3 Oct 2022 21:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831096;
        bh=z+Uje0SYUQzXDw4UX64I+PtbeOA37mp09Zfc0ex6Tjg=;
        h=Date:To:From:Subject:From;
        b=IwlA/lPgZyEszYSEbdGo+5eo+bshZh31Nvu1Ph3BzbQ/EEWKt2EbJdNxYjFjaQ1+r
         UdbIvHSvApsaJjDOrv6Zwsjrwm8F14VoGN7v/J1M66BDVYu0aH2w9vb1wdZSbntmMp
         QmV9rd2X93vlZ3e1QC5IQtSlMZmVXoJvJW7LxdkM=
Date:   Mon, 03 Oct 2022 14:04:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_replace_page-to-shmem_replace_folio.patch removed from -mm tree
Message-Id: <20221003210456.D08DFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_replace_page() to shmem_replace_folio()
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_replace_page-to-shmem_replace_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_replace_page() to shmem_replace_folio()
Date: Fri, 2 Sep 2022 20:46:14 +0100

The caller has a folio, so convert the calling convention and rename the
function.

Link: https://lkml.kernel.org/r/20220902194653.1739778-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_replace_page-to-shmem_replace_folio
+++ a/mm/shmem.c
@@ -1608,7 +1608,7 @@ static bool shmem_should_replace_folio(s
 	return folio_zonenum(folio) > gfp_zone(gfp);
 }
 
-static int shmem_replace_page(struct page **pagep, gfp_t gfp,
+static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 				struct shmem_inode_info *info, pgoff_t index)
 {
 	struct folio *old, *new;
@@ -1617,7 +1617,7 @@ static int shmem_replace_page(struct pag
 	pgoff_t swap_index;
 	int error;
 
-	old = page_folio(*pagep);
+	old = *foliop;
 	entry = folio_swap_entry(old);
 	swap_index = swp_offset(entry);
 	swap_mapping = swap_address_space(entry);
@@ -1666,7 +1666,7 @@ static int shmem_replace_page(struct pag
 		old = new;
 	} else {
 		folio_add_lru(new);
-		*pagep = &new->page;
+		*foliop = new;
 	}
 
 	folio_clear_swapcache(old);
@@ -1772,8 +1772,7 @@ static int shmem_swapin_folio(struct ino
 	arch_swap_restore(swap, folio);
 
 	if (shmem_should_replace_folio(folio, gfp)) {
-		error = shmem_replace_page(&page, gfp, info, index);
-		folio = page_folio(page);
+		error = shmem_replace_folio(&folio, gfp, info, index);
 		if (error)
 			goto failed;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are


