Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A11C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbiCVVuc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbiCVVua (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC150344DF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5448D6149C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2F3C340EC;
        Tue, 22 Mar 2022 21:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985741;
        bh=DRr0rWYhaEq6qsecV5yL2psCKpJTreoqVr9aKJ7yFXQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Mcboy7eVMW1p1tbUmogolhgHFfkDxNs6flSV4BFJUSBUv1SQSVcrkBnnG6xDunAH2
         hC8mGvtrVGmgWbTG63EGCIECHTjj4R7Aw1jeJuC+6bwA8wtvniCVIy3pyXofvFY97J
         KAHaapVZ9qWsUoEdktNFRWYVMyYjjBYotOz7V+is=
Date:   Tue, 22 Mar 2022 14:49:01 -0700
To:     xhao@linux.alibaba.com, rientjes@google.com, sj@kernel.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 207/227] mm/damon/dbgfs: use operations id for knowing if the target has pid
Message-Id: <20220322214901.AB2F3C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: use operations id for knowing if the target has pid

DAMON debugfs interface depends on monitoring operations for virtual
address spaces because it knows if the target has pid or not by seeing if
the context is configured to use one of the virtual address space
monitoring operation functions.  We can replace that check with 'enum
damon_ops_id' now, to make it independent.  This commit makes the change.

Link: https://lkml.kernel.org/r/20220215184603.1479-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid
+++ a/mm/damon/dbgfs.c
@@ -277,7 +277,7 @@ out:
 
 static inline bool target_has_pid(const struct damon_ctx *ctx)
 {
-	return ctx->ops.target_valid == damon_va_target_valid;
+	return ctx->ops.id == DAMON_OPS_VADDR;
 }
 
 static ssize_t sprint_target_ids(struct damon_ctx *ctx, char *buf, ssize_t len)
@@ -741,8 +741,8 @@ static struct damon_ctx *dbgfs_new_ctx(v
 	if (!ctx)
 		return NULL;
 
-	if (damon_select_ops(ctx, DAMON_OPS_VADDR) && damon_select_ops(ctx,
-				DAMON_OPS_PADDR)) {
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR) &&
+			damon_select_ops(ctx, DAMON_OPS_PADDR)) {
 		damon_destroy_ctx(ctx);
 		return NULL;
 	}
_
