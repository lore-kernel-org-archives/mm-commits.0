Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F34C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiEJEUm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiEJETf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890FB286FEF
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B67961746
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C3AC385A6;
        Tue, 10 May 2022 04:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156069;
        bh=h8VDl0zB03aTUxdCO8byEp0UjT4tEWO6+JMApm40Rzg=;
        h=Date:To:From:Subject:From;
        b=yO5PDzTEXslAEcwSF2mh/WWWFIbcJhE4uyJRG7Rb+B0Yvrch6OYolQF9GSeF2wFnm
         cbz0RctfMh+PgA7jjv4RMxaMiVM8RL83XNQyCKqLouSzLRE6IMSYgMK9EKqZ3hX3gv
         rs+TkqgcFFL/8Hz5TCBRuA0hIPmB06Wo97ENecSE=
Date:   Mon, 09 May 2022 21:14:29 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, tuhailong@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-fix-the-timer-always-stays-active.patch removed from -mm tree
Message-Id: <20220510041429.C1C3AC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: fix the timer always stays active
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-fix-the-timer-always-stays-active.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Hailong Tu <tuhailong@gmail.com>
Subject: mm/damon/reclaim: fix the timer always stays active

The timer stays active even if the reclaim mechanism is never enabled.  It
is unnecessary overhead can be completely avoided by using
module_param_cb() for enabled flag.

Link: https://lkml.kernel.org/r/20220421125910.1052459-1-tuhailong@gmail.com
Signed-off-by: Hailong Tu <tuhailong@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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


