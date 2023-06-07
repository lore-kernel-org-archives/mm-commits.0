Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E111C7EE2E
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjFGUA6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjFGUAU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A4F2111;
        Wed,  7 Jun 2023 13:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC0F563446;
        Wed,  7 Jun 2023 20:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43160C433D2;
        Wed,  7 Jun 2023 20:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686168016;
        bh=CjfdLFBJMUDtjSx4cXIZ6RFQh0tNQ3i1JELcez5drTI=;
        h=Date:To:From:Subject:From;
        b=A9j0PWZsvydSiX+Rih+MWq/PJesu0cnnEWlpI+3YpVupUykXL0GplgyXT35UDF1Kd
         K5GvGHO8HT06tWR9iNNgErEKxBEyTJ852Veb+gEvf/i5MHOwnYjRjThkA/DA6JnBHR
         bL+KbvEAGpJE4ehv9qFaWT93sSQGO+W6eAnn3EGc=
Date:   Wed, 07 Jun 2023 13:00:15 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-fix-divide-error-in-damon_nr_accesses_to_accesses_bp.patch removed from -mm tree
Message-Id: <20230607200016.43160C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: fix divide error in damon_nr_accesses_to_accesses_bp()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-divide-error-in-damon_nr_accesses_to_accesses_bp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/core: fix divide error in damon_nr_accesses_to_accesses_bp()
Date: Sat, 27 May 2023 11:21:01 +0800

If 'aggr_interval' is smaller than 'sample_interval', max_nr_accesses in
damon_nr_accesses_to_accesses_bp() becomes zero which leads to divide
error, let's validate the values of them in damon_set_attrs() to fix it,
which similar to others attrs check.

Link: https://lkml.kernel.org/r/20230527032101.167788-1-wangkefeng.wang@huawei.com
Fixes: 2f5bef5a590b ("mm/damon/core: update monitoring results for new monitoring attributes")
Reported-by: syzbot+841a46899768ec7bec67@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=841a46899768ec7bec67
Link: https://lore.kernel.org/damon/00000000000055fc4e05fc975bc2@google.com/
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-fix-divide-error-in-damon_nr_accesses_to_accesses_bp
+++ a/mm/damon/core.c
@@ -551,6 +551,8 @@ int damon_set_attrs(struct damon_ctx *ct
 		return -EINVAL;
 	if (attrs->min_nr_regions > attrs->max_nr_regions)
 		return -EINVAL;
+	if (attrs->sample_interval > attrs->aggr_interval)
+		return -EINVAL;
 
 	damon_update_monitoring_results(ctx, attrs);
 	ctx->attrs = *attrs;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch
mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch
mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch
mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch
mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch
mm-page_alloc-collect-mem-statistic-into-show_memc.patch
mm-page_alloc-squash-page_is_consistent.patch
mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch
mm-page_alloc-split-out-fail_page_alloc.patch
mm-page_alloc-split-out-debug_pagealloc.patch
mm-page_alloc-move-mark_free_page-into-snapshotc.patch
mm-page_alloc-move-pm_-function-into-power.patch
mm-vmscan-use-gfp_has_io_fs.patch
mm-page_alloc-move-sysctls-into-it-own-fils.patch
mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

