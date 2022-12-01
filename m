Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8550C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiLAAJz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiLAAIK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:08:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403B82C64F
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E3186176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC333C43470;
        Thu,  1 Dec 2022 00:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852974;
        bh=nuyjF7/IFwE8yZqZs8sjNUFZI2pPF+avtRRjpCKKx4M=;
        h=Date:To:From:Subject:From;
        b=mRTt1T4pK31anKyVYNabqFnIrp5/MnwBLFTvkVPfLvH+U5PJzs7HfvWk5q4cxlYD4
         nUjuOpgzNQoYsHsFIPOtFypT7ZEJmW+TTPUwdAK3Lk267mYxTs8bTcfxP4uce5EQxW
         UajxriW1hGZhQpjU5163yfFXvGySDyHKtHYuy8Do=
Date:   Wed, 30 Nov 2022 16:02:53 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-knob-sys-class-bdi-bdi-max_bytes.patch removed from -mm tree
Message-Id: <20221201000253.DC333C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add knob /sys/class/bdi/<bdi>/max_bytes
has been removed from the -mm tree.  Its filename was
     mm-add-knob-sys-class-bdi-bdi-max_bytes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: add knob /sys/class/bdi/<bdi>/max_bytes
Date: Fri, 18 Nov 2022 16:52:03 -0800

This adds the new knob max_bytes to specify a dirty memory limit for the
corresponding bdi. The specified bytes value is converted to a ratio.

Link: https://lkml.kernel.org/r/20221119005215.3052436-9-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/mm/backing-dev.c~mm-add-knob-sys-class-bdi-bdi-max_bytes
+++ a/mm/backing-dev.c
@@ -199,6 +199,34 @@ static ssize_t max_ratio_store(struct de
 }
 BDI_SHOW(max_ratio, bdi->max_ratio / BDI_RATIO_SCALE)
 
+static ssize_t max_bytes_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n", bdi_get_max_bytes(bdi));
+}
+
+static ssize_t max_bytes_store(struct device *dev,
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
+	ret = bdi_set_max_bytes(bdi, bytes);
+	if (!ret)
+		ret = count;
+
+	return ret;
+}
+DEVICE_ATTR_RW(max_bytes);
+
 static ssize_t stable_pages_required_show(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
@@ -241,6 +269,7 @@ static struct attribute *bdi_dev_attrs[]
 	&dev_attr_read_ahead_kb.attr,
 	&dev_attr_min_ratio.attr,
 	&dev_attr_max_ratio.attr,
+	&dev_attr_max_bytes.attr,
 	&dev_attr_stable_pages_required.attr,
 	&dev_attr_strict_limit.attr,
 	NULL,
_

Patches currently in -mm which might be from shr@devkernel.io are


