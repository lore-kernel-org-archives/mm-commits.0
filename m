Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA63EAD7
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708292472; cv=none; b=RRdoeFTmPVQhoOB1znAhoYbG2PAQakeGY3YgoAcxtjxNgHZKJbAW88cm3nccar4DZ2mGTszAoNDvhCku7o9fYa8fyLA1+Hil60OpmbdEn6IffNjHaJAlyE/7qLnl081pXBSW77tOtNNk3xmD2t/B+eB8tD7iWFVjSVd2Yfv8R0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708292472; c=relaxed/simple;
	bh=LO7XRSkxIO3aayQHlyORhvgjc2rZZp+W0GXuVCI0J7M=;
	h=Date:To:From:Subject:Message-Id; b=igwtenTxyOueT7lowvE0UmHwFIbaRx7CxvxibwGq7jsEvnlU8ZA2Enpmu++VM5LclnZ25bD0b3oTg2vsFCaBIz9uW9sTHPpL9kb0nf+xkzhL/YAW3sfXh0gJj2hV/JUfLnxnQLYFN6OMwR8U7J1W/tkcWsUCCSbVBJACPKM24p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i8j138yI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i8j138yI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCDEC433F1;
	Sun, 18 Feb 2024 21:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708292472;
	bh=LO7XRSkxIO3aayQHlyORhvgjc2rZZp+W0GXuVCI0J7M=;
	h=Date:To:From:Subject:From;
	b=i8j138yI7EfTKF9+nhR8sfvGLyR8F26veyw8Qe/IuriM4XNrdv4j6unu7XVsNoUNu
	 Q3ZmZ9w49RG+nGgERCXuLFjIRz5CIX6Vj5r+lYBIEXPxT/S2AwW/J3pDaVMKCJuQ7t
	 NR32CjyoSmvQtyh4M4hyPU30tojTT6JrX2rFi6ss=
Date: Sun, 18 Feb 2024 13:41:11 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mike.kravetz@oracle.com,mhocko@kernel.org,mgorman@suse.de,hughd@google.com,hannes@cmpxchg.org,feng.tang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,ben.widawsky@intel.com,aneesh.kumar@kernel.org,aarcange@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch added to mm-unstable branch
Message-Id: <20240218214112.0BCDEC433F1@smtp.kernel.org>
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
Date: Sat, 17 Feb 2024 01:31:35 -0600

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
not in the policy node mask but the folio is already allocated based on
policy preference (the folio node is in the policy node mask), we don't
allow numa migration.  If both the executing node and folio node are
outside the policy node mask, we allow numa migration to the executing
nodes.

Link: https://lkml.kernel.org/r/8d7737208bd24e754dc7a538a3f7f02de84f1f72.1708097962.git.donettom@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy
+++ a/mm/mempolicy.c
@@ -1503,9 +1503,10 @@ static inline int sanitize_mpol_flags(in
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
@@ -2713,6 +2714,23 @@ static void sp_free(struct sp_node *n)
 	kmem_cache_free(sn_cache, n);
 }
 
+static inline bool mpol_preferred_should_numa_migrate(int exec_node, int folio_node,
+					    struct mempolicy *pol)
+{
+	/* if the executing node is in the policy node mask, migrate */
+	if (node_isset(exec_node, pol->nodes))
+		return true;
+
+	/* If the folio node is in policy node mask, don't migrate */
+	if (node_isset(folio_node, pol->nodes))
+		return false;
+	/*
+	 * both the folio node and executing node are outside the policy nodemask,
+	 * migrate as normal numa fault migration.
+	 */
+	return true;
+}
+
 /**
  * mpol_misplaced - check whether current folio node is valid in policy
  *
@@ -2780,6 +2798,12 @@ int mpol_misplaced(struct folio *folio,
 		break;
 
 	case MPOL_PREFERRED_MANY:
+		if (pol->flags & MPOL_F_MORON) {
+			if (!mpol_preferred_should_numa_migrate(thisnid, curnid, pol))
+				goto out;
+			break;
+		}
+
 		/*
 		 * use current page if in policy nodemask,
 		 * else select nearest allowed node, if any.
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-mempolicy-use-the-already-fetched-local-variable.patch
mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch
mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

