Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628FEC07E9B
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB1560D07
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhGTV6z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhGTV6y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:58:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0158E60725;
        Tue, 20 Jul 2021 22:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626820770;
        bh=Ztx/RvdbqudXQ5Ph1z0T7NEYqPO+yinWZ93eDn4Erh4=;
        h=Date:From:To:Subject:From;
        b=tm33Z2x+b9Cxwb6848PQEUqwkcx9tFAgrdg5nJXeQP7MP870WJ/GRdSwIbq9N90Yr
         iSUqK2pNnyW0w3FajajEnIxsvgManCogMs4Dipv8O8eZQQkIkN7m9SeE2UhtzahN0d
         cfGVmshd35HvOkNOdwaRH+Trsx3wUFoyalXTJds8=
Date:   Tue, 20 Jul 2021 15:39:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yanfei.xu@windriver.com,
        tanxin.ctf@gmail.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, feng.tang@intel.com,
        ben.widawsky@intel.com, xiyuyang19@fudan.edu.cn
Subject:  +
 mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch
 added to -mm tree
Message-ID: <20210720223929.xzW3r%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: convert from atomic_t to refcount_t on mempolicy->refcnt
has been added to the -mm tree.  Its filename is
     mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Subject: mm/mempolicy: convert from atomic_t to refcount_t on mempolicy->refcnt

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Link: https://lkml.kernel.org/r/1626683671-64407-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    5 +++--
 mm/mempolicy.c            |    8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt
+++ a/include/linux/mempolicy.h
@@ -6,6 +6,7 @@
 #ifndef _LINUX_MEMPOLICY_H
 #define _LINUX_MEMPOLICY_H 1
 
+#include <linux/refcount.h>
 #include <linux/sched.h>
 #include <linux/mmzone.h>
 #include <linux/dax.h>
@@ -43,7 +44,7 @@ struct mm_struct;
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
@@ -293,7 +293,7 @@ static struct mempolicy *mpol_new(unsign
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
-	atomic_set(&policy->refcnt, 1);
+	refcount_set(&policy->refcnt, 1);
 	policy->mode = mode;
 	policy->flags = flags;
 
@@ -303,7 +303,7 @@ static struct mempolicy *mpol_new(unsign
 /* Slow path of a mpol destructor. */
 void __mpol_put(struct mempolicy *p)
 {
-	if (!atomic_dec_and_test(&p->refcnt))
+	if (!refcount_dec_and_test(&p->refcnt))
 		return;
 	kmem_cache_free(policy_cache, p);
 }
@@ -2324,7 +2324,7 @@ struct mempolicy *__mpol_dup(struct memp
 		nodemask_t mems = cpuset_mems_allowed(current);
 		mpol_rebind_policy(new, &mems);
 	}
-	atomic_set(&new->refcnt, 1);
+	refcount_set(&new->refcnt, 1);
 	return new;
 }
 
@@ -2619,7 +2619,7 @@ restart:
 					goto alloc_new;
 
 				*mpol_new = *n->policy;
-				atomic_set(&mpol_new->refcnt, 1);
+				refcount_set(&mpol_new->refcnt, 1);
 				sp_node_init(n_new, end, n->end, mpol_new);
 				n->end = start;
 				sp_insert(sp, n_new);
_

Patches currently in -mm which might be from xiyuyang19@fudan.edu.cn are

mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch

