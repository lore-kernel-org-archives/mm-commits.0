From: akpm@linux-foundation.org
Subject: [merged]
 mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:09 -0700
Message-ID: <51dc9aa9.21euEzmeuJ2GHQ+r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3GIXUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:09 -0700


The patch titled
     Subject: mm/writeback: commit reason of WB_REASON_FORKER_THREAD mismatch name
has been removed from the -mm tree.  Its filename was
     mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/writeback: commit reason of WB_REASON_FORKER_THREAD mismatch name

After 839a8e86 ("writeback: replace custom worker pool implementation with
unbound workqueue"), there is no bdi forker thread any more.  However,
WB_REASON_FORKER_THREAD is still used due to it is TPs userland visible
and we won't be exposing exactly the same information with just a
different name.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/writeback.h~mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name include/linux/writeback.h
--- a/include/linux/writeback.h~mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name
+++ a/include/linux/writeback.h
@@ -47,6 +47,12 @@ enum wb_reason {
 	WB_REASON_LAPTOP_TIMER,
 	WB_REASON_FREE_MORE_MEM,
 	WB_REASON_FS_FREE_SPACE,
+	/*
+	 * There is no bdi forker thread any more and works are done
+	 * by emergency worker, however, this is TPs userland visible
+	 * and we'll be exposing exactly the same information,
+	 * so it has a mismatch name.
+	 */
 	WB_REASON_FORKER_THREAD,
 
 	WB_REASON_MAX,
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
linux-next.patch

