From: akpm@linux-foundation.org
Subject: - numa-mempolicy-trivial-debug-fixes.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:24 -0700
Message-ID: <200707162049.l6GKnOiT001158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759751AbXGPV1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     numa: mempolicy: trivial debug fixes.
has been removed from the -mm tree.  Its filename was
     numa-mempolicy-trivial-debug-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: numa: mempolicy: trivial debug fixes.
From: Paul Mundt <lethal@linux-sh.org>

Enabling debugging fails to build due to the nodemask variable in
do_mbind() having changed names, and then oopses on boot due to the
assumption that the nodemask can be dereferenced -- which doesn't work out
so well when the policy is changed to MPOL_DEFAULT with a NULL nodemask by
numa_default_policy().

This fixes it up, and switches from PDprintk() to pr_debug() while
we're at it.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/mempolicy.c~numa-mempolicy-trivial-debug-fixes mm/mempolicy.c
--- a/mm/mempolicy.c~numa-mempolicy-trivial-debug-fixes
+++ a/mm/mempolicy.c
@@ -101,8 +101,6 @@
 static struct kmem_cache *policy_cache;
 static struct kmem_cache *sn_cache;
 
-#define PDprintk(fmt...)
-
 /* Highest zone. An specific allocation for a zone below that is not
    policied. */
 enum zone_type policy_zone = 0;
@@ -175,7 +173,9 @@ static struct mempolicy *mpol_new(int mo
 {
 	struct mempolicy *policy;
 
-	PDprintk("setting mode %d nodes[0] %lx\n", mode, nodes_addr(*nodes)[0]);
+	pr_debug("setting mode %d nodes[0] %lx\n",
+		 mode, nodes ? nodes_addr(*nodes)[0] : -1);
+
 	if (mode == MPOL_DEFAULT)
 		return NULL;
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
@@ -379,7 +379,7 @@ static int policy_vma(struct vm_area_str
 	int err = 0;
 	struct mempolicy *old = vma->vm_policy;
 
-	PDprintk("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
+	pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
 		 vma->vm_start, vma->vm_end, vma->vm_pgoff,
 		 vma->vm_ops, vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->set_policy : NULL);
@@ -776,8 +776,8 @@ long do_mbind(unsigned long start, unsig
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	PDprintk("mbind %lx-%lx mode:%ld nodes:%lx\n",start,start+len,
-			mode,nodes_addr(nodes)[0]);
+	pr_debug("mbind %lx-%lx mode:%ld nodes:%lx\n",start,start+len,
+		 mode, nmask ? nodes_addr(*nmask)[0] : -1);
 
 	down_write(&mm->mmap_sem);
 	vma = check_range(mm, start, end, nmask,
@@ -1434,7 +1434,7 @@ static void sp_insert(struct shared_poli
 	}
 	rb_link_node(&new->nd, parent, p);
 	rb_insert_color(&new->nd, &sp->root);
-	PDprintk("inserting %lx-%lx: %d\n", new->start, new->end,
+	pr_debug("inserting %lx-%lx: %d\n", new->start, new->end,
 		 new->policy ? new->policy->policy : 0);
 }
 
@@ -1459,7 +1459,7 @@ mpol_shared_policy_lookup(struct shared_
 
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
-	PDprintk("deleting %lx-l%x\n", n->start, n->end);
+	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
 	rb_erase(&n->nd, &sp->root);
 	mpol_free(n->policy);
 	kmem_cache_free(sn_cache, n);
@@ -1558,10 +1558,10 @@ int mpol_set_shared_policy(struct shared
 	struct sp_node *new = NULL;
 	unsigned long sz = vma_pages(vma);
 
-	PDprintk("set_shared_policy %lx sz %lu %d %lx\n",
+	pr_debug("set_shared_policy %lx sz %lu %d %lx\n",
 		 vma->vm_pgoff,
 		 sz, npol? npol->policy : -1,
-		npol ? nodes_addr(npol->v.nodes)[0] : -1);
+		 npol ? nodes_addr(npol->v.nodes)[0] : -1);
 
 	if (npol) {
 		new = sp_alloc(vma->vm_pgoff, vma->vm_pgoff + sz, npol);
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
fb-epson1355fb-kill-off-dead-sh-support.patch
