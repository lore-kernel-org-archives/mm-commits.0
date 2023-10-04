Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03C3E936EF
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244879AbjJDUXW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243987AbjJDUXC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03470192
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1FFC433C9;
        Wed,  4 Oct 2023 20:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450978;
        bh=LJR9ZaiSSg7fPD/wLAdIuFSuU0GI+s+XRv36dtpq3t4=;
        h=Date:To:From:Subject:From;
        b=XFckH+T7fClkHNqdjh2T64sUZzqdeyXMok55x8a/47thQ+RqGpOLUhKgHvygG04I2
         Db16rBhMniRERsDw/kayICES7qV/Jeys9iO8FcLO6fdLQpufG6BkvjnZqRIrOpwBH5
         Oho0YegoJKA1Wujxxddvf1FgUfeR3h6fU5zTzxLM=
Date:   Wed, 04 Oct 2023 13:22:56 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-damos-apply-intervals.patch removed from -mm tree
Message-Id: <20231004202258.5C1FFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for DAMOS apply intervals
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-damos-apply-intervals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for DAMOS apply intervals
Date: Sat, 16 Sep 2023 02:09:44 +0000

Update DAMON usage document's DAMON sysfs interface section for the newly
added DAMOS apply intervals support (apply_interval_us file).

Link: https://lkml.kernel.org/r/20230916020945.47296-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-damos-apply-intervals
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -76,7 +76,7 @@ comma (","). ::
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ │ schemes/nr_schemes
-    │ │ │ │ │ │ 0/action
+    │ │ │ │ │ │ 0/action,apply_interval_us
     │ │ │ │ │ │ │ access_pattern/
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
@@ -269,8 +269,8 @@ schemes/<N>/
 ------------
 
 In each scheme directory, five directories (``access_pattern``, ``quotas``,
-``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and one file
-(``action``) exist.
+``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and two files
+(``action`` and ``apply_interval``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
@@ -296,6 +296,9 @@ Note that support of each action depends
  - ``stat``: Do nothing but count the statistics.
    Supported by all operations sets.
 
+The ``apply_interval_us`` file is for setting and getting the scheme's
+:ref:`apply_interval <damon_design_damos>` in microseconds.
+
 schemes/<N>/access_pattern/
 ---------------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are


