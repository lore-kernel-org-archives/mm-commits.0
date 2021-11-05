Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6384C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E486126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhKEUuv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhKEUuu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3B136120A;
        Fri,  5 Nov 2021 20:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145290;
        bh=qu2rlHwySO0EP1Ru+ktgVkit7Y4aha8BJc6JMSG9pH8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C1cOudhPy+P2wf4Mppkwu3UDePA9tf4tHRHeOi4/b7iIEMt1gVosshttioxZ+vaQO
         UBNS0HEWyOEWGVj7lzCD4gXeC7jFLMX6DrnzADeoYI55TDgd0+90DdOVCnAJ9FDk+X
         34EnUkJwMvjTLfhLr8t32s8U/oZR99e7VAxB4hIU=
Date:   Fri, 05 Nov 2021 13:48:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 256/262] Docs/admin-guide/mm/damon/start: fix
 wrong example commands
Message-ID: <20211105204810.2vA7rsIAo%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
