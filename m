From: akpm@linux-foundation.org
Subject: [merged] mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:11 -0700
Message-ID: <20121009181111.B3D54100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:37488 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2JISLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:12 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so662526qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.p.zijlstra@chello.nl, haggaie@mellanox.com, sagig@mellanox.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmu_notifier: make the mmu_notifier srcu static
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: mmu_notifier: make the mmu_notifier srcu static

The variable must be static especially given the variable name.

s/RCU/SRCU/ over a few comments.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-make-the-mmu_notifier-srcu-static mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-make-the-mmu_notifier-srcu-static
+++ a/mm/mmu_notifier.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 
 /* global SRCU for all MMs */
-struct srcu_struct srcu;
+static struct srcu_struct srcu;
 
 /*
  * This function can't run concurrently against mmu_notifier_register
@@ -41,7 +41,7 @@ void __mmu_notifier_release(struct mm_st
 	int id;
 
 	/*
-	 * RCU here will block mmu_notifier_unregister until
+	 * SRCU here will block mmu_notifier_unregister until
 	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
@@ -302,7 +302,7 @@ void mmu_notifier_unregister(struct mmu_
 
 	if (!hlist_unhashed(&mn->hlist)) {
 		/*
-		 * RCU here will force exit_mmap to wait ->release to finish
+		 * SRCU here will force exit_mmap to wait ->release to finish
 		 * before freeing the pages.
 		 */
 		int id;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

