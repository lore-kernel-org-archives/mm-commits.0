Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA04CC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiLAAKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiLAAIm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:08:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7883B83EA7
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2903EB81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A32C433D6;
        Thu,  1 Dec 2022 00:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852979;
        bh=a8AF1G5WLHWuNMu7M6phtjKOxEg9jmSQQdwSgFrjQHo=;
        h=Date:To:From:Subject:From;
        b=fCryiEhyr5iTyku0JwVudbFlY8LZ7QYIn6ZdC9gXdwBhGp0KS/fpjogC8rUJd0pLP
         Mvbt0UjsNMnYptWLNflmOlrJAoLEWpI2a/YDD5rXbJQEasfUGGne/b/XpKFovmtXaa
         +7ZwBdc+Bkm8wYIGN96ZIWuOjz/P/kjhXtvcB6BY=
Date:   Wed, 30 Nov 2022 16:02:59 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-sys-class-bdi-bdi-min_bytes-knob.patch removed from -mm tree
Message-Id: <20221201000259.D0A32C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add /sys/class/bdi/<bdi>/min_bytes knob
has been removed from the -mm tree.  Its filename was
     mm-add-sys-class-bdi-bdi-min_bytes-knob.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


