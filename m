Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DA4E7C4F6
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244013AbjJDUSd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244000AbjJDUSc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0CDC0
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96332C433C8;
        Wed,  4 Oct 2023 20:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450707;
        bh=UVINrkza3VrhQRK7EawJ2keGEQeLRa4IZnlREdU+mEk=;
        h=Date:To:From:Subject:From;
        b=MVASbsVungBq0z0CgZf2s4ptYLoYLQD0d73zIZ/L+2Ls0NkE4yY6LKSOuZvDUmqcH
         i9AYgedvoc3L+qflrlfxgOIfK4cxeoN8BH2omZ7H7rPe9BlXOpKH2IJwD1ECKFbfuC
         QpSIHoKmkf+njJd5YSl0dXJS0vetMyRVK4kfxHbQ=
Date:   Wed, 04 Oct 2023 13:18:26 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch removed from -mm tree
Message-Id: <20231004201827.96332C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: fix a comment about damon_set_attrs() call timings
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix a comment about damon_set_attrs() call timings
Date: Thu, 7 Sep 2023 02:29:26 +0000

The comment on damon_set_attrs() says it should not be called while the
kdamond is running, but now some DAMON modules like sysfs interface and
DAMON_RECLAIM call it from after_aggregation() and/or
after_wmarks_check() callbacks for online tuning.  Update the comment.

Link: https://lkml.kernel.org/r/20230907022929.91361-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings
+++ a/mm/damon/core.c
@@ -541,7 +541,11 @@ static void damon_update_monitoring_resu
  * @ctx:		monitoring context
  * @attrs:		monitoring attributes
  *
- * This function should not be called while the kdamond is running.
+ * This function should be called while the kdamond is not running, or an
+ * access check results aggregation is not ongoing (e.g., from
+ * &struct damon_callback->after_aggregation or
+ * &struct damon_callback->after_wmarks_check callbacks).
+ *
  * Every time interval is in micro-seconds.
  *
  * Return: 0 on success, negative error code otherwise.
_

Patches currently in -mm which might be from sj@kernel.org are


