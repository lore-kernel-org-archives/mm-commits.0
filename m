From: akpm@linux-foundation.org
Subject: [merged]
 mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:20:15 -0700
Message-ID: <543c17df.uH/IXe0VV78A3yMW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaJMSUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: kill do_set_mempolicy()->down_write(&mm->mmap_sem)
has been removed from the -mm tree.  Its filename was
     mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: kill do_set_mempolicy()->down_write(&mm->mmap_sem)

Remove down_write(&mm->mmap_sem) in do_set_mempolicy(). This logic
was never correct and it is no longer needed, see the previous patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem
+++ a/mm/mempolicy.c
@@ -802,7 +802,6 @@ static long do_set_mempolicy(unsigned sh
 			     nodemask_t *nodes)
 {
 	struct mempolicy *new, *old;
-	struct mm_struct *mm = current->mm;
 	NODEMASK_SCRATCH(scratch);
 	int ret;
 
@@ -814,20 +813,11 @@ static long do_set_mempolicy(unsigned sh
 		ret = PTR_ERR(new);
 		goto out;
 	}
-	/*
-	 * prevent changing our mempolicy while show_numa_maps()
-	 * is using it.
-	 * Note:  do_set_mempolicy() can be called at init time
-	 * with no 'mm'.
-	 */
-	if (mm)
-		down_write(&mm->mmap_sem);
+
 	task_lock(current);
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
 		task_unlock(current);
-		if (mm)
-			up_write(&mm->mmap_sem);
 		mpol_put(new);
 		goto out;
 	}
@@ -837,9 +827,6 @@ static long do_set_mempolicy(unsigned sh
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
 	task_unlock(current);
-	if (mm)
-		up_write(&mm->mmap_sem);
