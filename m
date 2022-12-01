Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB916C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiLAAIt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiLAAHd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:07:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B08110054
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33692B81D6A
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B78C433B5;
        Thu,  1 Dec 2022 00:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852964;
        bh=lvRm1ZW5PpfSOFPV6rSC3cweZRBh1lzYsZzulhmkfiw=;
        h=Date:To:From:Subject:From;
        b=1glxsJBD6huiNjEgj/NrBO2k5YtsRsKFJi8EGdLbMxxSPfuG+PNjdNhmGBt2oHQLt
         cqpLIM2U0z+NeF8MOjeY7BR8tpNpzTCZedA3znBQSUVrfSycJUtnG59tGOnTDlYZ9M
         Jn96/gSoMm0HAEV2KyhbZ2pHTsa+Y4eJJ3/XwWm0=
Date:   Wed, 30 Nov 2022 16:02:43 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-bdi_set_strict_limit-function.patch removed from -mm tree
Message-Id: <20221201000243.E1B78C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add bdi_set_strict_limit() function
has been removed from the -mm tree.  Its filename was
     mm-add-bdi_set_strict_limit-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


