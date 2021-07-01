Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53418C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AAED61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhGAA5c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAA5c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0401C6146D;
        Thu,  1 Jul 2021 00:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100902;
        bh=+fCAFOQe7rE2nSRKj2syMuS4l8Pn8GTYFBgJEv/Tszk=;
        h=Date:From:To:Subject:From;
        b=tHMS57Bi2KTPdIwZXY9exsamKWSRD4MagS/zoCO8Ls4skR7ImDCtUsRsf8QrQPWs8
         WrkLU7Hedk//dlftXEwBec8JBAS14Svm4jGi8G3FhCKXpX4r4o9esoZ+IyiGLIaqab
         ZQt9c/j9NNhfxtN/ZGMxyZdwfBQyQp2xVJVw5/jc=
Date:   Wed, 30 Jun 2021 17:55:01 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-mempolicy-dont-handle-mpol=5Flocal-like-a-fake-mpol=5Fp?=
 =?US-ASCII?Q?referred-policy-v4.patch?= removed from -mm tree
Message-ID: <20210701005501.rixdgSq1x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4.patch

This patch was dropped because it was folded into mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch

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
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4.patch

