Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7857CC43334
	for <mm-commits@archiver.kernel.org>; Thu,  2 Jun 2022 19:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbiFBTuN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Jun 2022 15:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbiFBTt6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2022 15:49:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C4A38BA
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 12:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3146A617DC
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 19:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807AFC385A5;
        Thu,  2 Jun 2022 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654199373;
        bh=FncJN3DbuZVoTajoXnP3aLRzoI2bttKEMRav/WdW1+E=;
        h=Date:To:From:Subject:From;
        b=ksIGYXemyZ0hu32tI+HwCmeaJCmSiRXkG8q2n9QEp/wEPM5Wbv9CZLzSft2wZ6ZZx
         9v5Or8Gr6A/8+ofRabkxxJ5BrYLnA+OzRrisbqDa+bxJNjIoDJRaKxxx6eBFmsGrzj
         7R8zdfsV30/FJ0dO8U3wUeUKHX7CBYIzI69GmowQ=
Date:   Thu, 02 Jun 2022 12:49:32 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        zhouchengming@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-obsolete-comments-of-kdamond_stop.patch added to mm-unstable branch
Message-Id: <20220602194933.807AFC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove obsolete comments of kdamond_stop
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-remove-obsolete-comments-of-kdamond_stop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-obsolete-comments-of-kdamond_stop.patch

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

mm-damon-remove-obsolete-comments-of-kdamond_stop.patch

