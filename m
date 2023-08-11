Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3217BC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbjHKW7w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbjHKW71 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A012235B3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 350EC678C4
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8E2C433C7;
        Fri, 11 Aug 2023 22:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794752;
        bh=KVMmxVzhQY6F8UlpyISa/KXdJT+rDT/lzy7RJzewmDs=;
        h=Date:To:From:Subject:From;
        b=z0DuXtS2+4ng5iXSwp1nTvLGWdOvWUUlpUWH9lNb+Lx3sg+Dc8ZCYlcWZQxHYOBCf
         ogUfjA8NrE0O1tb3dB9a28b3+vcnSxxwZ0pYFjv7TZDi1ndYGyiDTgl709YtDnQGJ8
         TKN6KjMNa0MbJYW2P6JSp9QjgTvXkCbWQ6SkU40U=
Date:   Fri, 11 Aug 2023 15:59:12 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        rcampbell@nvidia.com, jhubbard@nvidia.com, apopple@nvidia.com,
        mpenttil@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-try-to-handle-swapcache-pages.patch removed from -mm tree
Message-Id: <20230811225912.8B8E2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate_device: try to handle swapcache pages
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-try-to-handle-swapcache-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


