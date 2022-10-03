Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828E1C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJCVKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiJCVIw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F45E4F69F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B590B8160E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022B0C433C1;
        Mon,  3 Oct 2022 21:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831193;
        bh=YBA1JQAbiqecE7KkefIn4tICxUPtJbXWC+q8qQuvU7c=;
        h=Date:To:From:Subject:From;
        b=f9gX6CHS6aFUYIH0HZ1C6Ag9bPDm5RCyVIvvWsjfTNN5cqWnZhQR6NiQJDU4DkVca
         s9MK72NeK/LxyPdTxdjeSbGj26ExU6yehlQpTRz+HleQHwzzKtvy+kXoJaDh8GoDuL
         zb8w/+Xtwov7NNNNd2OONfsnVmkrQFs+rjdf13O4=
Date:   Mon, 03 Oct 2022 14:06:32 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch removed from -mm tree
Message-Id: <20221003210633.022B0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: simplify damon_ctx check in damon_sysfs_before_terminate
has been removed from the -mm tree.  Its filename was
     mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: simplify damon_ctx check in damon_sysfs_before_terminate
Date: Wed, 7 Sep 2022 16:41:16 +0800

In damon_sysfs_before_terminate(), it needs to check whether ctx->ops.id
supports 'DAMON_OPS_VADDR' or 'DAMON_OPS_FVADDR', there we can use
damon_target_has_pid() instead.

Link: https://lkml.kernel.org/r/20220907084116.62053-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate
+++ a/mm/damon/sysfs.c
@@ -2309,7 +2309,7 @@ static void damon_sysfs_before_terminate
 {
 	struct damon_target *t, *next;
 
-	if (ctx->ops.id != DAMON_OPS_VADDR && ctx->ops.id != DAMON_OPS_FVADDR)
+	if (!damon_target_has_pid(ctx))
 		return;
 
 	mutex_lock(&ctx->kdamond_lock);
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch

