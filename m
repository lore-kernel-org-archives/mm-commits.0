From: akpm@linux-foundation.org
Subject: + documentation-update-how-page-cluster-affects-swap-i-o.patch added to -mm tree
Date: Tue, 05 Jun 2012 16:46:20 -0700
Message-ID: <20120605234620.E6683A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59051 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FEXqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 19:46:23 -0400
Received: by wgbdt11 with SMTP id dt11so363731wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 16:46:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ehrhardt@linux.vnet.ibm.com, axboe@kernel.dk, hughd@google.com, minchan@kernel.org


The patch titled
     Subject: documentation: update how page-cluster affects swap I/O
has been added to the -mm tree.  Its filename is
     documentation-update-how-page-cluster-affects-swap-i-o.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: documentation: update how page-cluster affects swap I/O

Patches currently in -mm which might be from ehrhardt@linux.vnet.ibm.com are

swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch

