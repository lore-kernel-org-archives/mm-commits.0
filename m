Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E50C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7ADF2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266103;
	bh=XWGBfrYsXDeO+d07LgrFXQGAJ1109LmL+S6/Nx9tMZA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u8BJU3IcvL+joNIEXiPnlgIMjpnJmQmF0HwG70tziwuyr9Dq9cnr3IGIBAUstU7dw
	 1mwEPMj5JnoTP9Cl82ekdQZ2xd4o/c/fxgF9UnN31s/BfkvTNeOa4IGxA6NbyhF544
	 i1LEwq/OuIIkU3DhiL2okHFYNDNT5LyHa2paG824=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHLVBn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHLVBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72FA82080C;
        Wed, 12 Aug 2020 21:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266102;
        bh=XWGBfrYsXDeO+d07LgrFXQGAJ1109LmL+S6/Nx9tMZA=;
        h=Date:From:To:Subject:From;
        b=ZrCLsrEhOICClF/y0iSb16L+qZmDWBM59OefluBrJcprjg5KL0S/5W/OWkpY3sl97
         xSbEh7QLr7XnAnfEipYjuSK9gtddiD/7DbCVe1Qv4rK/TOA2KtFJqJGVGGuPq0WptP
         uh/w3z+TrVJf7UZ5/lXPMPvYozpeEMjqmXxMk/sk=
Date:   Wed, 12 Aug 2020 14:01:42 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-compaction-correct-the-comments-of-compact_defer_shift.patch removed
 from -mm tree
Message-ID: <20200812210142.GR9OMlbw6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: correct the comments of compact_defer_shift
has been removed from the -mm tree.  Its filename was
     mm-compaction-correct-the-comments-of-compact_defer_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/compaction: correct the comments of compact_defer_shift

There is no compact_defer_limit. It should be compact_defer_shift in
use. and add compact_order_failed explanation.

Link: http://lkml.kernel.org/r/3bd60e1b-a74e-050d-ade4-6e8f54e00b92@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/compaction.c        |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-compaction-correct-the-comments-of-compact_defer_shift
+++ a/include/linux/mmzone.h
@@ -536,6 +536,7 @@ struct zone {
 	 * On compaction failure, 1<<compact_defer_shift compactions
 	 * are skipped before trying again. The number attempted since
 	 * last failure is tracked with compact_considered.
+	 * compact_order_failed is the minimum compaction failed order.
 	 */
 	unsigned int		compact_considered;
 	unsigned int		compact_defer_shift;
--- a/mm/compaction.c~mm-compaction-correct-the-comments-of-compact_defer_shift
+++ a/mm/compaction.c
@@ -154,7 +154,7 @@ EXPORT_SYMBOL(__ClearPageMovable);
 
 /*
  * Compaction is deferred when compaction fails to result in a page
- * allocation success. 1 << compact_defer_limit compactions are skipped up
+ * allocation success. 1 << compact_defer_shift, compactions are skipped up
  * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
  */
 void defer_compaction(struct zone *zone, int order)
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are


