Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33745FBA4
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 22:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710885639; cv=none; b=hbJvUfnmMMMAR119Z3mVfZQKkCnYYo6krgfA+QYgA3vLWWq/WpWGV6t7M90nYPhnPaYvipYteo8HNCNzzSXRpbEhvJt4XnqCfpHU2ehgcJqu+cm4GGDYgUehH5Tk9p3bG2ORb2macSiucBfo+930dLfr8/frus95+R1jFgv2w34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710885639; c=relaxed/simple;
	bh=M0tapZ4wUTqAjPFCCVOjWVwHEwbnCbYtB+tTa9VomzU=;
	h=Date:To:From:Subject:Message-Id; b=OIHuf9qepFwvgI6yNYUwkXABSirM8nrELxzFWR4Vyyrhw48fq74KYOnIdR2gXy5UKpzQXql/G4eXeS7A0qr1HjdhFKWBP0kddg2k9TVscZsdDDt4YO4C3ioJYRWHo74jnD/UeMf1DFPC4W8gq/pN4ntS7GF7W34GB2CjedmMwRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QD++7W3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QD++7W3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC65C43394;
	Tue, 19 Mar 2024 22:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710885639;
	bh=M0tapZ4wUTqAjPFCCVOjWVwHEwbnCbYtB+tTa9VomzU=;
	h=Date:To:From:Subject:From;
	b=QD++7W3D70l3JX5sWO5cz7C8mzoZJpok2FsmTTHLYygiVDpW5XGPf/PuRqxqLgBIK
	 lsXdF6npTguyDWUaXKCHL9JX42iy4tnj9pw/5mi5GyI75l4gBEYQY1qylX7lEECQso
	 Tl1ei7fOX69ZcuC5BaH63NLmlVm+GZFR3U+HD608=
Date: Tue, 19 Mar 2024 15:00:38 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,hughd@google.com,hannes@cmpxchg.org,feng.tang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,aneesh.kumar@kernel.org,aarcange@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch added to mm-unstable branch
Message-Id: <20240319220039.2FC65C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/numa_balancing: allow migrate on protnone reference with MPOL_PREFERRED_MANY policy
has been added to the -mm mm-unstable branch.  Its filename is
     mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/numa_balancing: allow migrate on protnone reference with MPOL_PREFERRED_MANY policy
Date: Fri, 8 Mar 2024 09:15:38 -0600

commit bda420b98505 ("numa balancing: migrate on fault among multiple
bound nodes") added support for migrate on protnone reference with
MPOL_BIND memory policy.  This allowed numa fault migration when the
executing node is part of the policy mask for MPOL_BIND.  This patch
extends migration support to MPOL_PREFERRED_MANY policy.

Currently, we cannot specify MPOL_PREFERRED_MANY with the mempolicy flag
MPOL_F_NUMA_BALANCING.  This causes issues when we want to use
NUMA_BALANCING_MEMORY_TIERING.  To effectively use the slow memory tier,
the kernel should not allocate pages from the slower memory tier via
allocation control zonelist fallback.  Instead, we should move cold pages
from the faster memory node via memory demotion.  For a page allocation,
kswapd is only woken up after we try to allocate pages from all nodes in
the allocation zone list.  This implies that, without using memory
policies, we will end up allocating hot pages in the slower memory tier.

MPOL_PREFERRED_MANY was added by commit b27abaccf8e8 ("mm/mempolicy: add
MPOL_PREFERRED_MANY for multiple preferred nodes") to allow better
allocation control when we have memory tiers in the system.  With
MPOL_PREFERRED_MANY, the user can use a policy node mask consisting only
of faster memory nodes.  When we fail to allocate pages from the faster
memory node, kswapd would be woken up, allowing demotion of cold pages to
slower memory nodes.

With the current kernel, such usage of memory policies implies we can't do
page promotion from a slower memory tier to a faster memory tier using
numa fault.  This patch fixes this issue.

For MPOL_PREFERRED_MANY, if the executing node is in the policy node mask,
we allow numa migration to the executing nodes.  If the executing node is
not in the policy node mask, we do not allow numa migration.

Link: https://lkml.kernel.org/r/369d6a58758396335fd1176d97bbca4e7730d75a.1709909210.git.donettom@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/mempolicy.c~mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy
+++ a/mm/mempolicy.c
@@ -1504,9 +1504,10 @@ static inline int sanitize_mpol_flags(in
 	if ((*flags & MPOL_F_STATIC_NODES) && (*flags & MPOL_F_RELATIVE_NODES))
 		return -EINVAL;
 	if (*flags & MPOL_F_NUMA_BALANCING) {
-		if (*mode != MPOL_BIND)
+		if (*mode == MPOL_BIND || *mode == MPOL_PREFERRED_MANY)
+			*flags |= (MPOL_F_MOF | MPOL_F_MORON);
+		else
 			return -EINVAL;
-		*flags |= (MPOL_F_MOF | MPOL_F_MORON);
 	}
 	return 0;
 }
@@ -2770,15 +2771,26 @@ int mpol_misplaced(struct folio *folio,
 		break;
 
 	case MPOL_BIND:
-		/* Optimize placement among multiple nodes via NUMA balancing */
+	case MPOL_PREFERRED_MANY:
+		/*
+		 * Even though MPOL_PREFERRED_MANY can allocate pages outside
+		 * policy nodemask we don't allow numa migration to nodes
+		 * outside policy nodemask for now. This is done so that if we
+		 * want demotion to slow memory to happen, before allocating
+		 * from some DRAM node say 'x', we will end up using a
+		 * MPOL_PREFERRED_MANY mask excluding node 'x'. In such scenario
+		 * we should not promote to node 'x' from slow memory node.
+		 */
 		if (pol->flags & MPOL_F_MORON) {
+			/*
+			 * Optimize placement among multiple nodes
+			 * via NUMA balancing
+			 */
 			if (node_isset(thisnid, pol->nodes))
 				break;
 			goto out;
 		}
-		fallthrough;
 
-	case MPOL_PREFERRED_MANY:
 		/*
 		 * use current page if in policy nodemask,
 		 * else select nearest allowed node, if any.
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch
mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

