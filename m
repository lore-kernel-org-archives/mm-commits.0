Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424DFC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2185D60F26
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhKKCwB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234456AbhKKCwA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 883826103C;
        Thu, 11 Nov 2021 02:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598952;
        bh=DEVOQ7850JNXUI/AWd/sOR3i4LfqhL7l6CI4WsciAoc=;
        h=Date:From:To:Subject:From;
        b=P2Qu+5Cpb2hANXrSFGZjesUgKVG2prwfY1JlS7gCD4tEeaC7NnwsTRo1hgPNhZGgG
         t8Os3Sm1kE5WGw5klHSbi2rGCCjiLINbhQ44Dt2fN6IY+oiVLg0ld8ThaXeoei3SIL
         SyLCU3TKeBfDc/AsVpx5PII0QKMv41uZ7i5TxH7g=
Date:   Wed, 10 Nov 2021 18:49:11 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
 removed from -mm tree
Message-ID: <20211111024911.I_9YCZ3ip%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon: document DAMON-based Operation Schemes
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon: document DAMON-based Operation Schemes

This commit add description of DAMON-based operation schemes in the DAMON
documents.

Link: https://lkml.kernel.org/r/20211001125604.29660-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |   11 +++
 Documentation/admin-guide/mm/damon/usage.rst |   51 ++++++++++++++++-
 2 files changed, 60 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-document-damon-based-operation-schemes
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -108,6 +108,17 @@ the results as separate image files. ::
 You can view the visualizations of this example workload at [1]_.
 Visualizations of other realistic workloads are available at [2]_ [3]_ [4]_.
 
+
+Data Access Pattern Aware Memory Management
+===========================================
+
+Below three commands make every memory region of size >=4K that doesn't
+accessed for >=60 seconds in your workload to be swapped out. ::
+
+    $ echo "#min-size max-size min-acc max-acc min-age max-age action" > scheme
+    $ echo "4K        max      0       0       60s     max     pageout" >> scheme
+    $ damo schemes -c my_thp_scheme <pid of your workload>
+
 .. [1] https://damonitor.github.io/doc/html/v17/admin-guide/mm/damon/start.html#visualizing-recorded-patterns
 .. [2] https://damonitor.github.io/test/result/visual/latest/rec.heatmap.1.png.html
 .. [3] https://damonitor.github.io/test/result/visual/latest/rec.wss_sz.png.html
--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-document-damon-based-operation-schemes
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -34,8 +34,8 @@ the reason, this document describes only
 debugfs Interface
 =================
 
-DAMON exports three files, ``attrs``, ``target_ids``, and ``monitor_on`` under
-its debugfs directory, ``<debugfs>/damon/``.
+DAMON exports four files, ``attrs``, ``target_ids``, ``schemes`` and
+``monitor_on`` under its debugfs directory, ``<debugfs>/damon/``.
 
 
 Attributes
@@ -74,6 +74,53 @@ check it again::
 Note that setting the target ids doesn't start the monitoring.
 
 
+Schemes
+-------
+
+For usual DAMON-based data access aware memory management optimizations, users
+would simply want the system to apply a memory management action to a memory
+region of a specific size having a specific access frequency for a specific
+time.  DAMON receives such formalized operation schemes from the user and
+applies those to the target processes.  It also counts the total number and
+size of regions that each scheme is applied.  This statistics can be used for
+online analysis or tuning of the schemes.
+
+Users can get and set the schemes by reading from and writing to ``schemes``
+debugfs file.  Reading the file also shows the statistics of each scheme.  To
+the file, each of the schemes should be represented in each line in below form:
+
+    min-size max-size min-acc max-acc min-age max-age action
+
+Note that the ranges are closed interval.  Bytes for the size of regions
+(``min-size`` and ``max-size``), number of monitored accesses per aggregate
+interval for access frequency (``min-acc`` and ``max-acc``), number of
+aggregate intervals for the age of regions (``min-age`` and ``max-age``), and a
+predefined integer for memory management actions should be used.  The supported
+numbers and their meanings are as below.
+
+ - 0: Call ``madvise()`` for the region with ``MADV_WILLNEED``
+ - 1: Call ``madvise()`` for the region with ``MADV_COLD``
+ - 2: Call ``madvise()`` for the region with ``MADV_PAGEOUT``
+ - 3: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
+ - 4: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
+ - 5: Do nothing but count the statistics
+
+You can disable schemes by simply writing an empty string to the file.  For
+example, below commands applies a scheme saying "If a memory region of size in
+[4KiB, 8KiB] is showing accesses per aggregate interval in [0, 5] for aggregate
+interval in [10, 20], page out the region", check the entered scheme again, and
+finally remove the scheme. ::
+
+    # cd <debugfs>/damon
+    # echo "4096 8192    0 5    10 20    2" > schemes
+    # cat schemes
+    4096 8192 0 5 10 20 2 0 0
+    # echo > schemes
+
+The last two integers in the 4th line of above example is the total number and
+the total size of the regions that the scheme is applied.
+
+
 Turning On/Off
 --------------
 
_

Patches currently in -mm which might be from sj@kernel.org are


