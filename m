From: akpm@linux-foundation.org
Subject: [merged] ksm-change-ksm-nice-level-to-be-5.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:39 -0700
Message-ID: <200909222039.n8MKdd3C003842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbZIVUmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, lee.s


The patch titled
     ksm: change ksm nice level to be 5
has been removed from the -mm tree.  Its filename was
     ksm-change-ksm-nice-level-to-be-5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: change ksm nice level to be 5
From: Izik Eidus <ieidus@redhat.com>

ksm should try not to disturb other tasks as much as possible.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-change-ksm-nice-level-to-be-5 mm/ksm.c
--- a/mm/ksm.c~ksm-change-ksm-nice-level-to-be-5
+++ a/mm/ksm.c
@@ -1263,7 +1263,7 @@ static void ksm_do_scan(unsigned int sca
 
 static int ksm_scan_thread(void *nothing)
 {
-	set_user_nice(current, 0);
+	set_user_nice(current, 5);
 
 	while (!kthread_should_stop()) {
 		if (ksm_run & KSM_RUN_MERGE) {
_

Patches currently in -mm which might be from ieidus@redhat.com are

origin.patch

