Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A416C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357439AbiCYBgS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357437AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC81527B26
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C4FEB8272A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F3AC340EE;
        Fri, 25 Mar 2022 01:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171997;
        bh=cjKU7PvH2gsWQfJ8EC32JPZL4zPXd+MKTmD7eE4cRtM=;
        h=Date:To:From:Subject:From;
        b=JVmedjH+QXc2NaZFwZnfnSLKJC2xBuJOfMcXjdi8pYFUW2gGNjUtODeXaeF0/UdZi
         MB9ZYcbFnSQ5WD3NsaRjaXKn+/Ca4dEETjdclEi71TRNC72TRwM+z0lUnKym5cyY46
         51BjNEbJIQPCHEOZl0It8veXXThh/uNzxpp5GKR0=
Date:   Thu, 24 Mar 2022 18:33:16 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch removed from -mm tree
Message-Id: <20220325013317.21F3AC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: use damon_select_ops() instead of damon_{v,p}a_set_operations()
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


