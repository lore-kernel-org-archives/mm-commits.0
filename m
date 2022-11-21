Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC90C4321E
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiKUWSC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiKUWRs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:17:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03759B1E3
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963CA61495
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6E2C433C1;
        Mon, 21 Nov 2022 22:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069065;
        bh=BF9lm8kq8KwkcBsq5grj4JHIISqzEUwtwIEpXgf/CXc=;
        h=Date:To:From:Subject:From;
        b=eR5WFdnsaJZFbHiUEYDdOK80EaBFrlXM6BHBi5EfQXE94EHiLTZ5zBjL+gbUSdjrO
         s6S9f8A0DjbwSH7ymdXNShf3Ke0F/0RNKWN1uJRg2LRnHx/6ysJHt4JwOYiYNvIoOu
         t/5CQ3ovMmGEq3IexGjXvtgC5ujGNHhHBubG80fc=
Date:   Mon, 21 Nov 2022 14:17:44 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-bdi_set_max_bytes-function.patch added to mm-unstable branch
Message-Id: <20221121221744.EC6E2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add bdi_set_max_bytes() function.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-bdi_set_max_bytes-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-bdi_set_max_bytes-function.patch

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
Subject: mm: add bdi_set_max_bytes() function.
Date: Fri, 18 Nov 2022 16:52:02 -0800

This introduces the bdi_set_max_bytes() function. The max_bytes function
does not store the max_bytes value. Instead it converts the max_bytes
value into the corresponding ratio value.

Link: https://lkml.kernel.org/r/20221119005215.3052436-8-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 
 mm/page-writeback.c         |   37 ++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- a/include/linux/backing-dev.h~mm-add-bdi_set_max_bytes-function
+++ a/include/linux/backing-dev.h
@@ -108,6 +108,7 @@ static inline unsigned long wb_stat_erro
 u64 bdi_get_max_bytes(struct backing_dev_info *bdi);
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
+int bdi_set_max_bytes(struct backing_dev_info *bdi, u64 max_bytes);
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
 
 /*
--- a/mm/page-writeback.c~mm-add-bdi_set_max_bytes-function
+++ a/mm/page-writeback.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
@@ -650,6 +651,28 @@ void wb_domain_exit(struct wb_domain *do
  */
 static unsigned int bdi_min_ratio;
 
+static int bdi_check_pages_limit(unsigned long pages)
+{
+	unsigned long max_dirty_pages = global_dirtyable_memory();
+
+	if (pages > max_dirty_pages)
+		return -EINVAL;
+
+	return 0;
+}
+
+static unsigned long bdi_ratio_from_pages(unsigned long pages)
+{
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	unsigned long ratio;
+
+	global_dirty_limits(&background_thresh, &dirty_thresh);
+	ratio = div64_u64(pages * 100ULL * BDI_RATIO_SCALE, dirty_thresh);
+
+	return ratio;
+}
+
 static u64 bdi_get_bytes(unsigned int ratio)
 {
 	unsigned long background_thresh;
@@ -722,6 +745,20 @@ u64 bdi_get_max_bytes(struct backing_dev
 	return bdi_get_bytes(bdi->max_ratio);
 }
 
+int bdi_set_max_bytes(struct backing_dev_info *bdi, u64 max_bytes)
+{
+	int ret;
+	unsigned long pages = max_bytes >> PAGE_SHIFT;
+	unsigned long max_ratio;
+
+	ret = bdi_check_pages_limit(pages);
+	if (ret)
+		return ret;
+
+	max_ratio = bdi_ratio_from_pages(pages);
+	return __bdi_set_max_ratio(bdi, max_ratio);
+}
+
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit)
 {
 	if (strict_limit > 1)
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

