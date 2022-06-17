Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3713ECCA47A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379794AbiFQCt3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379799AbiFQCtY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F1965400
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45162B826F2
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0419C3411A;
        Fri, 17 Jun 2022 02:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434161;
        bh=9sRKGOahueFdebdzbHd9eCc1p1vRtKefHvYoV79/Ovo=;
        h=Date:To:From:Subject:From;
        b=FmObRlD03LJWCc7q07s6qjo9wW5SJXutG7tjhpmADbhgVK2Ipcv8j1uoQR+R+iFw8
         5muFGAYPFg9OEYiGlYze8sNi2cx2WW8lmkipj0HhgqRecNJY2smzThittIyd31BUJG
         74qdmYn346V550d0h3AjO997DgYm2y2Ry56PFqIE=
Date:   Thu, 16 Jun 2022 19:49:20 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        zhouchengming@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-obsolete-comments-of-kdamond_stop.patch removed from -mm tree
Message-Id: <20220617024920.E0419C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: remove obsolete comments of kdamond_stop
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-obsolete-comments-of-kdamond_stop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/damon: remove obsolete comments of kdamond_stop
Date: Tue, 31 May 2022 10:04:21 +0800

Since commit 0f91d13366a4 ("mm/damon: simplify stop mechanism") delete
kdamond_stop and change to use kthread stop mechanism, these obsolete
comments should be removed accordingly.

Link: https://lkml.kernel.org/r/20220531020421.46849-1-zhouchengming@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-obsolete-comments-of-kdamond_stop
+++ a/include/linux/damon.h
@@ -397,7 +397,6 @@ struct damon_callback {
  * detail.
  *
  * @kdamond:		Kernel thread who does the monitoring.
- * @kdamond_stop:	Notifies whether kdamond should stop.
  * @kdamond_lock:	Mutex for the synchronizations with @kdamond.
  *
  * For each monitoring context, one kernel thread for the monitoring is
@@ -406,14 +405,14 @@ struct damon_callback {
  * Once started, the monitoring thread runs until explicitly required to be
  * terminated or every monitoring target is invalid.  The validity of the
  * targets is checked via the &damon_operations.target_valid of @ops.  The
- * termination can also be explicitly requested by writing non-zero to
- * @kdamond_stop.  The thread sets @kdamond to NULL when it terminates.
- * Therefore, users can know whether the monitoring is ongoing or terminated by
- * reading @kdamond.  Reads and writes to @kdamond and @kdamond_stop from
- * outside of the monitoring thread must be protected by @kdamond_lock.
+ * termination can also be explicitly requested by calling damon_stop().
+ * The thread sets @kdamond to NULL when it terminates. Therefore, users can
+ * know whether the monitoring is ongoing or terminated by reading @kdamond.
+ * Reads and writes to @kdamond from outside of the monitoring thread must
+ * be protected by @kdamond_lock.
  *
- * Note that the monitoring thread protects only @kdamond and @kdamond_stop via
- * @kdamond_lock.  Accesses to other fields must be protected by themselves.
+ * Note that the monitoring thread protects only @kdamond via @kdamond_lock.
+ * Accesses to other fields must be protected by themselves.
  *
  * @ops:	Set of monitoring operations for given use cases.
  * @callback:	Set of callbacks for monitoring events notifications.
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are


