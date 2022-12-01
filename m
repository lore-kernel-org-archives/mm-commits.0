Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD78AC4708D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiLAAIo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiLAAHO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:07:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E071B9F6
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67F25B81D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1355BC43146;
        Thu,  1 Dec 2022 00:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852965;
        bh=VZgMnyS5ewyoDMvHjUEyuURX1OBdy3j3GJmQGy4QaWg=;
        h=Date:To:From:Subject:From;
        b=F3jNBMyvwBZnaDkZs9RrUx7p6qDuvn+CKsoCRO06vlaUY4l0frBowlARXHPo+kGTw
         McJxuk7cGl0hN8aS6OOgW7gUCITgFbvh7+Ko2onQRi67JGXWMWcJV//+0Z54tyw7ZV
         QbQ+P9wQQc3BESKDdJOyniCZmPx9IGlRExq2cg+4=
Date:   Wed, 30 Nov 2022 16:02:44 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-knob-sys-class-bdi-bdi-strict_limit.patch removed from -mm tree
Message-Id: <20221201000245.1355BC43146@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add knob /sys/class/bdi/<bdi>/strict_limit
has been removed from the -mm tree.  Its filename was
     mm-add-knob-sys-class-bdi-bdi-strict_limit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


