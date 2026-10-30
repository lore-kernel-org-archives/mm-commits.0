Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793339659;
	b=cdcWN3TRXd/0eBkCYiGQvJ0JbtOmR9pTmfR75a+uYloJADzbKQvGcA3KPfCCugwXu8vA
	 FpHgp0zU8BMHpFEWh9kEtnHNj0GfJ3kz344crexEi5Jg1TfSY5zbknBiOHTkZNmnnq4Ai
	 bhMFNN+zRaYKUeVx82lyXf+IV8dOatMUNS4JhNirrdAUNkjmJOU2lv5cHPvbytnKeRyFj
	 7tR/vEf4ZZOl0nLWYY3CyJg8Ow+YHSQaLHYoSOrHCHv13HA8g+BsaIXCfXj3e28G/gjVV
	 rrvo1RvRr8z1+LH8hq7HIRe06cLwPGv/whliOcyZ1tRCnVEVXJphBnkfCZdEQJnzFgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793339659;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZL7NMetdY0BSvPHoj3Eu2iZwZNcHbCVJdTiFpq08qnU=;
	b=W7gK4KfhAq3WW9V8cxSiPc5/ZuLuAjxFTqH2gg7FGteAhiDrhfMUJlTM2UNhwc+WPt3u
	 o9qHTFlezZ3QHASV0DqHAeP1KWOyJj2iDfdvXtFziN/9DOvEjERhjJ/jENJvC53t/R5El
	 /CWA15hvJLF93khB2+rRJYUA8tBerggPWQOdMUP7YtQecqrlAU5UXCk+LXql5liKwzUHC
	 u6jddn5d+eFnRD0ZfBhggdFVoSCwU2s5EOZe0nkflKe/+cyGUE6cb+5igwBJ23duaXxdp
	 XeSWsavFJgducK+SibkhlZk4ctd+vxtnjcBrpki6QbvlrEkdbaUv15/XBE/Jz1t12rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="oJSJN/ff";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2EA606A329
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 05:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oJSJN/ff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8049A1F00A15;
	Fri, 30 Oct 2026 05:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793339658;
	bh=ZL7NMetdY0BSvPHoj3Eu2iZwZNcHbCVJdTiFpq08qnU=;
	h=Date:To:From:Subject;
	b=oJSJN/ffpQPAsD7tVwEgxS8Wre+lUMBGB8RE5VKk2n8d/Pp37pm+tg8jxC/mzUblt
	 BGynHJcq2I2WXidVg8AX75b9i5/hmadroLWSHKpxA4NNYK7t8T3SDt8sEuAqeq1xU1
	 7bbQxRD7I185/uIkcNuoVd6qXLbQZIFaCeMxgs+g=
Date: Thu, 29 Oct 2026 22:54:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	sj@kernel.org,rakie.kim@sk.com,lkp@intel.com,joshua.hahnjy@gmail.com,
	david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch added to mm-new branch
Message-Id: <20261030055418.8049A1F00A15@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mempolicy: convert mempolicy refcnt to refcount_t
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: mm/mempolicy: convert mempolicy refcnt to refcount_t
Date: Thu, 15 Oct 2026 19:13:22 -0400

struct mempolicy uses an atomic_t as a pure reference counter.

Convert it to refcount_t so that overflow and underflow are caught by the
refcount saturation checks.

This silences the atomic_as_refcounter.cocci warning, which started
matching __mpol_put() when it switched kmem_cache_free() to kfree_rcu(). 
No functional change for correct callers.

Link: https://lore.kernel.org/20261015231322.3392551-1-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610061946.Bx22ZFrw-lkp@intel.com/
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
---

 include/linux/mempolicy.h |    5 +++--
 mm/mempolicy.c            |   14 +++++++-------
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t
+++ a/include/linux/mempolicy.h
@@ -10,6 +10,7 @@
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 #include <linux/spinlock.h>
 #include <linux/node.h>
 #include <linux/nodemask.h>
@@ -45,7 +46,7 @@ struct mm_struct;
  * to 1, representing the caller of mpol_dup().
  */
 struct mempolicy {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	unsigned short mode; 	/* See MPOL_* above */
 	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
 	nodemask_t nodes;	/* interleave/bind/preferred/etc */
@@ -96,7 +97,7 @@ static inline struct mempolicy *mpol_dup
 static inline void mpol_get(struct mempolicy *pol)
 {
 	if (pol)
-		atomic_inc(&pol->refcnt);
+		refcount_inc(&pol->refcnt);
 }
 
 extern bool __mpol_equal(struct mempolicy *a, struct mempolicy *b);
--- a/mm/mempolicy.c~mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t
+++ a/mm/mempolicy.c
@@ -138,7 +138,7 @@ enum zone_type policy_zone = 0;
  * run-time system-wide default policy => local allocation
  */
 static struct mempolicy default_policy = {
-	.refcnt = ATOMIC_INIT(1), /* never free it */
+	.refcnt = REFCOUNT_INIT(1), /* never free it */
 	.mode = MPOL_LOCAL,
 };
 
@@ -492,7 +492,7 @@ static struct mempolicy *mpol_new(unsign
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
-	atomic_set(&policy->refcnt, 1);
+	refcount_set(&policy->refcnt, 1);
 	policy->mode = mode;
 	policy->flags = flags;
 	policy->home_node = NUMA_NO_NODE;
@@ -503,7 +503,7 @@ static struct mempolicy *mpol_new(unsign
 /* Slow path of a mpol destructor. */
 void __mpol_put(struct mempolicy *pol)
 {
-	if (!atomic_dec_and_test(&pol->refcnt))
+	if (!refcount_dec_and_test(&pol->refcnt))
 		return;
 	/*
 	 * Required to allow mmap_lock_speculative*() access, see for example
@@ -2871,7 +2871,7 @@ struct mempolicy *__mpol_dup(struct memp
 		nodemask_t mems = cpuset_mems_allowed(current);
 		mpol_rebind_policy(new, &mems);
 	}
-	atomic_set(&new->refcnt, 1);
+	refcount_set(&new->refcnt, 1);
 	return new;
 }
 
@@ -3188,7 +3188,7 @@ restart:
 					goto alloc_new;
 
 				*mpol_new = *n->policy;
-				atomic_set(&mpol_new->refcnt, 1);
+				refcount_set(&mpol_new->refcnt, 1);
 				sp_node_init(n_new, end, n->end, mpol_new);
 				n->end = start;
 				sp_insert(sp, n_new);
@@ -3224,7 +3224,7 @@ alloc_new:
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
 		goto err_out;
-	atomic_set(&mpol_new->refcnt, 1);
+	refcount_set(&mpol_new->refcnt, 1);
 	goto restart;
 }
 
@@ -3380,7 +3380,7 @@ void __init numa_policy_init(void)
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {
-			.refcnt = ATOMIC_INIT(1),
+			.refcnt = REFCOUNT_INIT(1),
 			.mode = MPOL_PREFERRED,
 			.flags = MPOL_F_MOF | MPOL_F_MORON,
 			.nodes = nodemask_of_node(nid),
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch
mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch
mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch

