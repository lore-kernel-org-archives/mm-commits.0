Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51285C4708F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F308613CE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhFAUfm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 16:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhFAUfk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 16:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECD7D613BD;
        Tue,  1 Jun 2021 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622579638;
        bh=KZu9F0P3Q1STlmXl08IKPqYZ6+7ADXNjWXruy+qV7o4=;
        h=Date:From:To:Subject:From;
        b=jlzkVZ5OUeEsZXyetfGYUOsJ+A3+daZytwmeebRm6S1NE34qNw+bRT2LVPtN2ytW4
         KLufL0vCKLn6gabZ20MsmFCx1rjOn8xURC23aAaksL0x2SNzlECPQSC8dYs3UeNNFL
         iKgXhnphlyO3PiUVe5F4AKaJkWLE7Qp9re+eFP20=
Date:   Tue, 01 Jun 2021 13:33:57 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 =?US-ASCII?Q?mm-mempolicy-dont-handle-mpol=5Flocal-like-a-fake-mpol=5Fp?=
 =?US-ASCII?Q?referred-policy-v4.patch?= added to -mm tree
Message-ID: <20210601203357.DdDteqEMQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4
has been added to the -mm tree.  Its filename is
     mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4

fix a problem in mpol_set_nodemask() (Michal Hocko)

Link: https://lkml.kernel.org/r/1622560492-1294-3-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4
+++ a/mm/mempolicy.c
@@ -213,16 +213,10 @@ static int mpol_new_bind(struct mempolic
 	return 0;
 }
 
-static int mpol_new_local(struct mempolicy *pol, const nodemask_t *nodes)
-{
-	return 0;
-}
-
 /*
  * mpol_set_nodemask is called after mpol_new() to set up the nodemask, if
  * any, for the new policy.  mpol_new() has already validated the nodes
- * parameter with respect to the policy mode and flags.  But, we need to
- * handle an empty nodemask with MPOL_PREFERRED here.
+ * parameter with respect to the policy mode and flags.
  *
  * Must be called holding task's alloc_lock to protect task's mems_allowed
  * and mempolicy.  May also be called holding the mmap_lock for write.
@@ -235,6 +229,10 @@ static int mpol_set_nodemask(struct memp
 	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
 	if (pol == NULL)
 		return 0;
+
+	if (pol->mode == MPOL_LOCAL)
+		return 0;
+
 	/* Check N_MEMORY */
 	nodes_and(nsc->mask1,
 		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
@@ -249,8 +247,7 @@ static int mpol_set_nodemask(struct memp
 	if (mpol_store_user_nodemask(pol))
 		pol->w.user_nodemask = *nodes;
 	else
-		pol->w.cpuset_mems_allowed =
-					cpuset_current_mems_allowed;
+		pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
 
 	ret = mpol_ops[pol->mode].create(pol, &nsc->mask2);
 	return ret;
@@ -406,7 +403,6 @@ static const struct mempolicy_operations
 		.rebind = mpol_rebind_nodemask,
 	},
 	[MPOL_LOCAL] = {
-		.create = mpol_new_local,
 		.rebind = mpol_rebind_default,
 	},
 };
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4.patch

