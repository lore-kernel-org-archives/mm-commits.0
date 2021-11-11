Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C117C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492706135E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhKKCx3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234569AbhKKCxV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6AA260F26;
        Thu, 11 Nov 2021 02:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599032;
        bh=SscuNVfiHkOVXitiKK1nN3fT2w/l2DXFhGtSxlvdKyY=;
        h=Date:From:To:Subject:From;
        b=gcRIrlo8FjkQPj0Gl61CDpn6+zUdzjN9cr+GAGLs/z6Yj3ify6b/QeG14a4foDzx8
         oTEgYZ2N2oPGnVCg1N7IKYurf4Sg+i1bJ8B7zLM9xenGsxIJto5C8ap1qTeNy6ptOA
         /OTG//+1qVILadzoS87PydWevid4fV6XXL41+LBs=
Date:   Wed, 10 Nov 2021 18:50:32 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, peterx@redhat.com,
        sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-start-simplify-the-content.patch removed from -mm
 tree
Message-ID: <20211111025032.pYErtpZMC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: simplify the content
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-start-simplify-the-content.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/start: simplify the content

Information in 'TL; DR' section of 'Getting Started' is duplicated in
other parts of the doc.  It is also asking readers to visit the access
pattern visualizations gallery web site to show the results of example
visualization commands, while the users of the commands can use terminal
output.

To make the doc simple, this commit removes the duplicated 'TL; DR'
section and replaces the visualization example commands with versions
using terminal outputs.

Link: https://lkml.kernel.org/r/20211022090311.3856-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |  111 +++++++++--------
 1 file changed, 59 insertions(+), 52 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-simplify-the-content
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -11,38 +11,6 @@ of its features for brevity.  Please ref
 details.
 
 
-TL; DR
-======
-
-Follow the commands below to monitor and visualize the memory access pattern of
-your workload. ::
-
-    # # build the kernel with CONFIG_DAMON_*=y, install it, and reboot
-    # mount -t debugfs none /sys/kernel/debug/
-    # git clone https://github.com/awslabs/damo
-    # ./damo/damo record $(pidof <your workload>)
-    # ./damo/damo report heats --heatmap stdout
-
-The final command draws the access heatmap of ``<your workload>``.  The heatmap
-shows which memory region (x-axis) is accessed when (y-axis) and how frequently
-(number; the higher the more accesses have been observed). ::
-
-    111111111111111111111111111111111111111111111111111111110000
-    111121111111111111111111111111211111111111111111111111110000
-    000000000000000000000000000000000000000000000000001555552000
-    000000000000000000000000000000000000000000000222223555552000
-    000000000000000000000000000000000000000011111677775000000000
-    000000000000000000000000000000000000000488888000000000000000
-    000000000000000000000000000000000177888400000000000000000000
-    000000000000000000000000000046666522222100000000000000000000
-    000000000000000000000014444344444300000000000000000000000000
-    000000000000000002222245555510000000000000000000000000000000
-    # access_frequency:  0  1  2  3  4  5  6  7  8  9
-    # x-axis: space (140286319947776-140286426374096: 101.496 MiB)
-    # y-axis: time (605442256436361-605479951866441: 37.695430s)
-    # resolution: 60x10 (1.692 MiB and 3.770s for each character)
-
-
 Prerequisites
 =============
 
@@ -93,22 +61,66 @@ pattern in the ``damon.data`` file.
 Visualizing Recorded Patterns
 =============================
 
-The following three commands visualize the recorded access patterns and save
-the results as separate image files. ::
-
-    $ sudo damo report heats --heatmap access_pattern_heatmap.png
-    $ sudo damo report wss --range 0 101 1 --plot wss_dist.png
-    $ sudo damo report wss --range 0 101 1 --sortby time --plot wss_chron_change.png
-
-- ``access_pattern_heatmap.png`` will visualize the data access pattern in a
-  heatmap, showing which memory region (y-axis) got accessed when (x-axis)
-  and how frequently (color).
-- ``wss_dist.png`` will show the distribution of the working set size.
-- ``wss_chron_change.png`` will show how the working set size has
-  chronologically changed.
+You can visualize the pattern in a heatmap, showing which memory region
+(x-axis) got accessed when (y-axis) and how frequently (number).::
 
