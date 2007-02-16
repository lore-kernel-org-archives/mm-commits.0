From: akpm@linux-foundation.org
Subject: + fix-mempolicys-check-on-a-system-with-memory-less-node.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:41:37 -0800
Message-ID: <200702160041.l1G0fbuH014025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40527 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422916AbXBPAlp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 19:41:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, ak@suse.de, clameter@sgi.com


The patch titled
     fix mempolicy's check on a system with memory-less-node
has been added to the -mm tree.  Its filename is
     fix-mempolicys-check-on-a-system-with-memory-less-node.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix mempolicy's check on a system with memory-less-node
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

bind_zonelist() can create zero-length zonelist if there is a
memory-less-node.  This patch checks the length of zonelist.  If length is
0, returns -EINVAL.

tested on ia64/NUMA with memory-less-node.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~fix-mempolicys-check-on-a-system-with-memory-less-node mm/mempolicy.c
--- a/mm/mempolicy.c~fix-mempolicys-check-on-a-system-with-memory-less-node
+++ a/mm/mempolicy.c
@@ -144,7 +144,7 @@ static struct zonelist *bind_zonelist(no
 	max++;			/* space for zlcache_ptr (see mmzone.h) */
 	zl = kmalloc(sizeof(struct zone *) * max, GFP_KERNEL);
 	if (!zl)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	zl->zlcache_ptr = NULL;
 	num = 0;
 	/* First put in the highest zones from all nodes, then all the next 
@@ -162,6 +162,10 @@ static struct zonelist *bind_zonelist(no
 			break;
 		k--;
 	}
+	if (num == 0) {
+		kfree(zl);
+		return ERR_PTR(-EINVAL);
+	}
 	zl->zones[num] = NULL;
 	return zl;
 }
@@ -193,9 +197,10 @@ static struct mempolicy *mpol_new(int mo
 		break;
 	case MPOL_BIND:
 		policy->v.zonelist = bind_zonelist(nodes);
-		if (policy->v.zonelist == NULL) {
+		if (IS_ERR(policy->v.zonelist)) {
+			void *error_code = policy->v.zonelist;
 			kmem_cache_free(policy_cache, policy);
-			return ERR_PTR(-ENOMEM);
+			return error_code;
 		}
 		break;
 	}
@@ -1667,7 +1672,7 @@ void mpol_rebind_policy(struct mempolicy
 		 * then zonelist_policy() will "FALL THROUGH" to MPOL_DEFAULT.
 		 */
 
-		if (zonelist) {
+		if (!IS_ERR(zonelist)) {
 			/* Good - got mem - substitute new zonelist */
 			kfree(pol->v.zonelist);
 			pol->v.zonelist = zonelist;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

fix-mempolicys-check-on-a-system-with-memory-less-node.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch
