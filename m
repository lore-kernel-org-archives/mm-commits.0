From: akpm@linux-foundation.org
Subject: [merged] hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:44 -0800
Message-ID: <200912152154.nBFLsiSQ015384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761275AbZLOVz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:55:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: abort a hugepage pool resize if a signal is pending
has been removed from the -mm tree.  Its filename was
     hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: abort a hugepage pool resize if a signal is pending
From: Mel Gorman <mel@csn.ul.ie>

If a user asks for a hugepage pool resize but specified a large number,
the machine can begin trashing.  In response, they might hit ctrl-c but
signals are ignored and the pool resize continues until it fails an
allocation.  This can take a considerable amount of time so this patch
aborts a pool resize if a signal is pending.

Suggested by Dave Hansen.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending
+++ a/mm/hugetlb.c
@@ -1278,6 +1278,9 @@ static unsigned long set_max_huge_pages(
 		if (!ret)
 			goto out;
 
+		/* Bail for signals. Probably ctrl-c from user */
+		if (signal_pending(current))
+			goto out;
 	}
 
 	/*
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
powerpc-make-the-cmm-memory-hotplug-aware-update.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

