Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1C1C38159
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjARXyT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjARXx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:53:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEFE68423
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:53:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1998A61ABA
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0F7C433EF;
        Wed, 18 Jan 2023 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674086006;
        bh=+sB//3zgDWBoZviC/ohehk0c8dwQENvh0voNiTUcZjk=;
        h=Date:To:From:Subject:From;
        b=aUA8oVSzjJvHgOyNUIZPi8W+5Fxw3B9A6XfDC28ja9lSXPT3O4WpD8SMEXGPHCQOG
         khFdDF2lPZuh8HQJN+QdmO8z6QE+z/NT3QKFzFx6XWFyc26iPazb4Fn4mKJmoZ5gb1
         jpmPY6ltWpEWK32C3m7RZqwU1sxVCLZHfj4QBh7s=
Date:   Wed, 18 Jan 2023 15:53:25 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch removed from -mm tree
Message-Id: <20230118235326.6C0F7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swap-convert-deactivate_page-to-folio_deactivate-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch

This patch was dropped because it was folded into mm-swap-convert-deactivate_page-to-folio_deactivate.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-convert-deactivate_page-to-folio_deactivate-fix
Date: Fri Dec 23 09:52:24 AM PST 2022

fix left-over comments, per Yu Zhao

Cc: Yu Zhao <yuzhao@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page-writeback.c~mm-swap-convert-deactivate_page-to-folio_deactivate-fix
+++ a/mm/page-writeback.c
@@ -2846,11 +2846,11 @@ bool folio_mark_dirty(struct folio *foli
 
 	if (likely(mapping)) {
 		/*
-		 * readahead/lru_deactivate_page could remain
+		 * readahead/folio_deactivate could remain
 		 * PG_readahead/PG_reclaim due to race with folio_end_writeback
 		 * About readahead, if the folio is written, the flags would be
 		 * reset. So no problem.
-		 * About lru_deactivate_page, if the folio is redirtied,
+		 * About folio_deactivate, if the folio is redirtied,
 		 * the flag will be reset. So no problem. but if the
 		 * folio is used by readahead it will confuse readahead
 		 * and make it restart the size rampup process. But it's
--- a/mm/vmscan.c~mm-swap-convert-deactivate_page-to-folio_deactivate-fix
+++ a/mm/vmscan.c
@@ -1920,7 +1920,7 @@ retry:
 			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
 				/*
 				 * Immediately reclaim when written back.
-				 * Similar in principle to deactivate_page()
+				 * Similar in principle to folio_deactivate()
 				 * except we already have the folio isolated
 				 * and know it's dirty
 				 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