-You can view the visualizations of this example workload at [1]_.
-Visualizations of other realistic workloads are available at [2]_ [3]_ [4]_.
+    $ sudo damo report heats --heatmap stdout
+    22222222222222222222222222222222222222211111111111111111111111111111111111111100
+    44444444444444444444444444444444444444434444444444444444444444444444444444443200
+    44444444444444444444444444444444444444433444444444444444444444444444444444444200
+    33333333333333333333333333333333333333344555555555555555555555555555555555555200
+    33333333333333333333333333333333333344444444444444444444444444444444444444444200
+    22222222222222222222222222222222222223355555555555555555555555555555555555555200
+    00000000000000000000000000000000000000288888888888888888888888888888888888888400
+    00000000000000000000000000000000000000288888888888888888888888888888888888888400
+    33333333333333333333333333333333333333355555555555555555555555555555555555555200
+    88888888888888888888888888888888888888600000000000000000000000000000000000000000
+    88888888888888888888888888888888888888600000000000000000000000000000000000000000
+    33333333333333333333333333333333333333444444444444444444444444444444444444443200
+    00000000000000000000000000000000000000288888888888888888888888888888888888888400
+    [...]
+    # access_frequency:  0  1  2  3  4  5  6  7  8  9
+    # x-axis: space (139728247021568-139728453431248: 196.848 MiB)
+    # y-axis: time (15256597248362-15326899978162: 1 m 10.303 s)
+    # resolution: 80x40 (2.461 MiB and 1.758 s for each character)
+
+You can also visualize the distribution of the working set size, sorted by the
+size.::
+
+    $ sudo damo report wss --range 0 101 10
+    # <percentile> <wss>
+    # target_id     18446632103789443072
+    # avr:  107.708 MiB
+      0             0 B |                                                           |
+     10      95.328 MiB |****************************                               |
+     20      95.332 MiB |****************************                               |
+     30      95.340 MiB |****************************                               |
+     40      95.387 MiB |****************************                               |
+     50      95.387 MiB |****************************                               |
+     60      95.398 MiB |****************************                               |
+     70      95.398 MiB |****************************                               |
+     80      95.504 MiB |****************************                               |
+     90     190.703 MiB |*********************************************************  |
+    100     196.875 MiB |***********************************************************|
+
+Using ``--sortby`` option with the above command, you can show how the working
+set size has chronologically changed.::
+
+    $ sudo damo report wss --range 0 101 10 --sortby time
+    # <percentile> <wss>
+    # target_id     18446632103789443072
+    # avr:  107.708 MiB
+      0       3.051 MiB |                                                           |
+     10     190.703 MiB |***********************************************************|
+     20      95.336 MiB |*****************************                              |
+     30      95.328 MiB |*****************************                              |
+     40      95.387 MiB |*****************************                              |
+     50      95.332 MiB |*****************************                              |
+     60      95.320 MiB |*****************************                              |
+     70      95.398 MiB |*****************************                              |
+     80      95.398 MiB |*****************************                              |
+     90      95.340 MiB |*****************************                              |
+    100      95.398 MiB |*****************************                              |
 
 
 Data Access Pattern Aware Memory Management
@@ -120,8 +132,3 @@ accessed for >=60 seconds in your worklo
     $ echo "#min-size max-size min-acc max-acc min-age max-age action" > test_scheme
     $ echo "4K        max      0       0       60s     max     pageout" >> test_scheme
     $ damo schemes -c test_scheme <pid of your workload>
-
-.. [1] https://damonitor.github.io/doc/html/v17/admin-guide/mm/damon/start.html#visualizing-recorded-patterns
-.. [2] https://damonitor.github.io/test/result/visual/latest/rec.heatmap.1.png.html
-.. [3] https://damonitor.github.io/test/result/visual/latest/rec.wss_sz.png.html
-.. [4] https://damonitor.github.io/test/result/visual/latest/rec.wss_time.png.html
_

Patches currently in -mm which might be from sj@kernel.org are


