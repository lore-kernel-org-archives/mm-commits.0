Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8A7C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjKHVLq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjKHVLl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:11:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693742102;
        Wed,  8 Nov 2023 13:11:39 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01637C433C7;
        Wed,  8 Nov 2023 21:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699477899;
        bh=UAa24ztjVP+QFjsbJtAy/t47ME/lHe15RagnXlXi8bo=;
        h=Date:To:From:Subject:From;
        b=N13KEtBwh0lb8RAu0LQJQvJEDdmtE40rwON2TBzYXE68xRwM5krjcbZlGINEARWUj
         CEdTRMbu/UTo0o/MI3I4kBfV1+Uy/wH8WyOLQ/ZWKM6tBFh/V0nTbWWmpL+esFrCnn
         9AwtFg82xnZJUgUvzbReMb/wZY55uSdjfpf9uiVo=
Date:   Wed, 08 Nov 2023 13:11:38 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-mapping_evict_folio-in-truncate_error_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20231108211139.01637C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use mapping_evict_folio() in truncate_error_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-use-mapping_evict_folio-in-truncate_error_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-mapping_evict_folio-in-truncate_error_page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: use mapping_evict_folio() in truncate_error_page()
Date: Wed, 8 Nov 2023 18:28:06 +0000

We already have the folio and the mapping, so replace the call to
invalidate_inode_page() with mapping_evict_folio().

Link: https://lkml.kernel.org/r/20231108182809.602073-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-use-mapping_evict_folio-in-truncate_error_page
+++ a/mm/memory-failure.c
@@ -930,10 +930,10 @@ static int delete_from_lru_cache(struct
 static int truncate_error_page(struct page *p, unsigned long pfn,
 				struct address_space *mapping)
 {
+	struct folio *folio = page_folio(p);
 	int ret = MF_FAILED;
 
 	if (mapping->a_ops->error_remove_page) {
-		struct folio *folio = page_folio(p);
 		int err = mapping->a_ops->error_remove_page(mapping, p);
 
 		if (err != 0)
@@ -947,7 +947,7 @@ static int truncate_error_page(struct pa
 		 * If the file system doesn't support it just invalidate
 		 * This fails on dirty or anything with private pages
 		 */
-		if (invalidate_inode_page(p))
+		if (mapping_evict_folio(mapping, folio))
 			ret = MF_RECOVERED;
 		else
 			pr_info("%#lx: Failed to invalidate\n",	pfn);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch

