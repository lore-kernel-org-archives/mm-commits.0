Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C35C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiLAALE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiLAAJE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:09:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238EE87C96
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C86A6B81D6A
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B847C433D6;
        Thu,  1 Dec 2022 00:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852983;
        bh=fPLkUpyXDgT2lWNzUdleEy3HEBGJM5IMYj1wyv/tWy4=;
        h=Date:To:From:Subject:From;
        b=AZpvlxmdWxstWiq14CHlQLdczDq/xsLpk0h47y+/QeQGq0p4nwwC0uIQjx0UhVRbJ
         Mop6UhpKJ2tDyLNMZQWQhNTrEHyPt+W2578tkxSWKR88lWk9imJJ3xtfObTpqUdOXY
         SUYu77aeEDXaFOK1dYFe8e0ifdrMdtxXyA2zfq5U=
Date:   Wed, 30 Nov 2022 16:03:02 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-sys-class-bdi-bdi-max_ratio_fine-knob.patch removed from -mm tree
Message-Id: <20221201000303.7B847C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add /sys/class/bdi/<bdi>/max_ratio_fine knob
has been removed from the -mm tree.  Its filename was
     mm-add-sys-class-bdi-bdi-max_ratio_fine-knob.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


