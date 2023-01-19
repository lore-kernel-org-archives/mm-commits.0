Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE54C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjASBQ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjASBPS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A5D53571
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11881B81FB9
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5280C433F0;
        Thu, 19 Jan 2023 01:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090872;
        bh=38MHb7M1tMYqaD6sT86b950UvPfOR2V0Q9vfnFcejxw=;
        h=Date:To:From:Subject:From;
        b=gH3ZCFJUVpEBemDRV3+fFE4T7HW1hPlWyYu9HN8Q1yR04tdFsV0LV3yPMFPMarYIR
         lLlm9iaa3Lzv26t8h7Xgr+GwecFtZfFBSXS82ZG8KGyCOV0ksOZJo6deQAjjuKIzKc
         O/8kJSNJtYO8jv8P2yve67K5LpjkyCv8mVZhtG6w=
Date:   Wed, 18 Jan 2023 17:14:32 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch removed from -mm tree
Message-Id: <20230119011432.A5280C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: add a parameter called skip_anon for avoiding anonymous pages reclamation
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: add a parameter called skip_anon for avoiding anonymous pages reclamation
Date: Mon, 5 Dec 2022 23:08:22 +0000

In some cases, for example if users have confidence at anonymous pages
management or the swap device is too slow, users would want to avoid
DAMON_RECLAIM swapping the anonymous pages out.  For such case, add yet
another DAMON_RECLAIM parameter, namely 'skip_anon'.  When it is set as
'Y', DAMON_RECLAIM will avoid reclaiming anonymous pages using a DAMOS
filter.

Link: https://lkml.kernel.org/r/20221205230830.144349-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation
+++ a/mm/damon/reclaim.c
@@ -99,6 +99,15 @@ static unsigned long monitor_region_end
 module_param(monitor_region_end, ulong, 0600);
 
 /*
+ * Skip anonymous pages reclamation.
+ *
+ * If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+ * pages.  By default, ``N``.
+ */
+static bool skip_anon __read_mostly;
+module_param(skip_anon, bool, 0600);
+
+/*
  * PID of the DAMON thread
  *
  * If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.
@@ -142,6 +151,7 @@ static struct damos *damon_reclaim_new_s
 static int damon_reclaim_apply_parameters(void)
 {
 	struct damos *scheme;
+	struct damos_filter *filter;
 	int err = 0;
 
 	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
@@ -152,6 +162,15 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		return -ENOMEM;
+	if (skip_anon) {
+		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+		if (!filter) {
+			/* Will be freed by next 'damon_set_schemes()' below */
+			damon_destroy_scheme(scheme);
+			return -ENOMEM;
+		}
+		damos_add_filter(scheme, filter);
+	}
 	damon_set_schemes(ctx, &scheme, 1);
 
 	return damon_set_region_biggest_system_ram_default(target,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

