Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1326C072A2
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjKOXas (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjKOXaq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:30:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCBC18B
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 15:30:43 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC34FC433C8;
        Wed, 15 Nov 2023 23:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700091043;
        bh=IVgbCkJpORgykvSqtB7iNu3MliOC5AQ55r3WAQpo5Gg=;
        h=Date:To:From:Subject:From;
        b=2UXOEaI2DUikLm6RnsoCSDZvZ3EuTYaLnaWc1XT/5DDRId5jwFk65b/eXff5ZZ1+G
         hjBtWzoLnfWPxG8+E7N3tMgUvygaC/5VNzedyRVDCkju6C1sUVerPXMYjTCw5G76sv
         5ALIZQ7tC6+NM51jgacbyNUETEGLowlFDPUxiR5I=
Date:   Wed, 15 Nov 2023 15:30:42 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        dan.carpenter@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-eliminate-potential-uninitialized-variable-warning.patch removed from -mm tree
Message-Id: <20231115233042.DC34FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: eliminate potential uninitialized variable warning
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-eliminate-potential-uninitialized-variable-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm/damon/sysfs: eliminate potential uninitialized variable warning
Date: Mon, 6 Nov 2023 17:07:40 +0300

The "err" variable is not initialized if damon_target_has_pid(ctx) is
false and sys_target->regions->nr is zero.

Link: https://lkml.kernel.org/r/739e6aaf-a634-4e33-98a8-16546379ec9f@moroto.mountain
Fixes: 0bcd216c4741 ("mm/damon/sysfs: update monitoring target regions for online input commit")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-eliminate-potential-uninitialized-variable-warning
+++ a/mm/damon/sysfs.c
@@ -1172,7 +1172,7 @@ static int damon_sysfs_update_target(str
 		struct damon_ctx *ctx,
 		struct damon_sysfs_target *sys_target)
 {
-	int err;
+	int err = 0;
 
 	if (damon_target_has_pid(ctx)) {
 		err = damon_sysfs_update_target_pid(target, sys_target->pid);
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


