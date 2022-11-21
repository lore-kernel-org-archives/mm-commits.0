Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F81FC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiKUWSy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiKUWSI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:18:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BE624F3B
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:18:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 143ADB816A3
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C071AC43144;
        Mon, 21 Nov 2022 22:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069083;
        bh=kbuu38FvT1WR1EOe9RIJ4bKb7yd57VYZXL2SD8dnrzg=;
        h=Date:To:From:Subject:From;
        b=WQWfknv6mYoZ+qG4cn6bWlm7BMWif22vO5OAQGML9atuXXJO5whbCBf+Pzzsxd1RJ
         C93MBw3iW6lEJbZscKoy+E5oJwq9NcxGob0sc7mKCVovh4mLFsjDgAd5OTUFM3fO/K
         V/cuyieHDdv6etng8p3YosL1dSTe/MpyvRWcy06A=
Date:   Mon, 21 Nov 2022 14:18:03 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-sys-class-bdi-bdi-max_ratio_fine-knob.patch added to mm-unstable branch
Message-Id: <20221121221803.C071AC43144@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add /sys/class/bdi/<bdi>/max_ratio_fine knob
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-sys-class-bdi-bdi-max_ratio_fine-knob.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-sys-class-bdi-bdi-max_ratio_fine-knob.patch

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
Subject: mm: add /sys/class/bdi/<bdi>/max_ratio_fine knob
Date: Fri, 18 Nov 2022 16:52:11 -0800

This adds the max_ratio_fine knob. The knob specifies the values not
based on 1 of 100, but instead 1 per million.

Link: https://lkml.kernel.org/r/20221119005215.3052436-17-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/backing-dev.c~mm-add-sys-class-bdi-bdi-max_ratio_fine-knob
+++ a/mm/backing-dev.c
@@ -199,6 +199,25 @@ static ssize_t max_ratio_store(struct de
 }
 BDI_SHOW(max_ratio, bdi->max_ratio / BDI_RATIO_SCALE)
 
+static ssize_t max_ratio_fine_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	unsigned int ratio;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &ratio);
+	if (ret < 0)
+		return ret;
+
+	ret = bdi_set_max_ratio_no_scale(bdi, ratio);
+	if (!ret)
+		ret = count;
+
+	return ret;
+}
+BDI_SHOW(max_ratio_fine, bdi->max_ratio)
+
 static ssize_t min_bytes_show(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
@@ -297,6 +316,7 @@ static struct attribute *bdi_dev_attrs[]
 	&dev_attr_read_ahead_kb.attr,
 	&dev_attr_min_ratio.attr,
 	&dev_attr_max_ratio.attr,
+	&dev_attr_max_ratio_fine.attr,
 	&dev_attr_min_bytes.attr,
 	&dev_attr_max_bytes.attr,
 	&dev_attr_stable_pages_required.attr,
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

