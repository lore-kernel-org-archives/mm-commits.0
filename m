Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F515C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiKUWSf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiKUWSE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:18:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848EA10B4F
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:18:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 232E4614BB
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E378C433C1;
        Mon, 21 Nov 2022 22:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069081;
        bh=6lfABmAtBLrtq2DYnFpG2YmsL3S+E2J8B6ZGnSViaso=;
        h=Date:To:From:Subject:From;
        b=ryc/Q3TqHAm+Md1E+8IfHFd/i6RuJn4rPYfbTe4mjQQO2Tk5KyRw/um6FsJf+XmFr
         DtzUTg/+zDKgr7R8nPnw2OSGm89+2Iga50kVdYGTsE7fEXwW53VySRmraRj4HdbkcM
         FK2p683J+Jl05c3HVJp872lIhatj0OBGBgfUl7d4=
Date:   Mon, 21 Nov 2022 14:18:00 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-bdi_set_max_ratio_no_scale-function.patch added to mm-unstable branch
Message-Id: <20221121221801.7E378C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add bdi_set_max_ratio_no_scale() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-bdi_set_max_ratio_no_scale-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-bdi_set_max_ratio_no_scale-function.patch

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
Subject: mm: add bdi_set_max_ratio_no_scale() function
Date: Fri, 18 Nov 2022 16:52:10 -0800

This introduces bdi_set_max_ratio_no_scale(). It uses the max
granularity for the ratio. This function by the new sysfs knob
max_ratio_fine.

Link: https://lkml.kernel.org/r/20221119005215.3052436-16-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/backing-dev.h~mm-add-bdi_set_max_ratio_no_scale-function
+++ a/include/linux/backing-dev.h
@@ -109,6 +109,7 @@ u64 bdi_get_min_bytes(struct backing_dev
 u64 bdi_get_max_bytes(struct backing_dev_info *bdi);
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
+int bdi_set_max_ratio_no_scale(struct backing_dev_info *bdi, unsigned int max_ratio);
 int bdi_set_min_bytes(struct backing_dev_info *bdi, u64 min_bytes);
 int bdi_set_max_bytes(struct backing_dev_info *bdi, u64 max_bytes);
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
--- a/mm/page-writeback.c~mm-add-bdi_set_max_ratio_no_scale-function
+++ a/mm/page-writeback.c
@@ -719,6 +719,9 @@ static int __bdi_set_max_ratio(struct ba
 {
 	int ret = 0;
 
+	if (max_ratio > 100 * BDI_RATIO_SCALE)
+		return -EINVAL;
+
 	spin_lock_bh(&bdi_lock);
 	if (bdi->min_ratio > max_ratio) {
 		ret = -EINVAL;
@@ -731,6 +734,11 @@ static int __bdi_set_max_ratio(struct ba
 	return ret;
 }
 
+int bdi_set_max_ratio_no_scale(struct backing_dev_info *bdi, unsigned int max_ratio)
+{
+	return __bdi_set_max_ratio(bdi, max_ratio);
+}
+
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	return __bdi_set_min_ratio(bdi, min_ratio * BDI_RATIO_SCALE);
@@ -738,9 +746,6 @@ int bdi_set_min_ratio(struct backing_dev
 
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio)
 {
-	if (max_ratio > 100)
-		return -EINVAL;
-
 	return __bdi_set_max_ratio(bdi, max_ratio * BDI_RATIO_SCALE);
 }
 EXPORT_SYMBOL(bdi_set_max_ratio);
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

