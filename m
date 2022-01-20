Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FE2C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377896AbiATV2h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377894AbiATV2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33F7C06161C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 528796188F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DABC340E0;
        Thu, 20 Jan 2022 21:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714115;
        bh=OxkWshm+lup9Lpu/c/+4aoHsrBvkh18tGGFjrXsZ23Y=;
        h=Date:From:To:Subject:From;
        b=XjYK8w0XinA2MIBPVBn0Dl5KT8ye8+Ha11fMruEMPs3eZMnv/kAohpDIUXoPnBkX6
         Klqt/fBqFCAwc02xiDaujhlzpozlWtJds4z7FIjNgahbU21OGFuzTqJgbstHI5Ugp8
         Hn1VHJy+J5owY0SOPhjMaCNgp2hh/pH1xxuWVfW0=
Date:   Thu, 20 Jan 2022 13:28:35 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-?=
 =?US-ASCII?Q?and-watermarks.patch?= removed from -mm tree
Message-ID: <20220120212835.KA4l_yuGn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for scheme quotas and watermarks
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for scheme quotas and watermarks

DAMOS features including time/space quota limits and watermarks are not
described in the DAMON debugfs interface document.  This commit updates
the document for the features.

Link: https://lkml.kernel.org/r/20211209131806.19317-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |  123 +++++++++++++----
 1 file changed, 98 insertions(+), 25 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -131,24 +131,38 @@ Schemes
 
 For usual DAMON-based data access aware memory management optimizations, users
 would simply want the system to apply a memory management action to a memory
-region of a specific size having a specific access frequency for a specific
-time.  DAMON receives such formalized operation schemes from the user and
-applies those to the target processes.  It also counts the total number and
-size of regions that each scheme is applied.  This statistics can be used for
-online analysis or tuning of the schemes.
+region of a specific access pattern.  DAMON receives such formalized operation
+schemes from the user and applies those to the target processes.
 
 Users can get and set the schemes by reading from and writing to ``schemes``
 debugfs file.  Reading the file also shows the statistics of each scheme.  To
-the file, each of the schemes should be represented in each line in below form:
+the file, each of the schemes should be represented in each line in below
+form::
 
-    min-size max-size min-acc max-acc min-age max-age action
+    <target access pattern> <action> <quota> <watermarks>
 
-Note that the ranges are closed interval.  Bytes for the size of regions
-(``min-size`` and ``max-size``), number of monitored accesses per aggregate
-interval for access frequency (``min-acc`` and ``max-acc``), number of
-aggregate intervals for the age of regions (``min-age`` and ``max-age``), and a
-predefined integer for memory management actions should be used.  The supported
-numbers and their meanings are as below.
+You can disable schemes by simply writing an empty string to the file.
+
+Target Access Pattern
+~~~~~~~~~~~~~~~~~~~~~
+
+The ``<target access pattern>`` is constructed with three ranges in below
+form::
+
+    min-size max-size min-acc max-acc min-age max-age
+
+Specifically, bytes for the size of regions (``min-size`` and ``max-size``),
+number of monitored accesses per aggregate interval for access frequency
+(``min-acc`` and ``max-acc``), number of aggregate intervals for the age of
+regions (``min-age`` and ``max-age``) are specified.  Note that the ranges are
+closed interval.
+
+Action
+~~~~~~
+
+The ``<action>`` is a predefined integer for memory management actions, which
+DAMON will apply to the regions having the target access pattern.  The
+supported numbers and their meanings are as below.
 
  - 0: Call ``madvise()`` for the region with ``MADV_WILLNEED``
  - 1: Call ``madvise()`` for the region with ``MADV_COLD``
@@ -157,20 +171,79 @@ numbers and their meanings are as below.
  - 4: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
  - 5: Do nothing but count the statistics
 
-You can disable schemes by simply writing an empty string to the file.  For
-example, below commands applies a scheme saying "If a memory region of size in
-[4KiB, 8KiB] is showing accesses per aggregate interval in [0, 5] for aggregate
-interval in [10, 20], page out the region", check the entered scheme again, and
-finally remove the scheme. ::
+Quota
+~~~~~
 
-    # cd <debugfs>/damon
-    # echo "4096 8192    0 5    10 20    2" > schemes
-    # cat schemes
-    4096 8192 0 5 10 20 2 0 0
-    # echo > schemes
+Optimal ``target access pattern`` for each ``action`` is workload dependent, so
+not easy to find.  Worse yet, setting a scheme of some action too aggressive
+can cause severe overhead.  To avoid such overhead, users can limit time and
+size quota for the scheme via the ``<quota>`` in below form::
+
+    <ms> <sz> <reset interval> <priority weights>
+
+This makes DAMON to try to use only up to ``<ms>`` milliseconds for applying
+the action to memory regions of the ``target access pattern`` within the
+``<reset interval>`` milliseconds, and to apply the action to only up to
+``<sz>`` bytes of memory regions within the ``<reset interval>``.  Setting both
+``<ms>`` and ``<sz>`` zero disables the quota limits.
+
+When the quota limit is expected to be exceeded, DAMON prioritizes found memory
+regions of the ``target access pattern`` based on their size, access frequency,
+and age.  For personalized prioritization, users can set the weights for the
+three properties in ``<priority weights>`` in below form::
+
+    <size weight> <access frequency weight> <age weight>
+
+Watermarks
+~~~~~~~~~~
 
-The last two integers in the 4th line of above example is the total number and
-the total size of the regions that the scheme is applied.
+Some schemes would need to run based on current value of the system's specific
+metrics like free memory ratio.  For such cases, users can specify watermarks
+for the condition.::
+
+    <metric> <check interval> <high mark> <middle mark> <low mark>
+
+``<metric>`` is a predefined integer for the metric to be checked.  The
+supported numbers and their meanings are as below.
+
+ - 0: Ignore the watermarks
+ - 1: System's free memory rate (per thousand)
+
+The value of the metric is checked every ``<check interval>`` microseconds.
+
+If the value is higher than ``<high mark>`` or lower than ``<low mark>``, the
+scheme is deactivated.  If the value is lower than ``<mid mark>``, the scheme
+is activated.
+
+Statistics
+~~~~~~~~~~
+
+It also counts the total number and bytes of regions that each scheme is
+applied.  This statistics can be used for online analysis or tuning of the
+schemes.
+
+The statistics can be shown by reading the ``schemes`` file.  Reading the file
+will show each scheme you entered in each line, and the two numbers for the
+statistics will be added at the end of each line.
+
+Example
+~~~~~~~
+
+Below commands applies a scheme saying "If a memory region of size in [4KiB,
+8KiB] is showing accesses per aggregate interval in [0, 5] for aggregate
+interval in [10, 20], page out the region.  For the paging out, use only up to
+10ms per second, and also don't page out more than 1GiB per second.  Under the
+limitation, page out memory regions having longer age first.  Also, check the
+free memory rate of the system every 5 seconds, start the monitoring and paging
+out when the free memory rate becomes lower than 50%, but stop it if the free
+memory rate becomes larger than 60%, or lower than 30%".::
+
+    # cd <debugfs>/damon
+    # scheme="4096 8192  0 5    10 20    2"  # target access pattern and action
+    # scheme+=" 10 $((1024*1024*1024)) 1000" # quotas
+    # scheme+=" 0 0 100"                     # prioritization weights
+    # scheme+=" 1 5000000 600 500 300"       # watermarks
+    # echo "$scheme" > schemes
 
 
 Turning On/Off
_

Patches currently in -mm which might be from sj@kernel.org are


