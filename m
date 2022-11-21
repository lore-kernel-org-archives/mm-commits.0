Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21948C43217
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiKUWRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiKUWRp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:17:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B121310B4F
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E3C4614BE
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9056C433D6;
        Mon, 21 Nov 2022 22:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069060;
        bh=p5pwt8rBhrA6yF/xW4lHsFUR75Vb4omm33f7h/BfV0s=;
        h=Date:To:From:Subject:From;
        b=QM29qZ5SIv68Q7yhKYkahf+RW/DW1S2UwbII8AGBD9am3C7VgOys5f1qVM2O6wIAc
         Hmfr8G7FhTGlhjj2gscnLiEFplEURwCoGGP/s7o9qAO43XCWO3fcTdPIbUcHhGytd5
         QF+Z5rtgiDEUrzJIc86GQ+e4LiJOHFif+iQ2DS60=
Date:   Mon, 21 Nov 2022 14:17:40 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-bdi_get_max_bytes-function.patch added to mm-unstable branch
Message-Id: <20221121221740.A9056C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add bdi_get_max_bytes() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-bdi_get_max_bytes-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-bdi_get_max_bytes-function.patch

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
Subject: mm: add bdi_get_max_bytes() function
Date: Fri, 18 Nov 2022 16:52:00 -0800

This adds a function to return the specified value for max_bytes. It
converts the stored max_ratio of the bdi to the corresponding bytes
value. It introduces the bdi_get_bytes helper function to do the
conversion. This is an approximation as it is based on the value that is
returned by global_dirty_limits(), which can change. The helper function
will also be used by the min_bytes bdi knob.

Link: https://lkml.kernel.org/r/20221119005215.3052436-6-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/backing-dev.h~mm-add-bdi_get_max_bytes-function
+++ a/include/linux/backing-dev.h
@@ -105,6 +105,7 @@ static inline unsigned long wb_stat_erro
 /* BDI ratio is expressed as part per 1000000 for finer granularity. */
 #define BDI_RATIO_SCALE 10000
 
+u64 bdi_get_max_bytes(struct backing_dev_info *bdi);
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
--- a/mm/page-writeback.c~mm-add-bdi_get_max_bytes-function
+++ a/mm/page-writeback.c
@@ -650,6 +650,18 @@ void wb_domain_exit(struct wb_domain *do
  */
 static unsigned int bdi_min_ratio;
 
+static u64 bdi_get_bytes(unsigned int ratio)
+{
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	u64 bytes;
+
+	global_dirty_limits(&background_thresh, &dirty_thresh);
+	bytes = (dirty_thresh * PAGE_SIZE * ratio) / BDI_RATIO_SCALE / 100;
+
+	return bytes;
+}
+
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	unsigned int delta;
@@ -701,6 +713,11 @@ int bdi_set_max_ratio(struct backing_dev
 }
 EXPORT_SYMBOL(bdi_set_max_ratio);
 
+u64 bdi_get_max_bytes(struct backing_dev_info *bdi)
+{
+	return bdi_get_bytes(bdi->max_ratio);
+}
+
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit)
 {
 	if (strict_limit > 1)
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

