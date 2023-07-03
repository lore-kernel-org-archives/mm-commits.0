Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B032EB64D9
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 00:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjGCATh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 20:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGCATg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 20:19:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E56D1B9
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:19:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FA2760C83
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 00:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9FEC433C7;
        Mon,  3 Jul 2023 00:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688343574;
        bh=tj28QYAjoltje6BULRlJ6uDu009l/5fOn0+Fiso3GFU=;
        h=Date:To:From:Subject:From;
        b=aqvV5UkUwNibvDj+PebkzdBNVRcHGCHuWO6htVt1udRaUwz0RNw8Oe9E35eUbM8KG
         x0x+QgSPbZBQu49Si6A+QyNfcQqyuW9gTQTKtlGjrHWrB0eKoQmlaPOCkzODvn35IL
         2KXbkRCCWmPHwlAielgq1GiUeZWzguKlHFyJZfps=
Date:   Sun, 02 Jul 2023 17:19:33 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        rcampbell@nvidia.com, jhubbard@nvidia.com, apopple@nvidia.com,
        mpenttil@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-try-to-handle-swapcache-pages.patch added to mm-unstable branch
Message-Id: <20230703001934.6B9FEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate_device: try to handle swapcache pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-try-to-handle-swapcache-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-try-to-handle-swapcache-pages.patch

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
From: Mika Penttilä <mpenttil@redhat.com>
Subject: mm/migrate_device: try to handle swapcache pages
Date: Wed, 7 Jun 2023 20:29:44 +0300

Migrating file pages and swapcache pages into device memory is not
supported.  Try to get rid of the swap cache, and if successful, go ahead
as with other anonymous pages.

Link: https://lkml.kernel.org/r/20230607172944.11713-1-mpenttil@redhat.com
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-try-to-handle-swapcache-pages
+++ a/mm/migrate_device.c
@@ -727,13 +727,22 @@ static void __migrate_device_pages(unsig
 
 		if (is_device_private_page(newpage) ||
 		    is_device_coherent_page(newpage)) {
-			/*
-			 * For now only support anonymous memory migrating to
-			 * device private or coherent memory.
-			 */
 			if (mapping) {
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-				continue;
+				struct folio *folio;
+
+				folio = page_folio(page);
+
+				/*
+				 * For now only support anonymous memory migrating to
+				 * device private or coherent memory.
+				 *
+				 * Try to get rid of swap cache if possible.
+				 */
+				if (!folio_test_anon(folio) ||
+				    !folio_free_swap(folio)) {
+					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+					continue;
+				}
 			}
 		} else if (is_zone_device_page(newpage)) {
 			/*
_

Patches currently in -mm which might be from mpenttil@redhat.com are

mm-migrate_device-try-to-handle-swapcache-pages.patch

