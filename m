Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AA8C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbiBOU6C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:58:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiBOU6B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:58:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAC8E031
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:57:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4399FB81C23
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA80AC340EC;
        Tue, 15 Feb 2022 20:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958667;
        bh=rOdcR2oFxXvEaoSUQn83Lo5e0CxvP20b7b2ABOHJD/w=;
        h=Date:To:From:Subject:From;
        b=F7Y0LP6v4jwRDwngbkUDB+Ldcbt8Ed5VeOM38e58IPODz+vlrub4hpaGgGr0ZFdjJ
         vlcLi5mwD+P3QzGZmr8LzYDzyGbz5cI7RZca7TdbAyHZ0JxoyYVJmhRPdRw4cEI616
         hoeK0G8iKU6nvveS+tMAxfrcxa5FHYhajAIvmfP0=
Date:   Tue, 15 Feb 2022 12:57:47 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch added to -mm tree
Message-Id: <20220215205747.CA80AC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: use damon_select_ops() instead of damon_{v,p}a_set_operations()
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: use damon_select_ops() instead of damon_{v,p}a_set_operations()

This commit makes DAMON debugfs interface to select the registered
monitoring operations for the physical address space or virtual address
spaces depending on user requests instead of setting it on its own.  Note
that DAMON debugfs interface is still dependent to DAMON_VADDR with this
change, because it is also using its symbol, 'damon_va_target_valid'.

Link: https://lkml.kernel.org/r/20220215184603.1479-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations
+++ a/mm/damon/dbgfs.c
@@ -474,12 +474,18 @@ static ssize_t dbgfs_target_ids_write(st
 
 	/* remove previously set targets */
 	dbgfs_set_targets(ctx, 0, NULL);
+	if (!nr_targets) {
+		ret = count;
+		goto unlock_out;
+	}
 
 	/* Configure the context for the address space type */
 	if (id_is_pid)
-		damon_va_set_operations(ctx);
+		ret = damon_select_ops(ctx, DAMON_OPS_VADDR);
 	else
-		damon_pa_set_operations(ctx);
+		ret = damon_select_ops(ctx, DAMON_OPS_PADDR);
+	if (ret)
+		goto unlock_out;
 
 	ret = dbgfs_set_targets(ctx, nr_targets, target_pids);
 	if (!ret)
@@ -735,7 +741,11 @@ static struct damon_ctx *dbgfs_new_ctx(v
 	if (!ctx)
 		return NULL;
 
-	damon_va_set_operations(ctx);
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR) && damon_select_ops(ctx,
+				DAMON_OPS_PADDR)) {
+		damon_destroy_ctx(ctx);
+		return NULL;
+	}
 	ctx->callback.before_terminate = dbgfs_before_terminate;
 	return ctx;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch
mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

