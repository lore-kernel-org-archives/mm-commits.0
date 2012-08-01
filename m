From: akpm@linux-foundation.org
Subject: [merged] documentation-update-how-page-cluster-affects-swap-i-o.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:50 -0700
Message-ID: <20120801201150.B95091E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAULv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:51 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ehrhardt@linux.vnet.ibm.com, axboe@kernel.dk, hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: documentation: update how page-cluster affects swap I/O
has been removed from the -mm tree.  Its filename was
     documentation-update-how-page-cluster-affects-swap-i-o.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: documentation: update how page-cluster affects swap I/O

Fix of the documentation of /proc/sys/vm/page-cluster to match the
behavior of the code and add some comments about what the tunable will
change in that behavior.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/vm.txt~documentation-update-how-page-cluster-affects-swap-i-o Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~documentation-update-how-page-cluster-affects-swap-i-o
+++ a/Documentation/sysctl/vm.txt
@@ -574,16 +574,24 @@ of physical RAM.  See above.
 
 page-cluster
 
-page-cluster controls the number of pages which are written to swap in
-a single attempt.  The swap I/O size.
+page-cluster controls the number of pages up to which consecutive pages
+are read in from swap in a single attempt. This is the swap counterpart
+to page cache readahead.
+The mentioned consecutivity is not in terms of virtual/physical addresses,
+but consecutive on swap space - that means they were swapped out together.
 
 It is a logarithmic value - setting it to zero means "1 page", setting
 it to 1 means "2 pages", setting it to 2 means "4 pages", etc.
+Zero disables swap readahead completely.
 
 The default value is three (eight pages at a time).  There may be some
 small benefits in tuning this to a different value if your workload is
 swap-intensive.
 
+Lower values mean lower latencies for initial faults, but at the same time
+extra faults and I/O delays for following faults if they would have been part of
+that consecutive pages readahead would have brought in.
+
 =============================================================
 
 panic_on_oom
_

Patches currently in -mm which might be from ehrhardt@linux.vnet.ibm.com are

origin.patch

