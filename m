Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB6CC38159
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 04:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjATEgM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 23:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjATEfu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 23:35:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D851B4E12
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 20:33:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79DCCB8273C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A76EC433D2;
        Thu, 19 Jan 2023 22:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167663;
        bh=96GpVnDGUdlTjjWzi1RLqGQGYStO/NWXL1BKeeoBFaI=;
        h=Date:To:From:Subject:From;
        b=GjpI5kgfOwvjiMaicgbLFusNLpjSHgExRQ3fHVV6OqDoFcMhWa2IMX/TPfcQnhKJo
         Y+vzbQ3Tsi4CQEwlop9jCYiZk4lYrdGi0c9v/h1kPjlCv0xicVGcEH/EPtA4PBduaj
         yGBROhaz1FPdHFCxMrCObHH2CqIvhpA+a29qKkyQ=
Date:   Thu, 19 Jan 2023 14:34:22 -0800
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-update-comments-in-damonh-for-damon_attrs.patch added to mm-unstable branch
Message-Id: <20230119223423.1A76EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: update comments in damon.h for damon_attrs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-update-comments-in-damonh-for-damon_attrs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-update-comments-in-damonh-for-damon_attrs.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: update comments in damon.h for damon_attrs
Date: Thu, 19 Jan 2023 01:38:29 +0000

Patch series "mm/damon: misc fixes".

This patchset contains three miscellaneous simple fixes for DAMON online
tuning.


This patch (of 3):

Commit cbeaa77b0449 ("mm/damon/core: use a dedicated struct for monitoring
attributes") moved monitoring intervals from damon_ctx to a new struct,
damon_attrs, but a comment in the header file has not updated for the
change.  Update it.

Link: https://lkml.kernel.org/r/20230119013831.1911-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230119013831.1911-2-sj@kernel.org
Fixes: cbeaa77b0449 ("mm/damon/core: use a dedicated struct for monitoring attributes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/damon.h~mm-damon-update-comments-in-damonh-for-damon_attrs
+++ a/include/linux/damon.h
@@ -354,10 +354,10 @@ struct damon_ctx;
  * users should register the low level operations for their target address
  * space and usecase via the &damon_ctx.ops.  Then, the monitoring thread
  * (&damon_ctx.kdamond) calls @init and @prepare_access_checks before starting
- * the monitoring, @update after each &damon_ctx.ops_update_interval, and
+ * the monitoring, @update after each &damon_attrs.ops_update_interval, and
  * @check_accesses, @target_valid and @prepare_access_checks after each
- * &damon_ctx.sample_interval.  Finally, @reset_aggregated is called after each
- * &damon_ctx.aggr_interval.
+ * &damon_attrs.sample_interval.  Finally, @reset_aggregated is called after
+ * each &damon_attrs.aggr_interval.
  *
  * Each &struct damon_operations instance having valid @id can be registered
  * via damon_register_ops() and selected by damon_select_ops() later.
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
mm-damon-update-comments-in-damonh-for-damon_attrs.patch
mm-damon-core-update-monitoring-results-for-new-monitoring-attributes.patch
mm-damon-core-test-add-a-test-for-damon_update_monitoring_results.patch
scripts-spelling-add-a-few-more-typos.patch

