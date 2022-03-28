Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22FCC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 21:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiC1V3C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 17:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiC1V3B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 17:29:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB197E095
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 14:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B199B61505
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 21:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F0C34100;
        Mon, 28 Mar 2022 21:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648502825;
        bh=7ePvnviPfzkURbJeSLu25JVwGYn2DulVstr15e4bgtA=;
        h=Date:To:From:Subject:From;
        b=u7DSmREMR6FGOB6Bbj5zzbfCImUSW/8fzUd3bbqwnU8AvwXQTD0ABLDFCItmvU8lb
         5UmlXLBFHo1Y8m9qm6MhUWLcyB0OyE9DQWnQFW9LHxq4XSycEqQs7ywCgeNl27dqyF
         jJh3nqD/y3+LfD4Y13vKc+31WOm0IeSCvX5AOldE=
Date:   Mon, 28 Mar 2022 14:27:04 -0700
To:     mm-commits@vger.kernel.org, yanfei.xu@windriver.com,
        tanxin.ctf@gmail.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, feng.tang@intel.com,
        ben.widawsky@intel.com, xiyuyang19@fudan.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch removed from -mm tree
Message-Id: <20220328212705.173F0C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: convert from atomic_t to refcount_t on mempolicy->refcnt
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Subject: mm/mempolicy: convert from atomic_t to refcount_t on mempolicy->refcnt

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

[akpm@linux-foundation.org: fix warnings]
Link: https://lkml.kernel.org/r/1626683671-64407-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    5 +++--
 mm/mempolicy.c            |   12 ++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt
+++ a/include/linux/mempolicy.h
@@ -6,6 +6,7 @@
 #ifndef _LINUX_MEMPOLICY_H
 #define _LINUX_MEMPOLICY_H 1
 
+#include <linux/refcount.h>
 #include <linux/sched.h>
 #include <linux/mmzone.h>
 #include <linux/slab.h>
@@ -42,7 +43,7 @@ struct mm_struct;
  * to 1, representing the caller of mpol_dup().
  */
 struct mempolicy {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	unsigned short mode; 	/* See MPOL_* above */
 	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
 	nodemask_t nodes;	/* interleave/bind/perfer */
@@ -94,7 +95,7 @@ static inline struct mempolicy *mpol_dup
 static inline void mpol_get(struct mempolicy *pol)
 {
 	if (pol)
-		atomic_inc(&pol->refcnt);
+		refcount_inc(&pol->refcnt);
 }
 
 extern bool __mpol_equal(struct mempolicy *a, struct mempolicy *b);
--- a/mm/mempolicy.c~mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt
+++ a/mm/mempolicy.c
@@ -123,7 +123,7 @@ enum zone_type policy_zone = 0;
  * run-time system-wide default policy => local allocation
  */
 static struct mempolicy default_policy = {
-	.refcnt = ATOMIC_INIT(1), /* never free it */
+	.refcnt = { ATOMIC_INIT(1), }, /* never free it */
 	.mode = MPOL_LOCAL,
 };
 
@@ -295,7 +295,7 @@ static struct mempolicy *mpol_new(unsign
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
-	atomic_set(&policy->refcnt, 1);
+	refcount_set(&policy->refcnt, 1);
 	policy->mode = mode;
 	policy->flags = flags;
 	policy->home_node = NUMA_NO_NODE;
@@ -306,7 +306,7 @@ static struct mempolicy *mpol_new(unsign
 /* Slow path of a mpol destructor. */
 void __mpol_put(struct mempolicy *p)
 {
-	if (!atomic_dec_and_test(&p->refcnt))
+	if (!refcount_dec_and_test(&p->refcnt))
 		return;
 	kmem_cache_free(policy_cache, p);
 }
@@ -2400,7 +2400,7 @@ struct mempolicy *__mpol_dup(struct memp
 		nodemask_t mems = cpuset_mems_allowed(current);
 		mpol_rebind_policy(new, &mems);
 	}
-	atomic_set(&new->refcnt, 1);
+	refcount_set(&new->refcnt, 1);
 	return new;
 }
 
@@ -2697,7 +2697,7 @@ restart:
 					goto alloc_new;
 
 				*mpol_new = *n->policy;
-				atomic_set(&mpol_new->refcnt, 1);
+				refcount_set(&mpol_new->refcnt, 1);
 				sp_node_init(n_new, end, n->end, mpol_new);
 				n->end = start;
 				sp_insert(sp, n_new);
@@ -2891,7 +2891,7 @@ void __init numa_policy_init(void)
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {
-			.refcnt = ATOMIC_INIT(1),
+			.refcnt = { ATOMIC_INIT(1), },
 			.mode = MPOL_PREFERRED,
 			.flags = MPOL_F_MOF | MPOL_F_MORON,
 			.nodes = nodemask_of_node(nid),
_

Patches currently in -mm which might be from xiyuyang19@fudan.edu.cn are

mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount.patch

