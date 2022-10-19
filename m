Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68D0C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiJSXFK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiJSXFE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:05:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A32CBB067
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:04:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E17D0B8261A
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91710C433D6;
        Wed, 19 Oct 2022 23:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666220679;
        bh=TLmPSU0Pv4S6qk+MsfGb4dSbl4jSXsyTzaS/n/nEejI=;
        h=Date:To:From:Subject:From;
        b=vYeX3LccMmNaaQIB2nSszFM0G7vkCq8rS+p9aW/ZQYUeacjnm0wC4YTCk1VEIkEOZ
         h4mvmc1bUrKcygJNZOM0ebmFSoBmlbGVJgsllX+dI5C5gJtSkoyIxxo8YDotNzSA6b
         XWvzINDzu0DHrGV5mUG/KXbVDL17eX11M+QtZppo=
Date:   Wed, 19 Oct 2022 16:04:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-find_get_incore_page-to-use-folios.patch added to mm-unstable branch
Message-Id: <20221019230439.91710C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert find_get_incore_page to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-find_get_incore_page-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-find_get_incore_page-to-use-folios.patch

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
Subject: mm/swap: convert find_get_incore_page to use folios
Date: Wed, 19 Oct 2022 19:33:30 +0100

Eliminates a use of FGP_HEAD and saves 35 bytes of text.

Link: https://lkml.kernel.org/r/20221019183332.2802139-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/swap_state.c~mm-swap-convert-find_get_incore_page-to-use-folios
+++ a/mm/swap_state.c
@@ -386,17 +386,14 @@ struct page *find_get_incore_page(struct
 {
 	swp_entry_t swp;
 	struct swap_info_struct *si;
-	struct page *page = pagecache_get_page(mapping, index,
-						FGP_ENTRY | FGP_HEAD, 0);
+	struct folio *folio = __filemap_get_folio(mapping, index, FGP_ENTRY, 0);
 
-	if (!page)
-		return page;
-	if (!xa_is_value(page))
-		return find_subpage(page, index);
+	if (!xa_is_value(folio))
+		goto out;
 	if (!shmem_mapping(mapping))
 		return NULL;
 
-	swp = radix_to_swp_entry(page);
+	swp = radix_to_swp_entry(folio);
 	/* There might be swapin error entries in shmem mapping. */
 	if (non_swap_entry(swp))
 		return NULL;
@@ -404,9 +401,13 @@ struct page *find_get_incore_page(struct
 	si = get_swap_device(swp);
 	if (!si)
 		return NULL;
-	page = find_get_page(swap_address_space(swp), swp_offset(swp));
+	index = swp_offset(swp);
+	folio = filemap_get_folio(swap_address_space(swp), index);
 	put_swap_device(si);
-	return page;
+out:
+	if (!folio)
+		return NULL;
+	return folio_file_page(folio, index);
 }
 
 struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch
mm-swap-convert-find_get_incore_page-to-use-folios.patch
mm-convert-find_get_incore_page-to-filemap_get_incore_folio.patch
mm-remove-fgp_head.patch

