Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01D5C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiKUWRk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiKUWRj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:17:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A95CB1E3
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:17:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D56B8169D
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5E9C433D6;
        Mon, 21 Nov 2022 22:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069051;
        bh=cnpuFSTRnqk3S1ljBWYp/Ey92k6QzT4x3oWDlgvDQro=;
        h=Date:To:From:Subject:From;
        b=zupT3M6GtF9wegIkV2t2VMgxsC/+ukGOiGTtZtJz9kp8uaA0Ooxh+gJepG+wjXbH0
         p0EqIW87RU8K/9hGWcFSbY8XqfyFP0P0F/X4RET1Y3VjsGBZyV8t9y8QzXsniHG30k
         z54wWxs6RLC5jXIbg/9Uz0uXbHmDuaQMlMx4uexU=
Date:   Mon, 21 Nov 2022 14:17:30 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-bdi_set_strict_limit-function.patch added to mm-unstable branch
Message-Id: <20221121221731.CF5E9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add bdi_set_strict_limit() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-bdi_set_strict_limit-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-bdi_set_strict_limit-function.patch

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
Subject: mm: add bdi_set_strict_limit() function
Date: Fri, 18 Nov 2022 16:51:56 -0800

Patch series "mm/block: add bdi sysfs knobs", v4.

At meta network block devices (nbd) are used to implement remote block
storage.  In testing and during production it has been observed that these
network block devices can consume a huge portion of the dirty writeback
cache and writeback can take a considerable time.

To be able to give stricter limits, I'm proposing the following changes:

1) introduce strictlimit knob

  Currently the max_ratio knob exists to limit the dirty_memory. However
  this knob only applies once (dirty_ratio + dirty_background_ratio) / 2
  has been reached.
  With the BDI_CAP_STRICTLIMIT flag, the max_ratio can be applied without
  reaching that limit. This change exposes that knob.

  This knob can also be useful for NFS, fuse filesystems and USB devices.

2) Use part of 1000000 internal calculation

  The max_ratio is based on percentage. With the current machine sizes
  percentage values can be very high (1% of a 256GB main memory is already
  2.5GB). This change uses part of 1000000 instead of percentages for the
  internal calculations.

3) Introduce two new sysfs knobs: min_bytes and max_bytes.

  Currently all calculations are based on ratio, but for a user it often
  more convenient to specify a limit in bytes. The new knobs will not
  store bytes values, instead they will translate the byte value to a
  corresponding ratio. As the internal values are now part of 1000, the
  ratio is closer to the specified value. However the value should be more
  seen as an approximation as it can fluctuate over time.


3) Introduce two new sysfs knobs: min_ratio_fine and max_ratio_fine.

  The granularity for the existing sysfs bdi knobs min_ratio and max_ratio
  is based on percentage values. The new sysfs bdi knobs min_ratio_fine
  and max_ratio_fine allow to specify the ratio as part of 1 million.


This patch (of 20):

This adds the bdi_set_strict_limit function to be able to set/unset the
BDI_CAP_STRICTLIMIT flag.

Link: https://lkml.kernel.org/r/20221119005215.3052436-1-shr@devkernel.io
Link: https://lkml.kernel.org/r/20221119005215.3052436-2-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <clm@meta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

--- a/include/linux/backing-dev.h~mm-add-bdi_set_strict_limit-function
+++ a/include/linux/backing-dev.h
@@ -104,6 +104,7 @@ static inline unsigned long wb_stat_erro
 
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
+int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
 
 /*
  * Flags in backing_dev_info::capability
--- a/mm/page-writeback.c~mm-add-bdi_set_strict_limit-function
+++ a/mm/page-writeback.c
@@ -698,6 +698,21 @@ int bdi_set_max_ratio(struct backing_dev
 }
 EXPORT_SYMBOL(bdi_set_max_ratio);
 
+int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit)
+{
+	if (strict_limit > 1)
+		return -EINVAL;
+
+	spin_lock_bh(&bdi_lock);
+	if (strict_limit)
+		bdi->capabilities |= BDI_CAP_STRICTLIMIT;
+	else
+		bdi->capabilities &= ~BDI_CAP_STRICTLIMIT;
+	spin_unlock_bh(&bdi_lock);
+
+	return 0;
+}
+
 static unsigned long dirty_freerun_ceiling(unsigned long thresh,
 					   unsigned long bg_thresh)
 {
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

