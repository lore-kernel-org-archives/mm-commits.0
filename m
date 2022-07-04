Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DD4CCA47C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiGDBJj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiGDBJd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A54962E7
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 208E36130E
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73556C341C7;
        Mon,  4 Jul 2022 01:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896971;
        bh=CxRYWWyxiuabgybPVMEjU1OE35a7F/go2x2sL5G/GCs=;
        h=Date:To:From:Subject:From;
        b=VH81aNCkYKKjSd9ejufsyJuwTABgyQLcNsrwW+LnwG1hRDV2433vC/2/uut/6zflp
         bWWs3jLiiwGNVv5EkPhzLRqJSa7fJKTYMdIHGZd1NWzP2n2KC4YALmPfJRf3R2yvv3
         RArR0ScD5S7oTrns/TRhVBWei6iyCGfL5rtD4R3M=
Date:   Sun, 03 Jul 2022 18:09:30 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-deduplicate-commit_inputs-handling.patch removed from -mm tree
Message-Id: <20220704010931.73556C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: deduplicate 'commit_inputs' handling
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-deduplicate-commit_inputs-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: deduplicate 'commit_inputs' handling
Date: Mon, 6 Jun 2022 18:23:07 +0000

DAMON_RECLAIM's handling of 'commit_inputs' parameter is duplicated in
'after_aggregation()' and 'after_wmarks_check()' callbacks.  This commit
deduplicates the code for better maintenance.

Link: https://lkml.kernel.org/r/20220606182310.48781-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-deduplicate-commit_inputs-handling
+++ a/mm/damon/reclaim.c
@@ -403,10 +403,21 @@ module_param_cb(enabled, &enabled_param_
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_RECLAIM (default: disabled)");
 
+static int damon_reclaim_handle_commit_inputs(void)
+{
+	int err;
+
+	if (!commit_inputs)
+		return 0;
+
+	err = damon_reclaim_apply_parameters();
+	commit_inputs = false;
+	return err;
+}
+
 static int damon_reclaim_after_aggregation(struct damon_ctx *c)
 {
 	struct damos *s;
-	int err = 0;
 
 	/* update the stats parameter */
 	damon_for_each_scheme(s, c) {
@@ -417,22 +428,12 @@ static int damon_reclaim_after_aggregati
 		nr_quota_exceeds = s->stat.qt_exceeds;
 	}
 
-	if (commit_inputs) {
-		err = damon_reclaim_apply_parameters();
-		commit_inputs = false;
-	}
-	return err;
+	return damon_reclaim_handle_commit_inputs();
 }
 
 static int damon_reclaim_after_wmarks_check(struct damon_ctx *c)
 {
-	int err = 0;
-
-	if (commit_inputs) {
-		err = damon_reclaim_apply_parameters();
-		commit_inputs = false;
-	}
-	return err;
+	return damon_reclaim_handle_commit_inputs();
 }
 
 static int __init damon_reclaim_init(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

