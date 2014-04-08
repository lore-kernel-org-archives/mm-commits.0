From: akpm@linux-foundation.org
Subject: [merged] fs-proc-inodec-use-rcu_init_pointerx-null.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:17:20 -0700
Message-ID: <53446760.V3kI/fICiGnUdYvJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbaDHVRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmck@us.ibm.com, monamagarwal123@gmail.com

Subject: [merged] fs-proc-inodec-use-rcu_init_pointerx-null.patch removed from -mm tree
To: monamagarwal123@gmail.com,paulmck@us.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:17:20 -0700


The patch titled
     Subject: fs/proc/inode.c: use RCU_INIT_POINTER(x, NULL)
has been removed from the -mm tree.  Its filename was
     fs-proc-inodec-use-rcu_init_pointerx-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Monam Agarwal <monamagarwal123@gmail.com>
Subject: fs/proc/inode.c: use RCU_INIT_POINTER(x, NULL)

Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure is
carried out before storing a pointer to that structure.  And in the case
of the NULL pointer, there is no structure to initialize.  So,
rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p,
NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~fs-proc-inodec-use-rcu_init_pointerx-null fs/proc/inode.c
--- a/fs/proc/inode.c~fs-proc-inodec-use-rcu_init_pointerx-null
+++ a/fs/proc/inode.c
@@ -47,7 +47,7 @@ static void proc_evict_inode(struct inod
 		pde_put(de);
 	head = PROC_I(inode)->sysctl;
 	if (head) {
-		rcu_assign_pointer(PROC_I(inode)->sysctl, NULL);
+		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
 		sysctl_head_put(head);
 	}
 	/* Release any associated namespace */
_

Patches currently in -mm which might be from monamagarwal123@gmail.com are

origin.patch

