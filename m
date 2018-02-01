From: akpm@linux-foundation.org
Subject: [patch 036/119] mm/mempolicy: add nodes_empty check in
 SYSC_migrate_pages
Date: Wed, 31 Jan 2018 16:16:15 -0800
Message-ID: <20180201001615.pA1RxcFNM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754458AbeBAAQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:16:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, cl@linux.com, mingo@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, salls@cs.ucsb.edu, tanxiaojun@huawei.com, torvalds@linux-foundation.org, vbabka@suse.cz, xieyisheng1@huawei.com

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/mempolicy: add nodes_empty check in SYSC_migrate_pages

As in manpage of migrate_pages, the errno should be set to EINVAL when
none of the node IDs specified by new_nodes are on-line and allowed by the
process's current cpuset context, or none of the specified nodes contain
memory.  However, when test by following case:

	new_nodes = 0;
	old_nodes = 0xf;
	ret = migrate_pages(pid, old_nodes, new_nodes, MAX);

The ret will be 0 and no errno is set.  As the new_nodes is empty, we
should expect EINVAL as documented.

To fix the case like above, this patch check whether target nodes AND
current task_nodes is empty, and then check whether AND
node_states[N_MEMORY] is empty.

Link: http://lkml.kernel.org/r/1510882624-44342-4-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Chris Salls <salls@cs.ucsb.edu>
Cc: Christopher Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tan Xiaojun <tanxiaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-add-nodes_empty-check-in-sysc_migrate_pages mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-add-nodes_empty-check-in-sysc_migrate_pages
+++ a/mm/mempolicy.c
@@ -1433,10 +1433,14 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 		goto out_put;
 	}
 
-	if (!nodes_subset(*new, node_states[N_MEMORY])) {
-		err = -EINVAL;
+	task_nodes = cpuset_mems_allowed(current);
+	nodes_and(*new, *new, task_nodes);
+	if (nodes_empty(*new))
+		goto out_put;
+
+	nodes_and(*new, *new, node_states[N_MEMORY]);
+	if (nodes_empty(*new))
 		goto out_put;
-	}
 
 	err = security_task_movememory(task);
 	if (err)
_
