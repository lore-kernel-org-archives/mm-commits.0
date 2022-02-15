Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAE5C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbiBOU6H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:58:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiBOU6D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:58:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5CEE031
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D935B81CFB
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8B1C340EB;
        Tue, 15 Feb 2022 20:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958669;
        bh=G2EPi4YOnxI0rkf9ktTWWlO9Y0B5wxm6f3PKVBG7qEw=;
        h=Date:To:From:Subject:From;
        b=zEMj08TosC1UA7/VUDZuDhrAMsETVl+jJPVOuarbW+NahBw5+C+0FgM4M+D3Cp+Ct
         2neZ1TzN1WXaUzwqF79p2zYpN7kXjTkIVuPK6p5SuK8CyDfl23fEYLPh0GaNGNQQ91
         g762pBeO02lpelVC/E2q0sUwDulJS2GUMLW55a1s=
Date:   Tue, 15 Feb 2022 12:57:49 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch added to -mm tree
Message-Id: <20220215205749.CB8B1C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: use operations id for knowing if the target has pid
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch

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

