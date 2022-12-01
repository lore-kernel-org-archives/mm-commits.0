Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A6EC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLAAKn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiLAAIm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:08:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C3683251
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 780B061E6E
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46DFC433D7;
        Thu,  1 Dec 2022 00:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852978;
        bh=RWmFp2vTvw3y7WZjcrn0jHQCFd2UxoMDmFufhJqYVPE=;
        h=Date:To:From:Subject:From;
        b=Zn3dLpQB9Dkmt3EvChFvUQde2z3Wl63RNhbD8N8RMaFedHN91c5TR9Ekh0ij5+eK0
         bZlEchtm9SmDcJX1MrMZ4VYb0/HM5p1tL9lwHHm8DkkSl3hr5etxB/NZMpHT7KXIN7
         JQdiD6sqYP7pUACFLP4VBlpqmMXeW8jcFj2DdPz4=
Date:   Wed, 30 Nov 2022 16:02:58 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-bdi_set_min_bytes-function.patch removed from -mm tree
Message-Id: <20221201000258.A46DFC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add bdi_set_min_bytes() function
has been removed from the -mm tree.  Its filename was
     mm-add-bdi_set_min_bytes-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: add bdi_set_min_bytes() function
Date: Fri, 18 Nov 2022 16:52:07 -0800

This introduces the bdi_set_min_bytes() function. The min_bytes function
does not store the min_bytes value. Instead it converts the min_bytes
value into the corresponding ratio value.

Link: https://lkml.kernel.org/r/20221119005215.3052436-13-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

--- a/include/linux/backing-dev.h~mm-add-bdi_set_min_bytes-function
+++ a/include/linux/backing-dev.h
@@ -109,6 +109,7 @@ u64 bdi_get_min_bytes(struct backing_dev
 u64 bdi_get_max_bytes(struct backing_dev_info *bdi);
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
+int bdi_set_min_bytes(struct backing_dev_info *bdi, u64 min_bytes);
 int bdi_set_max_bytes(struct backing_dev_info *bdi, u64 max_bytes);
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
 
--- a/mm/page-writeback.c~mm-add-bdi_set_min_bytes-function
+++ a/mm/page-writeback.c
@@ -750,6 +750,20 @@ u64 bdi_get_min_bytes(struct backing_dev
 	return bdi_get_bytes(bdi->min_ratio);
 }
 
+int bdi_set_min_bytes(struct backing_dev_info *bdi, u64 min_bytes)
+{
+	int ret;
+	unsigned long pages = min_bytes >> PAGE_SHIFT;
+	unsigned long min_ratio;
+
+	ret = bdi_check_pages_limit(pages);
+	if (ret)
+		return ret;
+
+	min_ratio = bdi_ratio_from_pages(pages);
+	return __bdi_set_min_ratio(bdi, min_ratio);
+}
+
 u64 bdi_get_max_bytes(struct backing_dev_info *bdi)
 {
 	return bdi_get_bytes(bdi->max_ratio);
_

Patches currently in -mm which might be from shr@devkernel.io are


