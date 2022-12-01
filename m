Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5473EC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiLAAJY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiLAAHy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:07:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899E32792D
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21A7661E5B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2FEC433D7;
        Thu,  1 Dec 2022 00:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852971;
        bh=6qOLYaPg7Y5Sm7c0F7t7XtNyx8yopGqzpw+d6lZBjgs=;
        h=Date:To:From:Subject:From;
        b=XMUFax9hSigKdLzQw2UASChLV+6EAkYVSaxc5c/c4oQeLGa2/4Jc7fZO/X6D++kvi
         IO8sf/uqUPUmQJ4L8xEmA4AERp5qROjeShvNj4tVEzuTfOuhMx6G7B+c5KtZddD2mj
         pBnUpE9DbiSKTjGjps/YbGJv16i4Fq/GBWKpsyl4=
Date:   Wed, 30 Nov 2022 16:02:50 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-off-__bdi_set_max_ratio-function.patch removed from -mm tree
Message-Id: <20221201000251.4D2FEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: split off __bdi_set_max_ratio() function
has been removed from the -mm tree.  Its filename was
     mm-split-off-__bdi_set_max_ratio-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: split off __bdi_set_max_ratio() function
Date: Fri, 18 Nov 2022 16:52:01 -0800

This splits off __bdi_set_max_ratio() from bdi_set_max_ratio().
__bdi_set_max_ratio() will also be called from bdi_set_max_bytes(),
which will be introduced in the next patch.

Link: https://lkml.kernel.org/r/20221119005215.3052436-7-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/page-writeback.c~mm-split-off-__bdi_set_max_ratio-function
+++ a/mm/page-writeback.c
@@ -692,14 +692,10 @@ int bdi_set_min_ratio(struct backing_dev
 	return ret;
 }
 
-int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
+static int __bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio)
 {
 	int ret = 0;
 
-	if (max_ratio > 100)
-		return -EINVAL;
-	max_ratio *= BDI_RATIO_SCALE;
-
 	spin_lock_bh(&bdi_lock);
 	if (bdi->min_ratio > max_ratio) {
 		ret = -EINVAL;
@@ -711,6 +707,14 @@ int bdi_set_max_ratio(struct backing_dev
 
 	return ret;
 }
+
+int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio)
+{
+	if (max_ratio > 100)
+		return -EINVAL;
+
+	return __bdi_set_max_ratio(bdi, max_ratio * BDI_RATIO_SCALE);
+}
 EXPORT_SYMBOL(bdi_set_max_ratio);
 
 u64 bdi_get_max_bytes(struct backing_dev_info *bdi)
_

Patches currently in -mm which might be from shr@devkernel.io are


