Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74DFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB761610C8
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhJVTcg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232504AbhJVTcg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 15:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E1A8610A4;
        Fri, 22 Oct 2021 19:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634931018;
        bh=z7H8qAxfC6Hp9XZDsU6DhsVAqmzZyl0o3P+/LTCvJ1k=;
        h=Date:From:To:Subject:From;
        b=tYzG2ZDc0rUznD575qFMF1yTUGEd3U8BP8mFbf2kQv2GHaUoh2oPXnIUGJZYzbAYg
         DvXT6mS1sCfACJCe1cLuoqmS2tKBSDG3ClPt2QahmSxfHrSsbO89w5cf1cNMQ59DT9
         tyx8vIIVKanPm65Wzjugu9A5DxsL1dEmRg2ZJ13M=
Date:   Fri, 22 Oct 2021 12:30:17 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, peterx@redhat.com,
        sj@kernel.org
Subject:  +
 docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch added to
 -mm tree
Message-ID: <20211022193017.Ecxpsv5Dn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: fix wrong example commands
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch
docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch
docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch
docs-admin-guide-mm-damon-start-simplify-the-content.patch
docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch

