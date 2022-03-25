Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4910C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357432AbiCYBgM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357436AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28B327FD5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 649E4B82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D597C340EC;
        Fri, 25 Mar 2022 01:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171998;
        bh=U5PRHb3i39ly1som7qRJDZPFT4v/emgTOJILnE3c6TE=;
        h=Date:To:From:Subject:From;
        b=0HHicV/qkXJ9FdhgOYVpdS5sHexfR2s+rlSx2HXk9KSWTX55RJDlUcYctf8P+ulLX
         VRUrDimajgqWJ53z2WR8pwy0Zhif6GVnm6akr5Q2frUViHOcwzn0M90yFLwo64I5K/
         Bmsbi4z81l57rScQ0XkpWTEciiBe/Rlu5ijfJdz0=
Date:   Thu, 24 Mar 2022 18:33:17 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch removed from -mm tree
Message-Id: <20220325013318.1D597C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: use operations id for knowing if the target has pid
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are


