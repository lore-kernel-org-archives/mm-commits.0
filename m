From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch added to -mm tree
Date: Fri, 05 Nov 2010 13:50:51 -0700
Message-ID: <201011052050.oA5KopfC031749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375Ab0KEUvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 16:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zengzm.kernel@gmail.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, paulmck@us.ibm.com


The patch titled
     mm/mempolicy.c: add rcu read lock to protect pid structure
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch

