From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:11 -0700
Message-ID: <52321913.pN3XmLN0SmhJiuS/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org, oleg@redhat.com

Subject: [merged] mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch removed from -mm tree
To: oleg@redhat.com,andi@firstfloor.org,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,riel@redhat.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:11 -0700


The patch titled
     Subject: mm: mempolicy: turn vma_set_policy() into vma_dup_policy()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: mempolicy: turn vma_set_policy() into vma_dup_policy()

Simple cleanup. Every user of vma_set_policy() does the same work,
this looks a bit annoying imho. And the new trivial helper which
does mpol_dup() + vma_set_policy() to simplify the callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    9 +++++++--
 kernel/fork.c             |    9 +++------
 mm/mempolicy.c            |   10 ++++++++++
 mm/mmap.c                 |   17 +++++------------
 4 files changed, 25 insertions(+), 20 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy
+++ a/include/linux/mempolicy.h
@@ -91,7 +91,6 @@ static inline struct mempolicy *mpol_dup
 }
 
 #define vma_policy(vma) ((vma)->vm_policy)
-#define vma_set_policy(vma, pol) ((vma)->vm_policy = (pol))
 
 static inline void mpol_get(struct mempolicy *pol)
 {
@@ -126,6 +125,7 @@ struct shared_policy {
 	spinlock_t lock;
 };
 
+int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst);
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
@@ -240,7 +240,12 @@ mpol_shared_policy_lookup(struct shared_
 }
 
 #define vma_policy(vma) NULL
-#define vma_set_policy(vma, pol) do {} while(0)
+
+static inline int
+vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
+{
+	return 0;
+}
 
 static inline void numa_policy_init(void)
 {
diff -puN kernel/fork.c~mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy kernel/fork.c
--- a/kernel/fork.c~mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy
+++ a/kernel/fork.c
@@ -351,7 +351,6 @@ static int dup_mmap(struct mm_struct *mm
 	struct rb_node **rb_link, *rb_parent;
 	int retval;
 	unsigned long charge;
-	struct mempolicy *pol;
 
 	uprobe_start_dup_mmap();
 	down_write(&oldmm->mmap_sem);
@@ -400,11 +399,9 @@ static int dup_mmap(struct mm_struct *mm
 			goto fail_nomem;
 		*tmp = *mpnt;
 		INIT_LIST_HEAD(&tmp->anon_vma_chain);
-		pol = mpol_dup(vma_policy(mpnt));
-		retval = PTR_ERR(pol);
-		if (IS_ERR(pol))
+		retval = vma_dup_policy(mpnt, tmp);
+		if (retval)
 			goto fail_nomem_policy;
-		vma_set_policy(tmp, pol);
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
@@ -472,7 +469,7 @@ out:
 	uprobe_end_dup_mmap();
 	return retval;
 fail_nomem_anon_vma_fork:
-	mpol_put(pol);
+	mpol_put(vma_policy(tmp));
 fail_nomem_policy:
 	kmem_cache_free(vm_area_cachep, tmp);
 fail_nomem:
diff -puN mm/mempolicy.c~mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy
+++ a/mm/mempolicy.c
@@ -2065,6 +2065,16 @@ retry_cpuset:
 }
 EXPORT_SYMBOL(alloc_pages_current);
 
+int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
+{
+	struct mempolicy *pol = mpol_dup(vma_policy(src));
+
+	if (IS_ERR(pol))
+		return PTR_ERR(pol);
+	dst->vm_policy = pol;
+	return 0;
+}
+
 /*
  * If mpol_dup() sees current->cpuset == cpuset_being_rebound, then it
  * rebinds the mempolicy its copying by calling mpol_rebind_policy()
diff -puN mm/mmap.c~mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy mm/mmap.c
--- a/mm/mmap.c~mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy
+++ a/mm/mmap.c
@@ -2380,7 +2380,6 @@ detach_vmas_to_be_unmapped(struct mm_str
 static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	      unsigned long addr, int new_below)
 {
-	struct mempolicy *pol;
 	struct vm_area_struct *new;
 	int err = -ENOMEM;
 
@@ -2404,12 +2403,9 @@ static int __split_vma(struct mm_struct
 		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
 	}
 
-	pol = mpol_dup(vma_policy(vma));
-	if (IS_ERR(pol)) {
-		err = PTR_ERR(pol);
+	err = vma_dup_policy(vma, new);
+	if (err)
 		goto out_free_vma;
-	}
-	vma_set_policy(new, pol);
 
 	if (anon_vma_clone(new, vma))
 		goto out_free_mpol;
@@ -2437,7 +2433,7 @@ static int __split_vma(struct mm_struct
 		fput(new->vm_file);
 	unlink_anon_vmas(new);
  out_free_mpol:
-	mpol_put(pol);
+	mpol_put(vma_policy(new));
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new);
  out_err:
@@ -2780,7 +2776,6 @@ struct vm_area_struct *copy_vma(struct v
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma, *prev;
 	struct rb_node **rb_link, *rb_parent;
-	struct mempolicy *pol;
 	bool faulted_in_anon_vma = true;
 
 	/*
@@ -2825,10 +2820,8 @@ struct vm_area_struct *copy_vma(struct v
 			new_vma->vm_start = addr;
 			new_vma->vm_end = addr + len;
 			new_vma->vm_pgoff = pgoff;
-			pol = mpol_dup(vma_policy(vma));
-			if (IS_ERR(pol))
+			if (vma_dup_policy(vma, new_vma))
 				goto out_free_vma;
-			vma_set_policy(new_vma, pol);
 			INIT_LIST_HEAD(&new_vma->anon_vma_chain);
 			if (anon_vma_clone(new_vma, vma))
 				goto out_free_mempol;
@@ -2843,7 +2836,7 @@ struct vm_area_struct *copy_vma(struct v
 	return new_vma;
 
  out_free_mempol:
-	mpol_put(pol);
+	mpol_put(vma_policy(new_vma));
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new_vma);
 	return NULL;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch

