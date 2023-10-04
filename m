Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFD6E7C4F6
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244021AbjJDUSj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243904AbjJDUSf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDE5BF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACC3C433CA;
        Wed,  4 Oct 2023 20:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450711;
        bh=cZ60EI6KHaLgV9zTnRLpz51d5wY5v15PeSWNzo7KgVo=;
        h=Date:To:From:Subject:From;
        b=VhrEYxybPdqRQ3p7EkdFrIzcs8J9LvqZxaY02JQmPmH8Z9YSSHqG/opaKyIShuppc
         J1EhkGTe7CNeqIWcmCTeSV84YeWcl4JrOhza3JJxYtEwl0hbyB24zmJHWYu4EKGffm
         091WBtZEZdLQopBEunupWI368+kTy6oib3DGNwBY=
Date:   Wed, 04 Oct 2023 13:18:30 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch removed from -mm tree
Message-Id: <20231004201831.6ACC3C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: place debugfs usage at the bottom
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: place debugfs usage at the bottom
Date: Thu, 7 Sep 2023 02:29:20 +0000

debugfs interface is deprecated.  Put it at the bottom of the document
so that readers have less chances to read it.

Link: https://lkml.kernel.org/r/20230907022929.91361-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   39 ++++++++---------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -495,6 +495,25 @@ Please note that it's highly recommended
 <https://github.com/awslabs/damo>`_ rather than manually reading and writing
 the files as above.  Above is only for an example.
 
+.. _tracepoint:
+
+Tracepoint for Monitoring Results
+=================================
+
+Users can get the monitoring results via the :ref:`tried_regions
+<sysfs_schemes_tried_regions>` or a tracepoint, ``damon:damon_aggregated``.
+While the tried regions directory is useful for getting a snapshot, the
+tracepoint is useful for getting a full record of the results.  While the
+monitoring is turned on, you could record the tracepoint events and show
+results using tracepoint supporting tools like ``perf``.  For example::
+
+    # echo on > monitor_on
+    # perf record -e damon:damon_aggregated &
+    # sleep 5
+    # kill 9 $(pidof perf)
+    # echo off > monitor_on
+    # perf script
+
 .. _debugfs_interface:
 
 debugfs Interface (DEPRECATED!)
@@ -790,23 +809,3 @@ directory by putting the name of the con
 
 Note that ``mk_contexts``, ``rm_contexts``, and ``monitor_on`` files are in the
 root directory only.
-
-
-.. _tracepoint:
-
-Tracepoint for Monitoring Results
-=================================
-
-Users can get the monitoring results via the :ref:`tried_regions
-<sysfs_schemes_tried_regions>` or a tracepoint, ``damon:damon_aggregated``.
-While the tried regions directory is useful for getting a snapshot, the
-tracepoint is useful for getting a full record of the results.  While the
-monitoring is turned on, you could record the tracepoint events and show
-results using tracepoint supporting tools like ``perf``.  For example::
-
-    # echo on > monitor_on
-    # perf record -e damon:damon_aggregated &
-    # sleep 5
-    # kill 9 $(pidof perf)
-    # echo off > monitor_on
-    # perf script
_

Patches currently in -mm which might be from sj@kernel.org are


