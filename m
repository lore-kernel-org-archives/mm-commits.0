Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37B4C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B653064F21
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhBZAkN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231375AbhBZAkG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:40:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B83D364F1F;
        Fri, 26 Feb 2021 00:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614299965;
        bh=BGbmpA/FE/rw7ISzQo6aD1Ej3xRmNHOME0NsXgilsGI=;
        h=Date:From:To:Subject:From;
        b=l78suh3agf4KQP1TxIwKBz/luI944xCH1H+oDxjblYEyMJ+iC6bqtRCeCWkYFv0FK
         lU51xEM4j2SgNLNmos8B4ASkPPCSfCEJCbZy2QJgLnxvmwahbSThLTFvl9cQOf1ENt
         ObleqJ707b6l1bJ2qvK0WKE4R0lFV1yljSVGE67E=
Date:   Thu, 25 Feb 2021 16:39:25 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-cma-allocate-cma-areas-bottom-up-fix-2.patch removed from -mm tree
Message-ID: <20210226003925.cZBLvQ9tx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocate-cma-areas-bottom-up-fix-2
has been removed from the -mm tree.  Its filename was
     mm-cma-allocate-cma-areas-bottom-up-fix-2.patch

This patch was dropped because it was folded into mm-cma-allocate-cma-areas-bottom-up.patch

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-cma-allocate-cma-areas-bottom-up-fix-2

fix 32-bit warnings

Link: https://lkml.kernel.org/r/20201223163537.GA4011967@carbon.DHCP.thefacebook.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up-fix-2
+++ a/mm/cma.c
@@ -344,12 +344,14 @@ int __init cma_declare_contiguous_nid(ph
 		 * Avoid using first 4GB to not interfere with constrained zones
 		 * like DMA/DMA32.
 		 */
+#if BITS_PER_LONG > 32
 		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
 			memblock_set_bottom_up(true);
 			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
 							limit, nid, true);
 			memblock_set_bottom_up(false);
 		}
+#endif
 
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
_

Patches currently in -mm which might be from guro@fb.com are

mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

