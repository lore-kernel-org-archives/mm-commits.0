Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94004C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJCVGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJCVFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAED2140D0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E935CE0E7A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BD3C433D6;
        Mon,  3 Oct 2022 21:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831102;
        bh=zDpczQAQjY1M7zCLSegXJBmMgAmT/8/OGjlw5TQi3c0=;
        h=Date:To:From:Subject:From;
        b=eA9yJYzx36nxYdUITYbRgH5uORIC2e1DAx5SsBhBfa50EM1ge7GZlkLCRIKphvrdN
         lUJIJW2me8syPSm9kf8cNsTSfvQQBIc3/cr/mTo6RG35dXak1CLfkLQrngXqysc5Ry
         uj6PgxUp8SkqLM5sRVvgNVU1Xz3StdI0LVQosRNw=
Date:   Mon, 03 Oct 2022 14:05:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_read_mapping_page_gfp-to-use-shmem_get_folio_gfp.patch removed from -mm tree
Message-Id: <20221003210502.66BD3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_read_mapping_page_gfp() to use shmem_get_folio_gfp()
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_read_mapping_page_gfp-to-use-shmem_get_folio_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_read_mapping_page_gfp() to use shmem_get_folio_gfp()
Date: Fri, 2 Sep 2022 20:46:19 +0100

Saves a couple of calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-24-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_read_mapping_page_gfp-to-use-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -4270,18 +4270,20 @@ struct page *shmem_read_mapping_page_gfp
 {
 #ifdef CONFIG_SHMEM
 	struct inode *inode = mapping->host;
+	struct folio *folio;
 	struct page *page;
 	int error;
 
 	BUG_ON(!shmem_mapping(mapping));
-	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
+	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
 				  gfp, NULL, NULL, NULL);
 	if (error)
 		return ERR_PTR(error);
 
-	unlock_page(page);
+	folio_unlock(folio);
+	page = folio_file_page(folio, index);
 	if (PageHWPoison(page)) {
-		put_page(page);
+		folio_put(folio);
 		return ERR_PTR(-EIO);
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are


