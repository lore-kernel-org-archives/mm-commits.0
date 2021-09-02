Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A63AC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EADCD610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347946AbhIBWBU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347625AbhIBWBT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DF4D60F12;
        Thu,  2 Sep 2021 22:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620020;
        bh=kksn70GdvkV7A6HsZoJ7X5whPZqtp0sX6bbo0Sbo8gI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NMINhaQ4ZUrhbY1yJk6DUSmRztBFdojoHRaWUQJy8By+8dAdjz0QT9cPp2n53FrnM
         H+BD/Nji2MjfMNeHhkQhjfZAKJxxAq8p2I79M8Sye4Zzjvr1kVuHyBAnO1cGOJ6yJh
         gnojeowC1YzM80ngaL7+EbyceUfcM5aUxx/8JwtU=
Date:   Thu, 02 Sep 2021 15:00:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org,
        ben.widawsky@intel.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, feng.tang@intel.com,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        ying.huang@intel.com
Subject:  [patch 195/212] mm/mempolicy: unify the create() func for
 bind/interleave/prefer-many policies
Message-ID: <20210902220019.XFBRVfP5x%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
