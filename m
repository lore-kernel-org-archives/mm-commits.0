Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78171C04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiI2EHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiI2EHk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FCDE234B
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4733261F8D
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A057C433D7;
        Thu, 29 Sep 2022 04:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424458;
        bh=Y3ev6V3HEWWV2/36eIcOkQqbNfnbrvaekwuS3yj7Ydc=;
        h=Date:To:From:Subject:From;
        b=IogPef19PEtt37wWtuagPAVRRkuMxUuPi45iqqG1dBfchknJ1XAaoqipoha2G3ojp
         I1z6FE051RoWfr/oYo53yIdJsUCgQIG3Gz2kuilwFC8rjvXfaPk0p2T+VX2ilsMCco
         TDEYVryygsDErRb1vUYYUfjhieJcbaiDacD7ynaw=
Date:   Wed, 28 Sep 2022 21:07:37 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly-fix.patch removed from -mm tree
Message-Id: <20220929040738.7A057C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: more simplified code calls damon_target_has_pid()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/sysfs: more simplified code calls damon_target_has_pid()
Date: Fri, 16 Sep 2022 21:35:35 +0800

This patch further simplifies the damon_target_has_pid() call and makes
the damon_sysfs_destroy_targets() look cleaner.

Link: https://lkml.kernel.org/r/20220916133535.7428-1-xhao@linux.alibaba.com
Fixes: 49fb890735ab (mm/damon/sysfs: avoid call damon_target_has_pid() repeatedly)
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly-fix
+++ a/mm/damon/sysfs.c
@@ -2143,10 +2143,7 @@ static int damon_sysfs_set_attrs(struct
 static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
-	bool has_pid = false;
-
-	if (damon_target_has_pid(ctx))
-		has_pid = true;
+	bool has_pid = damon_target_has_pid(ctx);
 
 	damon_for_each_target_safe(t, next, ctx) {
 		if (has_pid)
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch
mm-damon-simplify-scheme-create-in-lru_sortc.patch
mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch
mm-hugetlb-add-available_huge_pages-func.patch
mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch

