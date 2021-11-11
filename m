Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D36C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CA3761241
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhKKCx3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234528AbhKKCxQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DDF560F26;
        Thu, 11 Nov 2021 02:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599028;
        bh=WB2wSXY8YCMkCv+IZ3wJpMWgiIWUxKMGBPpm/xB/qYU=;
        h=Date:From:To:Subject:From;
        b=BL7Stoeid/7kVARLP9MoNmz5lYFOv2mDV3gn/T1yZ1IE0pphqQ9ITZKGrNsVUOsXP
         1CXwwC0783cdhDNm3hFwceZEosVka4RWLqjIjruFmIVDv+o1FOBp5ApNQSbrEv6AVj
         SW8CjSeM1tIXqD8E2kJwBPzkD00RH9V6wshLFYao=
Date:   Wed, 10 Nov 2021 18:50:28 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, peterx@redhat.com,
        sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch removed
 from -mm tree
Message-ID: <20211111025028.pIgf-NbbU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: fix wrong example commands
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/start: fix wrong example commands

Patch series "Fix trivial nits in Documentation/admin-guide/mm".

This patchset fixes trivial nits in admin guide documents for DAMON and
pagemap.


This patch (of 4):

Some of the example commands in DAMON getting started guide are
outdated, missing sudo, or just wrong.  This commit fixes those.

Link: https://lkml.kernel.org/r/20211022090311.3856-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-fix-wrong-example-commands
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -19,7 +19,7 @@ your workload. ::
     # mount -t debugfs none /sys/kernel/debug/
     # git clone https://github.com/awslabs/damo
     # ./damo/damo record $(pidof <your workload>)
-    # ./damo/damo report heat --plot_ascii
+    # ./damo/damo report heats --heatmap stdout
 
 The final command draws the access heatmap of ``<your workload>``.  The heatmap
 shows which memory region (x-axis) is accessed when (y-axis) and how frequently
@@ -94,9 +94,9 @@ Visualizing Recorded Patterns
 The following three commands visualize the recorded access patterns and save
 the results as separate image files. ::
 
-    $ damo report heats --heatmap access_pattern_heatmap.png
-    $ damo report wss --range 0 101 1 --plot wss_dist.png
-    $ damo report wss --range 0 101 1 --sortby time --plot wss_chron_change.png
+    $ sudo damo report heats --heatmap access_pattern_heatmap.png
+    $ sudo damo report wss --range 0 101 1 --plot wss_dist.png
+    $ sudo damo report wss --range 0 101 1 --sortby time --plot wss_chron_change.png
 
 - ``access_pattern_heatmap.png`` will visualize the data access pattern in a
   heatmap, showing which memory region (y-axis) got accessed when (x-axis)
@@ -115,9 +115,9 @@ Data Access Pattern Aware Memory Managem
 Below three commands make every memory region of size >=4K that doesn't
 accessed for >=60 seconds in your workload to be swapped out. ::
 
-    $ echo "#min-size max-size min-acc max-acc min-age max-age action" > scheme
-    $ echo "4K        max      0       0       60s     max     pageout" >> scheme
-    $ damo schemes -c my_thp_scheme <pid of your workload>
+    $ echo "#min-size max-size min-acc max-acc min-age max-age action" > test_scheme
+    $ echo "4K        max      0       0       60s     max     pageout" >> test_scheme
+    $ damo schemes -c test_scheme <pid of your workload>
 
 .. [1] https://damonitor.github.io/doc/html/v17/admin-guide/mm/damon/start.html#visualizing-recorded-patterns
 .. [2] https://damonitor.github.io/test/result/visual/latest/rec.heatmap.1.png.html
_

Patches currently in -mm which might be from sj@kernel.org are


