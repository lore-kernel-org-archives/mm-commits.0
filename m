Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB95C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjBCGmw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjBCGlc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641C04485
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02C2F61DB9
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1F3C433D2;
        Fri,  3 Feb 2023 06:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406285;
        bh=RNyHHzCIu4a2XJSV9923EJitX1FROh5xHuzTsv5lpYA=;
        h=Date:To:From:Subject:From;
        b=Y8o/XyeHBtGxTBk1l7j8ReRpWKZM04YGPC8Ta2ToGNMUt2oaaINK2V6XbDjbOqNZ0
         HwHOSo7HNJqFqRbEcu3XUMqmExYK6cv0+E3WskwK7++XzLFfsVdxUiN+KszIjXGv8z
         UrNZIKNJwDzxW4zGPWrehLgWl34hzmtT2ohVEN9A=
Date:   Thu, 02 Feb 2023 22:38:04 -0800
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-update-comments-in-damonh-for-damon_attrs.patch removed from -mm tree
Message-Id: <20230203063805.5B1F3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: update comments in damon.h for damon_attrs
has been removed from the -mm tree.  Its filename was
     mm-damon-update-comments-in-damonh-for-damon_attrs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

scripts-spelling-add-a-few-more-typos.patch

