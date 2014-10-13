From: akpm@linux-foundation.org
Subject: [merged]
 mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:05 -0700
Message-ID: <543c17d5.JciRFcIGKrg+iqtQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaJMSUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: change get_task_policy() to return default_policy rather than NULL
has been removed from the -mm tree.  Its filename was
     mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: change get_task_policy() to return default_policy rather than NULL

Every caller of get_task_policy() falls back to default_policy if it
returns NULL. Change get_task_policy() to do this.

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

 mm/mempolicy.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null
+++ a/mm/mempolicy.c
@@ -126,22 +126,20 @@ static struct mempolicy preferred_node_p
 static struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
+	int node;
 
-	if (!pol) {
-		int node = numa_node_id();
+	if (pol)
+		return pol;
 
-		if (node != NUMA_NO_NODE) {
-			pol = &preferred_node_policy[node];
-			/*
-			 * preferred_node_policy is not initialised early in
-			 * boot
-			 */
-			if (!pol->mode)
-				pol = NULL;
-		}
+	node = numa_node_id();
+	if (node != NUMA_NO_NODE) {
+		pol = &preferred_node_policy[node];
+		/* preferred_node_policy is not initialised early in boot */
+		if (pol->mode)
+			return pol;
 	}
 
-	return pol;
+	return &default_policy;
 }
 
 static const struct mempolicy_operations {
@@ -1644,14 +1642,14 @@ struct mempolicy *get_vma_policy(struct
 				mpol_get(pol);
 		}
 	}
-	if (!pol)
-		pol = &default_policy;
+
 	return pol;
 }
 
 bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
 {
 	struct mempolicy *pol = get_task_policy(task);
+
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
 			bool ret = false;
@@ -1667,9 +1665,6 @@ bool vma_policy_mof(struct task_struct *
 		}
 	}
 
-	if (!pol)
-		return default_policy.flags & MPOL_F_MOF;
