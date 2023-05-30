Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FED0C7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjE3WPB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbjE3WO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D502E5;
        Tue, 30 May 2023 15:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF7E963439;
        Tue, 30 May 2023 22:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C272C433D2;
        Tue, 30 May 2023 22:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685484897;
        bh=hW3VvBodKbV28GrALasLZnEcISjlzRXB8GfKFS5g26A=;
        h=Date:To:From:Subject:From;
        b=K8Mt0QSZdkGk34VS7B1zUFxy7TlDyqQKdCRL+WzBdqu3nyKAj+WxW3GrZ4AvLI6v7
         kXMM1bNyn5IMAMKImkJ0nrHgchfqhUQ8fWy5XxznV7LQPvM8cKsOJDBT041gmVy+Yd
         n8789T/I3bRvAuYUTchJRCO2tPlpQCg967EnNsmo=
Date:   Tue, 30 May 2023 15:14:56 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-divide-error-in-damon_nr_accesses_to_accesses_bp.patch added to mm-hotfixes-unstable branch
Message-Id: <20230530221457.3C272C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: fix divide error in damon_nr_accesses_to_accesses_bp()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-divide-error-in-damon_nr_accesses_to_accesses_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-divide-error-in-damon_nr_accesses_to_accesses_bp.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-damon-core-fix-divide-error-in-damon_nr_accesses_to_accesses_bp.patch
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

