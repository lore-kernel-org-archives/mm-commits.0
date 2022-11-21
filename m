Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A49C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiKUWRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiKUWRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:17:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DE165E4
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FACCB810DC
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20609C433C1;
        Mon, 21 Nov 2022 22:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069054;
        bh=dqeehRL7ErYcseoCztDaQZd1F+y2aNRU/KPrPmT1e88=;
        h=Date:To:From:Subject:From;
        b=bO5mDXSBuTrcPBTb77GEqHzOtBN75OjyvTy/Sa+v4nMMy0vOBADy9JhZ+8sAby3c8
         Lk+GQGkYifoXKewFzxSm+9YRmWugaNHcFEEaaS+Asu3E5aCeoIWiHrc6X2nmI15A8q
         3VeesV0diNTs/KdO02k/qqeWGGgO6tcMbrC/E5gU=
Date:   Mon, 21 Nov 2022 14:17:33 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-knob-sys-class-bdi-bdi-strict_limit.patch added to mm-unstable branch
Message-Id: <20221121221734.20609C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add knob /sys/class/bdi/<bdi>/strict_limit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-knob-sys-class-bdi-bdi-strict_limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-knob-sys-class-bdi-bdi-strict_limit.patch

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
Subject: mm: add knob /sys/class/bdi/<bdi>/strict_limit
Date: Fri, 18 Nov 2022 16:51:57 -0800

Add a new knob to /sys/class/bdi/<bdi>/strict_limit. This new knob
allows to set/unset the flag BDI_CAP_STRICTLIMIT in the bdi
capabilities.

Link: https://lkml.kernel.org/r/20221119005215.3052436-3-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/mm/backing-dev.c~mm-add-knob-sys-class-bdi-bdi-strict_limit
+++ a/mm/backing-dev.c
@@ -209,11 +209,40 @@ static ssize_t stable_pages_required_sho
 }
 static DEVICE_ATTR_RO(stable_pages_required);
 
+static ssize_t strict_limit_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	unsigned int strict_limit;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &strict_limit);
+	if (ret < 0)
+		return ret;
+
+	ret = bdi_set_strict_limit(bdi, strict_limit);
+	if (!ret)
+		ret = count;
+
+	return ret;
+}
+
+static ssize_t strict_limit_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n",
+			!!(bdi->capabilities & BDI_CAP_STRICTLIMIT));
+}
+static DEVICE_ATTR_RW(strict_limit);
+
 static struct attribute *bdi_dev_attrs[] = {
 	&dev_attr_read_ahead_kb.attr,
 	&dev_attr_min_ratio.attr,
 	&dev_attr_max_ratio.attr,
 	&dev_attr_stable_pages_required.attr,
+	&dev_attr_strict_limit.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(bdi_dev);
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

