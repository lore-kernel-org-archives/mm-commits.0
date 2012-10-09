From: akpm@linux-foundation.org
Subject: [merged] mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:06:57 -0700
Message-ID: <20121009180658.27BF520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33588 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:00 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365043wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:06:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux.com, jwboyer@gmail.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: fix refcount leak in mpol_set_shared_policy()
has been removed from the -mm tree.  Its filename was
     mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mempolicy: fix refcount leak in mpol_set_shared_policy()

When shared_policy_replace() fails to allocate new->policy is not freed
correctly by mpol_set_shared_policy().  The problem is that shared
mempolicy code directly call kmem_cache_free() in multiple places where it
is easy to make a mistake.

This patch creates an sp_free wrapper function and uses it. The bug was
introduced pre-git age (IOW, before 2.6.12-rc2).

[mgorman@suse.de: Editted changelog]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-fix-refcount-leak-in-mpol_set_shared_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fix-refcount-leak-in-mpol_set_shared_policy
+++ a/mm/mempolicy.c
@@ -2157,12 +2157,17 @@ mpol_shared_policy_lookup(struct shared_
 	return pol;
 }
 
+static void sp_free(struct sp_node *n)
+{
+	mpol_put(n->policy);
+	kmem_cache_free(sn_cache, n);
+}
+
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
 	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
 	rb_erase(&n->nd, &sp->root);
-	mpol_put(n->policy);
-	kmem_cache_free(sn_cache, n);
+	sp_free(n);
 }
 
 static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
@@ -2301,7 +2306,7 @@ int mpol_set_shared_policy(struct shared
 	}
 	err = shared_policy_replace(info, vma->vm_pgoff, vma->vm_pgoff+sz, new);
 	if (err && new)
-		kmem_cache_free(sn_cache, new);
+		sp_free(new);
 	return err;
 }
 
@@ -2318,9 +2323,7 @@ void mpol_free_shared_policy(struct shar
 	while (next) {
 		n = rb_entry(next, struct sp_node, nd);
 		next = rb_next(&n->nd);
-		rb_erase(&n->nd, &p->root);
-		mpol_put(n->policy);
-		kmem_cache_free(sn_cache, n);
+		sp_delete(p, n);
 	}
 	mutex_unlock(&p->mutex);
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch

