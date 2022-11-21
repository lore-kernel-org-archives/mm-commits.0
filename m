Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC126C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiKUWRr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiKUWRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:17:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB04101EF
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:17:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF2D061495
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A2EC433C1;
        Mon, 21 Nov 2022 22:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069058;
        bh=/X6uI7UHX/ypgLqc2jtfPrQ4xiF5FQDSLt/aHdfYNMU=;
        h=Date:To:From:Subject:From;
        b=cu7STMHi5k7ufkmlZGLuc2+Bg/5feO/ShU6WeHzwj4PIbJMJOC0oRncd65Pdye4nC
         2vyasVJ/R95xjYUR9y3b2C7WahN2GDbrOuf/NvWgpDNTCp2oA7hXq4b45max0GNBlw
         xI9c3yWjQFiU+6SUTRArxL2y410uu9Y7t/W15aww=
Date:   Mon, 21 Nov 2022 14:17:37 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-part-per-1000000-for-bdi-ratios.patch added to mm-unstable branch
Message-Id: <20221121221738.20A2EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use part per 1000000 for bdi ratios.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-part-per-1000000-for-bdi-ratios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-part-per-1000000-for-bdi-ratios.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: use part per 1000000 for bdi ratios.
Date: Fri, 18 Nov 2022 16:51:59 -0800

To get finer granularity for ratio calculations use part per million
instead of percentiles. This is especially important if we want to
automatically convert byte values to ratios. Otherwise the values that
are actually used can be quite different. This is also important for
machines with more main memory (1% of 256GB is already 2.5GB).

Link: https://lkml.kernel.org/r/20221119005215.3052436-5-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    3 +++
 mm/backing-dev.c            |    6 +++---
 mm/page-writeback.c         |   15 +++++++++------
 3 files changed, 15 insertions(+), 9 deletions(-)

--- a/include/linux/backing-dev.h~mm-use-part-per-1000000-for-bdi-ratios
+++ a/include/linux/backing-dev.h
@@ -102,6 +102,9 @@ static inline unsigned long wb_stat_erro
 #endif
 }
 
+/* BDI ratio is expressed as part per 1000000 for finer granularity. */
+#define BDI_RATIO_SCALE 10000
+
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
--- a/mm/backing-dev.c~mm-use-part-per-1000000-for-bdi-ratios
+++ a/mm/backing-dev.c
@@ -178,7 +178,7 @@ static ssize_t min_ratio_store(struct de
 
 	return ret;
 }
-BDI_SHOW(min_ratio, bdi->min_ratio)
+BDI_SHOW(min_ratio, bdi->min_ratio / BDI_RATIO_SCALE)
 
 static ssize_t max_ratio_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
@@ -197,7 +197,7 @@ static ssize_t max_ratio_store(struct de
 
 	return ret;
 }
-BDI_SHOW(max_ratio, bdi->max_ratio)
+BDI_SHOW(max_ratio, bdi->max_ratio / BDI_RATIO_SCALE)
 
 static ssize_t stable_pages_required_show(struct device *dev,
 					  struct device_attribute *attr,
@@ -809,7 +809,7 @@ int bdi_init(struct backing_dev_info *bd
 
 	kref_init(&bdi->refcnt);
 	bdi->min_ratio = 0;
-	bdi->max_ratio = 100;
+	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
--- a/mm/page-writeback.c~mm-use-part-per-1000000-for-bdi-ratios
+++ a/mm/page-writeback.c
@@ -197,7 +197,7 @@ static void wb_min_max_ratio(struct bdi_
 			min *= this_bw;
 			min = div64_ul(min, tot_bw);
 		}
-		if (max < 100) {
+		if (max < 100 * BDI_RATIO_SCALE) {
 			max *= this_bw;
 			max = div64_ul(max, tot_bw);
 		}
@@ -655,6 +655,8 @@ int bdi_set_min_ratio(struct backing_dev
 	unsigned int delta;
 	int ret = 0;
 
+	min_ratio *= BDI_RATIO_SCALE;
+
 	spin_lock_bh(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
@@ -665,7 +667,7 @@ int bdi_set_min_ratio(struct backing_dev
 			bdi->min_ratio = min_ratio;
 		} else {
 			delta = min_ratio - bdi->min_ratio;
-			if (bdi_min_ratio + delta < 100) {
+			if (bdi_min_ratio + delta < 100 * BDI_RATIO_SCALE) {
 				bdi_min_ratio += delta;
 				bdi->min_ratio = min_ratio;
 			} else {
@@ -684,6 +686,7 @@ int bdi_set_max_ratio(struct backing_dev
 
 	if (max_ratio > 100)
 		return -EINVAL;
+	max_ratio *= BDI_RATIO_SCALE;
 
 	spin_lock_bh(&bdi_lock);
 	if (bdi->min_ratio > max_ratio) {
@@ -775,15 +778,15 @@ static unsigned long __wb_calc_thresh(st
 	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
 
-	wb_thresh = (thresh * (100 - bdi_min_ratio)) / 100;
+	wb_thresh = (thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio)) / (100 * BDI_RATIO_SCALE);
 	wb_thresh *= numerator;
 	wb_thresh = div64_ul(wb_thresh, denominator);
 
 	wb_min_max_ratio(dtc->wb, &wb_min_ratio, &wb_max_ratio);
 
-	wb_thresh += (thresh * wb_min_ratio) / 100;
-	if (wb_thresh > (thresh * wb_max_ratio) / 100)
-		wb_thresh = thresh * wb_max_ratio / 100;
+	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
+	if (wb_thresh > (thresh * wb_max_ratio) / (100 * BDI_RATIO_SCALE))
+		wb_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
 
 	return wb_thresh;
 }
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-add-bdi_set_strict_limit-function.patch
mm-add-knob-sys-class-bdi-bdi-strict_limit.patch
mm-document-sys-class-bdi-bdi-strict_limit-knob.patch
mm-use-part-per-1000000-for-bdi-ratios.patch
mm-add-bdi_get_max_bytes-function.patch
mm-split-off-__bdi_set_max_ratio-function.patch
mm-add-bdi_set_max_bytes-function.patch
mm-add-knob-sys-class-bdi-bdi-max_bytes.patch
mm-document-sys-class-bdi-bdi-max_bytes-knob.patch
mm-add-bdi_get_min_bytes-function.patch
mm-split-off-__bdi_set_min_ratio-function.patch
mm-add-bdi_set_min_bytes-function.patch
mm-add-sys-class-bdi-bdi-min_bytes-knob.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob.patch
mm-add-bdi_set_max_ratio_no_scale-function.patch
mm-add-sys-class-bdi-bdi-max_ratio_fine-knob.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch
mm-add-bdi_set_min_ratio_no_scale-function.patch
mm-add-sys-class-bdi-bdi-min_ratio_fine-knob.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob.patch

