Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA666C47090
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiLAAIn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiLAAGk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABACD60D3
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1954BB81D88
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB711C433D6;
        Thu,  1 Dec 2022 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852958;
        bh=OKnHKw8ih3yxQFCtFK2b5xnD1MYchJOqftKSGp4j0II=;
        h=Date:To:From:Subject:From;
        b=YzxPGhFcXRWnbkzsWdaTrK5bhaz43soT3FpRp0J83C/Drb9yQ67jcuqnu6zvdEBCT
         iQLx+Rn2vLiBvFraaxlD14g3I8bVsn/eKqkIBT3SpUw11GfReKIWxh2a9kCcAu08Xd
         MU//UuefKoVGdxYeCPc0w50CNg6hJ4WwjodwXzZ8=
Date:   Wed, 30 Nov 2022 16:02:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        naoya.horiguchi@nec.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-failure-convert-truncate_error_page-to-use-folio.patch removed from -mm tree
Message-Id: <20221201000238.BB711C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory-failure: convert truncate_error_page() to use folio
has been removed from the -mm tree.  Its filename was
     memory-failure-convert-truncate_error_page-to-use-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: memory-failure: convert truncate_error_page() to use folio
Date: Thu, 17 Nov 2022 23:30:54 -0800

Replace try_to_release_page() with filemap_release_folio().  This change
is in preparation for the removal of the try_to_release_page() wrapper.

Link: https://lkml.kernel.org/r/20221118073055.55694-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~memory-failure-convert-truncate_error_page-to-use-folio
+++ a/mm/memory-failure.c
@@ -840,12 +840,13 @@ static int truncate_error_page(struct pa
 	int ret = MF_FAILED;
 
 	if (mapping->a_ops->error_remove_page) {
+		struct folio *folio = page_folio(p);
 		int err = mapping->a_ops->error_remove_page(mapping, p);
 
 		if (err != 0) {
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
-		} else if (page_has_private(p) &&
-			   !try_to_release_page(p, GFP_NOIO)) {
+		} else if (folio_has_private(folio) &&
+			   !filemap_release_folio(folio, GFP_NOIO)) {
 			pr_info("%#lx: failed to release buffers\n", pfn);
 		} else {
 			ret = MF_RECOVERED;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch
fuse-convert-fuse_try_move_page-to-use-folios.patch
userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch
khugepage-replace-lru_cache_add-with-folio_add_lru.patch
folio-compat-remove-lru_cache_add.patch

