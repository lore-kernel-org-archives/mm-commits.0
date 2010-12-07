From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch removed from -mm tree
Date: Tue, 07 Dec 2010 11:46:32 -0800
Message-ID: <201012071948.oB7Jm78B004585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144Ab0LGTsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 14:48:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zengzm.kernel@gmail.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm/mempolicy.c: add rcu read lock to protect pid structure
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/mempolicy.c: add rcu read lock to protect pid structure
From: Zeng Zhaoming <zengzm.kernel@gmail.com>

find_task_by_vpid() should be protected by rcu_read_lock(), to prevent
free_pid() reclaiming pid.

Signed-off-by: Zeng Zhaoming <zengzm.kernel@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mempolicy.c~mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure
+++ a/mm/mempolicy.c
@@ -1307,15 +1307,18 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 		goto out;
 
 	/* Find the mm_struct */
+	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
 		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		err = -ESRCH;
 		goto out;
 	}
 	mm = get_task_mm(task);
 	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	err = -EINVAL;
 	if (!mm)
_

Patches currently in -mm which might be from zengzm.kernel@gmail.com are

origin.patch
linux-next.patch

