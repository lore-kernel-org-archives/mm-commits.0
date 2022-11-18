Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D79C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 22:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiKRWJg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 17:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiKRWJB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 17:09:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EAA67F41
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 14:08:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 944C5627AD
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 22:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BD4C433D6;
        Fri, 18 Nov 2022 22:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668809327;
        bh=2R4T+PZp00KLOxcdLSr0KZJsVRnpgdy6LM10NMaq3Tw=;
        h=Date:To:From:Subject:From;
        b=fk2QDlMT1cpCrhixI6qt7hQuRh/pOoqG0luQ7aOc0BQL2uYVcRBtgPVaP3v/BvQQU
         7+55db0f7VhEtZ7hBEI6nbI3DADrxwmzhJvt1ASdi8GjZ1nKe/5OgMEPjpDJ+fi5zt
         WBr6y3gr+Zg9D4kIQKwE4bazgBW1uRpSoI33jeDM=
Date:   Fri, 18 Nov 2022 14:08:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        naoya.horiguchi@nec.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-failure-convert-truncate_error_page-to-use-folio.patch added to mm-unstable branch
Message-Id: <20221118220846.E6BD4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: convert truncate_error_page() to use folio
has been added to the -mm mm-unstable branch.  Its filename is
     memory-failure-convert-truncate_error_page-to-use-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-failure-convert-truncate_error_page-to-use-folio.patch

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

ext4-convert-move_extent_per_page-to-use-folios.patch
khugepage-replace-try_to_release_page-with-filemap_release_folio.patch
memory-failure-convert-truncate_error_page-to-use-folio.patch
folio-compat-remove-try_to_release_page.patch

