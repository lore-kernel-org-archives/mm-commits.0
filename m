Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462C9C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19ABB2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195872;
	bh=MCq44S2ZvMhwVwuloi9AKcj2f0XwMhqAwrLK7qLYs0o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HKQcBi/UP+ccsS6FuqIxSoFlC+zxTigpo0gweaurhQkzhD8Fk3wlr2gNi39rEAIFi
	 WLGsu/bSWQtIWyDjZYbjtSFiQWOF0WkM2rFxPivrFQywIHZ/LRDREx2dCF9k1PTYRr
	 rjLItOBBxFkLdfRESUQt3kJYip+bLM00r8mokrCI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHLBbL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBbL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1588D206B2;
        Wed, 12 Aug 2020 01:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195871;
        bh=MCq44S2ZvMhwVwuloi9AKcj2f0XwMhqAwrLK7qLYs0o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HMm50+gtYSoLxfUrDtncPoOs4qbeYENbVSjZb5YiOoBPiuHuMd9nIUAhSCz7KB6+8
         g0FFjDfSbl4ku+7IsxGAHYk5PtyEG20P5hSb/0ZARnDfBSrgS08ERdWkbM2d8E0Rj+
         2SrwHgNgfxACDwpSwoEPHGiyLcj7jKLIon9SKACI=
Date:   Tue, 11 Aug 2020 18:31:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        alexander.h.duyck@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 017/165] mm/compaction: correct the comments of
 compact_defer_shift
Message-ID: <20200812013110.FCYEcuM_r%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
