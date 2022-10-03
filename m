Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B660EC43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJCVFO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJCVEo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCA5959C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3058B81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB1DC433D7;
        Mon,  3 Oct 2022 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831080;
        bh=57FSqQ70IfIWcKykeaUVGxqnxVCd10hUf2ij8eWRSuk=;
        h=Date:To:From:Subject:From;
        b=RhrPZCs3oGaBS3XWHz6wj0Mh6mex7eh3SUiCfS2jIRzg100NsQd0MyX5NK/E+PMmj
         qnzGay9PoCWRaixDOeUbTB0SCYhCoZVpz5ukv4eSPHyOyiPCMg/rCtVRdu9GOHtwSS
         0kQFewOjj2xNWnqPoG4XE+tVIImQH66dnwQaKt3g=
Date:   Mon, 03 Oct 2022 14:04:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-split_folio.patch removed from -mm tree
Message-Id: <20221003210440.9DB1DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add split_folio()
has been removed from the -mm tree.  Its filename was
     mm-add-split_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add split_folio()
Date: Fri, 2 Sep 2022 20:46:00 +0100

This wrapper removes a need to use split_huge_page(&folio->page).  Convert
two callers.

Link: https://lkml.kernel.org/r/20220902194653.1739778-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 +++++
 mm/shmem.c              |    2 +-
 mm/truncate.c           |    2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-add-split_folio
+++ a/include/linux/huge_mm.h
@@ -444,6 +444,11 @@ static inline int split_folio_to_list(st
 	return split_huge_page_to_list(&folio->page, list);
 }
 
+static inline int split_folio(struct folio *folio)
+{
+	return split_folio_to_list(folio, NULL);
+}
+
 /*
  * archs that select ARCH_WANTS_THP_SWAP but don't support THP_SWP due to
  * limitations in the implementation like arm64 MTE can override this to
--- a/mm/shmem.c~mm-add-split_folio
+++ a/mm/shmem.c
@@ -629,7 +629,7 @@ next:
 			goto move_back;
 		}
 
-		ret = split_huge_page(&folio->page);
+		ret = split_folio(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 
--- a/mm/truncate.c~mm-add-split_folio
+++ a/mm/truncate.c
@@ -240,7 +240,7 @@ bool truncate_inode_partial_folio(struct
 		folio_invalidate(folio, offset, length);
 	if (!folio_test_large(folio))
 		return true;
-	if (split_huge_page(&folio->page) == 0)
+	if (split_folio(folio) == 0)
 		return true;
 	if (folio_test_dirty(folio))
 		return false;
_

Patches currently in -mm which might be from willy@infradead.org are


