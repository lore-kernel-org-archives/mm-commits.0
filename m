Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B6EC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiKUWSe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiKUWSB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:18:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A861F193C4
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 471066149F
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D22DC433C1;
        Mon, 21 Nov 2022 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069077;
        bh=/GYGbhvE2qnRaumdShZIe41b7u97C2k/mEUerPCFLbM=;
        h=Date:To:From:Subject:From;
        b=PUtDNRpxPB7XYUiQ6XSoJT2i8y81sJ39JrGFR37B5SJY41/+9sLcz6NxN97LnraUO
         twJDBsqg/MpsUJ2RaGYSrsBWwCfE3YlBTb5dM6wFmEUxvLwvCS2XRZ45DKgV+2sMFl
         mx69Ucy2U16Jo+zAC3Brsc5dDQM5b6SZJSDFfMbI=
Date:   Mon, 21 Nov 2022 14:17:56 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-sys-class-bdi-bdi-min_bytes-knob.patch added to mm-unstable branch
Message-Id: <20221121221757.9D22DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add /sys/class/bdi/<bdi>/min_bytes knob
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-sys-class-bdi-bdi-min_bytes-knob.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-sys-class-bdi-bdi-min_bytes-knob.patch

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
Subject: mm: add /sys/class/bdi/<bdi>/min_bytes knob
Date: Fri, 18 Nov 2022 16:52:08 -0800

bdi has two existing knobs to limit the amount of dirty memory:
min_ratio and max_ratio. However the granularity of the knobs is limited
and often it is more convenient to specify limits in terms of bytes.
This change adds the min_bytes knob.

It does not store the min_bytes value, instead it converts the max_bytes
value to a ratio. The value is therefore more an approximation than an
absolute value.

It also maintains the sum over all the bdi min_ratio values stored in
the variable bdi_min_ratio.

Link: https://lkml.kernel.org/r/20221119005215.3052436-14-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/mm/backing-dev.c~mm-add-sys-class-bdi-bdi-min_bytes-knob
+++ a/mm/backing-dev.c
@@ -199,6 +199,34 @@ static ssize_t max_ratio_store(struct de
 }
 BDI_SHOW(max_ratio, bdi->max_ratio / BDI_RATIO_SCALE)
 
+static ssize_t min_bytes_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n", bdi_get_min_bytes(bdi));
+}
+
+static ssize_t min_bytes_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	u64 bytes;
+	ssize_t ret;
+
+	ret = kstrtoull(buf, 10, &bytes);
+	if (ret < 0)
+		return ret;
+
+	ret = bdi_set_min_bytes(bdi, bytes);
+	if (!ret)
+		ret = count;
+
+	return ret;
+}
+DEVICE_ATTR_RW(min_bytes);
+
 static ssize_t max_bytes_show(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
@@ -269,6 +297,7 @@ static struct attribute *bdi_dev_attrs[]
 	&dev_attr_read_ahead_kb.attr,
 	&dev_attr_min_ratio.attr,
 	&dev_attr_max_ratio.attr,
+	&dev_attr_min_bytes.attr,
 	&dev_attr_max_bytes.attr,
 	&dev_attr_stable_pages_required.attr,
 	&dev_attr_strict_limit.attr,
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

