Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5380EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 19:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391686AbiDUTDp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 15:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391716AbiDUTDm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 15:03:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D1B4833D
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 12:00:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DDA261AD1
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 19:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2CCC385A5;
        Thu, 21 Apr 2022 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650567650;
        bh=26PUMu82FzyGNoKzfVyRDHy2xINVYjkApS43L3vmtO0=;
        h=Date:To:From:Subject:From;
        b=lOUTS2ixZsGAg2rGynIoTwRtGzvINNyxJwQgh8opXdBpUm5dOs8QHhsBQEg4m/1WG
         PB+AbyySKr1gcn3kYEoLn6hbxT67TDExpqYqMGzo1Ukr1Q+CjB1hxLj4rsELhsmZP7
         Up1TfvLNMT4h470sxwecg69Xz/NQpIH+C/0Q9ob8=
Date:   Thu, 21 Apr 2022 12:00:50 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, tuhailong@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-fix-the-timer-always-stays-active.patch added to -mm tree
Message-Id: <20220421190050.BC2CCC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: fix the timer always stays active
has been added to the -mm tree.  Its filename is
     mm-damon-reclaim-fix-the-timer-always-stays-active.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-reclaim-fix-the-timer-always-stays-active.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-reclaim-fix-the-timer-always-stays-active.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hailong Tu <tuhailong@gmail.com>
Subject: mm/damon/reclaim: fix the timer always stays active

The timer stays active even if the reclaim mechanism is never enabled.  It
is unnecessary overhead can be completely avoided by using
module_param_cb() for enabled flag.

Link: https://lkml.kernel.org/r/20220421125910.1052459-1-tuhailong@gmail.com
Signed-off-by: Hailong Tu <tuhailong@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-fix-the-timer-always-stays-active
+++ a/mm/damon/reclaim.c
@@ -28,7 +28,6 @@
  * this.
  */
 static bool enabled __read_mostly;
-module_param(enabled, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -358,11 +357,35 @@ static void damon_reclaim_timer_fn(struc
 			enabled = last_enabled;
 	}
 
-	schedule_delayed_work(&damon_reclaim_timer,
+	if (enabled)
+		schedule_delayed_work(&damon_reclaim_timer,
 			msecs_to_jiffies(ENABLE_CHECK_INTERVAL_MS));
 }
 static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
 
+static int enabled_store(const char *val,
+		const struct kernel_param *kp)
+{
+	int rc = param_set_bool(val, kp);
+
+	if (rc < 0)
+		return rc;
+
+	if (enabled)
+		schedule_delayed_work(&damon_reclaim_timer, 0);
+
+	return 0;
+}
+
+static const struct kernel_param_ops enabled_param_ops = {
+	.set = enabled_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+MODULE_PARM_DESC(enabled,
+	"Enable or disable DAMON_RECLAIM (default: disabled)");
+
 static int damon_reclaim_after_aggregation(struct damon_ctx *c)
 {
 	struct damos *s;
_

Patches currently in -mm which might be from tuhailong@gmail.com are

mm-damon-reclaim-fix-the-timer-always-stays-active.patch

