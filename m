From: akpm@linux-foundation.org
Subject: - mempolicy-small-header-file-cleanup.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:46 -0700
Message-ID: <200804282151.m3SLpkpE017602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964988AbYD1Vv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: small header file cleanup
has been removed from the -mm tree.  Its filename was
     mempolicy-small-header-file-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: small header file cleanup
From: David Rientjes <rientjes@google.com>

Removes forward definition of vm_area_struct in linux/mempolicy.h.  We already
get it from the linux/slab.h -> linux/gfp.h include.

Removes the unused mpol_set_vma_default() macro from linux/mempolicy.h.

Removes the extern definition of default_policy since it is only referenced,
as it should be, in mm/mempolicy.c.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-small-header-file-cleanup include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-small-header-file-cleanup
+++ a/include/linux/mempolicy.h
@@ -52,7 +52,6 @@ enum {
 #include <linux/spinlock.h>
 #include <linux/nodemask.h>
 
-struct vm_area_struct;
 struct mm_struct;
 
 #ifdef CONFIG_NUMA
@@ -131,10 +130,6 @@ static inline int mpol_equal(struct memp
 	return __mpol_equal(a, b);
 }
 
-/* Could later add inheritance of the process policy here. */
-
-#define mpol_set_vma_default(vma) ((vma)->vm_policy = NULL)
-
 /*
  * Tree of shared policies for a shared memory region.
  * Maintain the policies in a pseudo mm that contains vmas. The vmas
@@ -170,7 +165,6 @@ extern void mpol_rebind_task(struct task
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 extern void mpol_fix_fork_child_flag(struct task_struct *p);
 
-extern struct mempolicy default_policy;
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
@@ -196,8 +190,6 @@ static inline int mpol_equal(struct memp
 	return 1;
 }
 
-#define mpol_set_vma_default(vma) do {} while(0)
