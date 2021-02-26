Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACAFC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB2A64F1F
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhBZAkE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:40:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231375AbhBZAkD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:40:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ACD964F1B;
        Fri, 26 Feb 2021 00:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614299962;
        bh=yTAs5cWVV/9nnr/O+xLM1+UQvRoTnPM/yjXmYFphuSM=;
        h=Date:From:To:Subject:From;
        b=GkfTpYVyVks24ErDqFTvrn2o97K76/2j07Tsk8VF06VzMhQITGcxghbjx1jmY3VHB
         wJcNQNo9LD0H2FK8ktcGri5iVBVFT0nFfKePhy9XGsC8wr6B8P1zbv+e55QuomOK/g
         3ST0uyfR10Up6z/9nJy/4colNE+rvLYtn8jnqL2s=
Date:   Thu, 25 Feb 2021 16:39:21 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, riel@surriel.com, rppt@linux.ibm.com,
        vvghjk1234@gmail.com
Subject:  [folded-merged]
 mm-cma-allocate-cma-areas-bottom-up-fix.patch removed from -mm tree
Message-ID: <20210226003921.b9uqqZsRR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocate-cma-areas-bottom-up-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-allocate-cma-areas-bottom-up-fix.patch

This patch was dropped because it was folded into mm-cma-allocate-cma-areas-bottom-up.patch

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-cma-allocate-cma-areas-bottom-up-fix

whitespace fix, per Mike

Link: https://lkml.kernel.org/r/20201221170551.GB3428478@carbon.DHCP.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up-fix
+++ a/mm/cma.c
@@ -344,8 +344,7 @@ int __init cma_declare_contiguous_nid(ph
 		 * Avoid using first 4GB to not interfere with constrained zones
 		 * like DMA/DMA32.
 		 */
-		if (!memblock_bottom_up() &&
-		    memblock_end >= SZ_4G + size) {
+		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
 			memblock_set_bottom_up(true);
 			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
 							limit, nid, true);
_

Patches currently in -mm which might be from guro@fb.com are

mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix-2.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

