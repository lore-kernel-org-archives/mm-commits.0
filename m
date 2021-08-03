Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8698DC4338F
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D48D61029
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhHCWAI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 18:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhHCWAH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 18:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA5160724;
        Tue,  3 Aug 2021 21:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628027995;
        bh=cKyWADzVqaEqmNNLfQ8zdasGWkZCRBAziq3zvheIjUI=;
        h=Date:From:To:Subject:From;
        b=YGZ6jjwp8zj9SJh35wjcTxvqKeyflUCS/MpJI4fy9heSNVox9Deu81dOyhcX6OJFt
         2eu4Ab0mApV9EU7l8SLZH9TDzuUG7/EiIttt9b0nBGEUitoBZMhqlW15N8sxK+7HOK
         ypeFNtSQLJWIi4/bMR0+EoV4ZLsBuPHyMn/QM1X4=
Date:   Tue, 03 Aug 2021 14:59:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rientjes@google.com, rdunlap@infradead.org,
        mike.kravetz@oracle.com, mhocko@suse.com, mhocko@kernel.org,
        mgorman@techsingularity.net, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, ben.widawsky@intel.com,
        ak@linux.intel.com, aarcange@redhat.com, feng.tang@intel.com
Subject:  +
 =?us-ascii?Q?mm-mempolicy-unify-the-create-func-for-bind-interleave-pr?=
 =?us-ascii?Q?efer-many-policies.patch?= added to -mm tree
Message-ID: <20210803215954.O-npS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: unify the create() func for bind/interleave/prefer-many policies
has been added to the -mm tree.  Its filename is
     mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch

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
Subject: mm/mempolicy: unify the create() func for bind/interleave/prefer-many policies

As they all do the same thing: sanity check and save nodemask info, create
one mpol_new_nodemask() to reduce redundancy.

Link: https://lkml.kernel.org/r/1627970362-61305-6-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies
+++ a/mm/mempolicy.c
@@ -192,7 +192,7 @@ static void mpol_relative_nodemask(nodem
 	nodes_onto(*ret, tmp, *rel);
 }
 
-static int mpol_new_interleave(struct mempolicy *pol, const nodemask_t *nodes)
+static int mpol_new_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
 {
 	if (nodes_empty(*nodes))
 		return -EINVAL;
@@ -210,22 +210,6 @@ static int mpol_new_preferred(struct mem
 	return 0;
 }
 
-static int mpol_new_preferred_many(struct mempolicy *pol, const nodemask_t *nodes)
-{
-	if (nodes_empty(*nodes))
-		return -EINVAL;
-	pol->nodes = *nodes;
-	return 0;
-}
-
-static int mpol_new_bind(struct mempolicy *pol, const nodemask_t *nodes)
-{
-	if (nodes_empty(*nodes))
-		return -EINVAL;
-	pol->nodes = *nodes;
-	return 0;
-}
-
 /*
  * mpol_set_nodemask is called after mpol_new() to set up the nodemask, if
  * any, for the new policy.  mpol_new() has already validated the nodes
@@ -405,7 +389,7 @@ static const struct mempolicy_operations
 		.rebind = mpol_rebind_default,
 	},
 	[MPOL_INTERLEAVE] = {
-		.create = mpol_new_interleave,
+		.create = mpol_new_nodemask,
 		.rebind = mpol_rebind_nodemask,
 	},
 	[MPOL_PREFERRED] = {
@@ -413,14 +397,14 @@ static const struct mempolicy_operations
 		.rebind = mpol_rebind_preferred,
 	},
 	[MPOL_BIND] = {
-		.create = mpol_new_bind,
+		.create = mpol_new_nodemask,
 		.rebind = mpol_rebind_nodemask,
 	},
 	[MPOL_LOCAL] = {
 		.rebind = mpol_rebind_default,
 	},
 	[MPOL_PREFERRED_MANY] = {
-		.create = mpol_new_preferred_many,
+		.create = mpol_new_nodemask,
 		.rebind = mpol_rebind_preferred,
 	},
 };
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch
mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch

