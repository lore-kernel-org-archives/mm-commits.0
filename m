Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D264EC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiLAALO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiLAAJW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:09:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0E88930B
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFBFF6176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09789C433D6;
        Thu,  1 Dec 2022 00:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852986;
        bh=/0RUqSNm56OFDqAzGrQSCbjrPC4e85qY+nEOS2owWM4=;
        h=Date:To:From:Subject:From;
        b=erWZyFEY71fBypz+QU+OKPLrauLyhCBj4d3chCgsYCcGjp4HfBY/NeGf1N35eN23F
         i4PFbAS/wzzL3sQh+74OwRuMQYB7Zg8iX32ZE/EwWSfK7Evq8cKT+kmY6GfFnYQmb0
         wM/4IsP512KBQHqd4yWwEVkSqkY2lPWZ+NFx+BGE=
Date:   Wed, 30 Nov 2022 16:03:05 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-bdi_set_min_ratio_no_scale-function.patch removed from -mm tree
Message-Id: <20221201000306.09789C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add bdi_set_min_ratio_no_scale() function
has been removed from the -mm tree.  Its filename was
     mm-add-bdi_set_min_ratio_no_scale-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: add bdi_set_min_ratio_no_scale() function
Date: Fri, 18 Nov 2022 16:52:13 -0800

This introduces bdi_set_min_ratio_no_scale(). It uses the max
granularity for the ratio. This function by the new sysfs knob
min_ratio_fine.

Link: https://lkml.kernel.org/r/20221119005215.3052436-19-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/include/linux/backing-dev.h~mm-add-bdi_set_min_ratio_no_scale-function
+++ a/include/linux/backing-dev.h
@@ -109,6 +109,7 @@ u64 bdi_get_min_bytes(struct backing_dev
 u64 bdi_get_max_bytes(struct backing_dev_info *bdi);
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
+int bdi_set_min_ratio_no_scale(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio_no_scale(struct backing_dev_info *bdi, unsigned int max_ratio);
 int bdi_set_min_bytes(struct backing_dev_info *bdi, u64 min_bytes);
 int bdi_set_max_bytes(struct backing_dev_info *bdi, u64 max_bytes);
--- a/mm/page-writeback.c~mm-add-bdi_set_min_ratio_no_scale-function
+++ a/mm/page-writeback.c
@@ -690,6 +690,8 @@ static int __bdi_set_min_ratio(struct ba
 	unsigned int delta;
 	int ret = 0;
 
+	if (min_ratio > 100 * BDI_RATIO_SCALE)
+		return -EINVAL;
 	min_ratio *= BDI_RATIO_SCALE;
 
 	spin_lock_bh(&bdi_lock);
@@ -734,6 +736,11 @@ static int __bdi_set_max_ratio(struct ba
 	return ret;
 }
 
+int bdi_set_min_ratio_no_scale(struct backing_dev_info *bdi, unsigned int min_ratio)
+{
+	return __bdi_set_min_ratio(bdi, min_ratio);
+}
+
 int bdi_set_max_ratio_no_scale(struct backing_dev_info *bdi, unsigned int max_ratio)
 {
 	return __bdi_set_max_ratio(bdi, max_ratio);
_

Patches currently in -mm which might be from shr@devkernel.io are


