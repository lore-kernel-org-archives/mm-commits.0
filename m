From: akpm@linux-foundation.org
Subject: + fs-proc-inodec-use-rcu_init_pointerx-null.patch added to -mm
 tree
Date: Fri, 28 Mar 2014 15:04:23 -0700
Message-ID: <5335f1e7.NOcIatqhybuXKqy6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaC1WEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 18:04:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmck@us.ibm.com, monamagarwal123@gmail.com

Subject: + fs-proc-inodec-use-rcu_init_pointerx-null.patch added to -mm tree
To: monamagarwal123@gmail.com,paulmck@us.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 15:04:23 -0700


The patch titled
     Subject: fs/proc/inode.c: use RCU_INIT_POINTER(x, NULL)
has been added to the -mm tree.  Its filename is
     fs-proc-inodec-use-rcu_init_pointerx-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-inodec-use-rcu_init_pointerx-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-inodec-use-rcu_init_pointerx-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-make-return-is-not-a-function-test-quieter.patch
fs-proc-inodec-use-rcu_init_pointerx-null.patch
lib-idrc-use-rcu_init_pointerx-null.patch
linux-next.patch

