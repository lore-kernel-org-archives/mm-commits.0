Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21839C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiJCVGb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJCVFn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE51B17897
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A35F9B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1B9C433D7;
        Mon,  3 Oct 2022 21:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831111;
        bh=y28UZ+ioJLR+zRtH0UZNM2eVLIJnKG1GxhPujIKmOOA=;
        h=Date:To:From:Subject:From;
        b=fAVHT5ibWAqggmd1r7BYSVSyxfnZ4MQGQETJtn828boyYv6ume/Frkfkc+X7c50Yv
         vJoFKVEu2LuEKBzL0uBCXljEkRtuc07GdGNY2QoB2HNrTqp/E3BXzN7B5EeaXh2kTf
         zLKaNS+zLVBUPisRyNXyPfZ6MFG1WLUixHzDyh6E=
Date:   Mon, 03 Oct 2022 14:05:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-call-shmem_get_folio.patch removed from -mm tree
Message-Id: <20221003210511.5E1B9C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: khugepaged: call shmem_get_folio()
has been removed from the -mm tree.  Its filename was
     khugepaged-call-shmem_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: khugepaged: call shmem_get_folio()
Date: Fri, 2 Sep 2022 20:46:27 +0100

shmem_getpage() is being removed, so call its replacement and find the
precise page ourselves.

Link: https://lkml.kernel.org/r/20220902194653.1739778-32-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +++++--
 mm/shmem.c      |    4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~khugepaged-call-shmem_get_folio
+++ a/mm/khugepaged.c
@@ -1647,13 +1647,16 @@ static int collapse_file(struct mm_struc
 			}
 
 			if (xa_is_value(page) || !PageUptodate(page)) {
+				struct folio *folio;
+
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
-				if (shmem_getpage(mapping->host, index, &page,
-						  SGP_NOALLOC)) {
+				if (shmem_get_folio(mapping->host, index,
+						&folio, SGP_NOALLOC)) {
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
+				page = folio_file_page(folio, index);
 			} else if (trylock_page(page)) {
 				get_page(page);
 				xas_unlock_irq(&xas);
--- a/mm/shmem.c~khugepaged-call-shmem_get_folio
+++ a/mm/shmem.c
@@ -3158,7 +3158,7 @@ static const char *shmem_get_link(struct
 		folio = filemap_get_folio(inode->i_mapping, 0);
 		if (!folio)
 			return ERR_PTR(-ECHILD);
-		if (PageHWPoison(&folio->page) ||
+		if (PageHWPoison(folio_page(folio, 0)) ||
 		    !folio_test_uptodate(folio)) {
 			folio_put(folio);
 			return ERR_PTR(-ECHILD);
@@ -3169,7 +3169,7 @@ static const char *shmem_get_link(struct
 			return ERR_PTR(error);
 		if (!folio)
 			return ERR_PTR(-ECHILD);
-		if (PageHWPoison(&folio->page)) {
+		if (PageHWPoison(folio_page(folio, 0))) {
 			folio_unlock(folio);
 			folio_put(folio);
 			return ERR_PTR(-ECHILD);
_

Patches currently in -mm which might be from willy@infradead.org are


