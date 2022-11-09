Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F075FC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiKIBmc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiKIBkb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB63F68699
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 715FD61803
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BBFC433D7;
        Wed,  9 Nov 2022 01:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957986;
        bh=OQ08dSq/pdqXg9HWzPKwdyOp3hkzPt+KrucYASOqcJE=;
        h=Date:To:From:Subject:From;
        b=GUWyLJjJ7vAZRiyitdGFVX2UHAJ6vOY63bjgbp1Q2gK/vBdLQhph/huMkYuRjEDWW
         mRZ/3O3b9PWdkSLzsUneIcK4YC9KvMltEITZVq75BLVxQGzTbH7KNH+qkH3DeSonzp
         zdTNRailGrNwF6XMBPs5ZudnTbNAafwJ3aac83L0=
Date:   Tue, 08 Nov 2022 17:39:46 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch removed from -mm tree
Message-Id: <20221109013946.C9BBFC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: split out kdamond-independent schemes stats update logic into a new function
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: split out kdamond-independent schemes stats update logic into a new function
Date: Wed, 26 Oct 2022 22:59:40 +0000

'damon_sysfs_schemes_update_stats()' is coupled with both
damon_sysfs_kdamond and damon_sysfs_schemes.  It's a wide range of types
dependency.  It makes splitting the logics a little bit distracting. 
Split the function so that each function is coupled with smaller range of
types.

Link: https://lkml.kernel.org/r/20221026225943.100429-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function
+++ a/mm/damon/sysfs.c
@@ -2204,6 +2204,25 @@ static void damon_sysfs_before_terminate
 	mutex_unlock(&ctx->kdamond_lock);
 }
 
+static void damon_sysfs_schemes_update_stats(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int schemes_idx = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		struct damon_sysfs_stats *sysfs_stats;
+
+		sysfs_stats = sysfs_schemes->schemes_arr[schemes_idx++]->stats;
+		sysfs_stats->nr_tried = scheme->stat.nr_tried;
+		sysfs_stats->sz_tried = scheme->stat.sz_tried;
+		sysfs_stats->nr_applied = scheme->stat.nr_applied;
+		sysfs_stats->sz_applied = scheme->stat.sz_applied;
+		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
+	}
+}
+
 /*
  * damon_sysfs_upd_schemes_stats() - Update schemes stats sysfs files.
  * @kdamond:	The kobject wrapper that associated to the kdamond thread.
@@ -2216,23 +2235,11 @@ static void damon_sysfs_before_terminate
 static int damon_sysfs_upd_schemes_stats(struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_ctx *ctx = kdamond->damon_ctx;
-	struct damon_sysfs_schemes *sysfs_schemes;
-	struct damos *scheme;
-	int schemes_idx = 0;
 
 	if (!ctx)
 		return -EINVAL;
-	sysfs_schemes = kdamond->contexts->contexts_arr[0]->schemes;
-	damon_for_each_scheme(scheme, ctx) {
-		struct damon_sysfs_stats *sysfs_stats;
-
-		sysfs_stats = sysfs_schemes->schemes_arr[schemes_idx++]->stats;
-		sysfs_stats->nr_tried = scheme->stat.nr_tried;
-		sysfs_stats->sz_tried = scheme->stat.sz_tried;
-		sysfs_stats->nr_applied = scheme->stat.nr_applied;
-		sysfs_stats->sz_applied = scheme->stat.sz_applied;
-		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
-	}
+	damon_sysfs_schemes_update_stats(
+			kdamond->contexts->contexts_arr[0]->schemes, ctx);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

