Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16D2C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiLAAI6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiLAAHs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:07:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A25227142
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08ACD61E89
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36435C433D7;
        Thu,  1 Dec 2022 00:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852970;
        bh=/QMBX0pMHS5vnSBugcVJLkEAtmCrFYXGZqxwEM7Wq9E=;
        h=Date:To:From:Subject:From;
        b=np6NFAwhfFT73NsQHZIXiYZ7KxqZ56s6/FAU3IR6kjWWtLX4aI8MqIdnnrZsrwDmH
         OEv9h+4Y4Q4kvWQAVLQK3DStJtQEe7WUHo/AH9AfKHlndj/mTqqRzhloK7oq+549ds
         9LBZLuHEQYb+nODh79uuP+9cMctp5oFoHJuWgjVY=
Date:   Wed, 30 Nov 2022 16:02:48 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-bdi_get_max_bytes-function.patch removed from -mm tree
Message-Id: <20221201000250.36435C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add bdi_get_max_bytes() function
has been removed from the -mm tree.  Its filename was
     mm-add-bdi_get_max_bytes-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: add bdi_get_max_bytes() function
Date: Fri, 18 Nov 2022 16:52:00 -0800

This adds a function to return the specified value for max_bytes. It
converts the stored max_ratio of the bdi to the corresponding bytes
value. It introduces the bdi_get_bytes helper function to do the
conversion. This is an approximation as it is based on the value that is
returned by global_dirty_limits(), which can change. The helper function
will also be used by the min_bytes bdi knob.

Link: https://lkml.kernel.org/r/20221119005215.3052436-6-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/backing-dev.h~mm-add-bdi_get_max_bytes-function
+++ a/include/linux/backing-dev.h
@@ -105,6 +105,7 @@ static inline unsigned long wb_stat_erro
 /* BDI ratio is expressed as part per 1000000 for finer granularity. */
 #define BDI_RATIO_SCALE 10000
 
+u64 bdi_get_max_bytes(struct backing_dev_info *bdi);
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
--- a/mm/page-writeback.c~mm-add-bdi_get_max_bytes-function
+++ a/mm/page-writeback.c
@@ -650,6 +650,18 @@ void wb_domain_exit(struct wb_domain *do
  */
 static unsigned int bdi_min_ratio;
 
+static u64 bdi_get_bytes(unsigned int ratio)
+{
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	u64 bytes;
+
+	global_dirty_limits(&background_thresh, &dirty_thresh);
+	bytes = (dirty_thresh * PAGE_SIZE * ratio) / BDI_RATIO_SCALE / 100;
+
+	return bytes;
+}
+
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	unsigned int delta;
@@ -701,6 +713,11 @@ int bdi_set_max_ratio(struct backing_dev
 }
 EXPORT_SYMBOL(bdi_set_max_ratio);
 
+u64 bdi_get_max_bytes(struct backing_dev_info *bdi)
+{
+	return bdi_get_bytes(bdi->max_ratio);
+}
+
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit)
 {
 	if (strict_limit > 1)
_

Patches currently in -mm which might be from shr@devkernel.io are


