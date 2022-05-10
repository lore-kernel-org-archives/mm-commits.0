Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4853AC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiEJEWN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56A02AEDB3
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A1F76176C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF0DC385CD;
        Tue, 10 May 2022 04:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156134;
        bh=kN/oXQnD7pSFnPy6qkeEl6s2X44snt7obkaHCgiybUQ=;
        h=Date:To:From:Subject:From;
        b=Kx23NTWggFngmsr5+ae8DL0OKTtPH5QR3DMZdvNVgygxcPloC9ackZzZPQUuoiZnb
         2ftjNF2GOmtvmbt4dJ8QP6zXb6ogkqp8r3ngVO8Jy0sfv0cFOmiDY+Ru0h4uckfj47
         512D6e9Y9R+Mk212Xv70/EgeZgEjqVv5RNkKqJPw=
Date:   Mon, 09 May 2022 21:15:34 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch removed from -mm tree
Message-Id: <20220510041534.BAF0DC385CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: support fixed virtual address ranges monitoring
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: support fixed virtual address ranges monitoring

This commit makes DAMON sysfs interface to support the fixed virtual
address ranges monitoring.  After this commit, writing 'fvaddr' to the
'operations' DAMON sysfs file makes DAMON uses the monitoring operations
set for fixed virtual address ranges, so that users can monitor accesses
to only interested virtual address ranges.

[sj@kernel.org: fix pid leak under fvaddr ops use case]
  Link: https://lkml.kernel.org/r/20220503220531.45913-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220426231750.48822-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring
+++ a/mm/damon/sysfs.c
@@ -1694,7 +1694,7 @@ static struct kobj_type damon_sysfs_attr
 /* This should match with enum damon_ops_id */
 static const char * const damon_sysfs_ops_strs[] = {
 	"vaddr",
-	"unsupported",	/* fvaddr is not supported by sysfs yet */
+	"fvaddr",
 	"paddr",
 };
 
@@ -1844,9 +1844,6 @@ static ssize_t operations_store(struct k
 
 	for (id = 0; id < NR_DAMON_OPS; id++) {
 		if (sysfs_streq(buf, damon_sysfs_ops_strs[id])) {
-			/* fvaddr is not supported by sysfs yet */
-			if (id == DAMON_OPS_FVADDR)
-				return -EINVAL;
 			context->ops_id = id;
 			return count;
 		}
@@ -2089,7 +2086,8 @@ static void damon_sysfs_destroy_targets(
 	struct damon_target *t, *next;
 
 	damon_for_each_target_safe(t, next, ctx) {
-		if (ctx->ops.id == DAMON_OPS_VADDR)
+		if (ctx->ops.id == DAMON_OPS_VADDR ||
+				ctx->ops.id == DAMON_OPS_FVADDR)
 			put_pid(t->pid);
 		damon_destroy_target(t);
 	}
@@ -2136,7 +2134,8 @@ static int damon_sysfs_set_targets(struc
 			damon_sysfs_destroy_targets(ctx);
 			return -ENOMEM;
 		}
-		if (ctx->ops.id == DAMON_OPS_VADDR) {
+		if (ctx->ops.id == DAMON_OPS_VADDR ||
+				ctx->ops.id == DAMON_OPS_FVADDR) {
 			t->pid = find_get_pid(sys_target->pid);
 			if (!t->pid) {
 				damon_sysfs_destroy_targets(ctx);
@@ -2206,7 +2205,7 @@ static void damon_sysfs_before_terminate
 {
 	struct damon_target *t, *next;
 
-	if (ctx->ops.id != DAMON_OPS_VADDR)
+	if (ctx->ops.id != DAMON_OPS_VADDR && ctx->ops.id != DAMON_OPS_FVADDR)
 		return;
 
 	mutex_lock(&ctx->kdamond_lock);
_

Patches currently in -mm which might be from sj@kernel.org are


