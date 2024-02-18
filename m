Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9163EEAD7
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708292470; cv=none; b=ehr4xyYFDNj3CevRijtaAHj3DYFQnexwspD7CS/Y25y5iY2+D+cXK/7wXdVa76gWJZtj+XvfYrvOb99eP14RyUyRMpkn8WRhyfrzv7ocHwutUgUKKDWKUBU/DJ1hqVN8aqrImNriKCX0YzN57MbDZFAPKN8grtuDOI+je0bOOX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708292470; c=relaxed/simple;
	bh=dWBUEArCLUdPclBiCZ5ZnC6/AypifN6Td5geAz1/K88=;
	h=Date:To:From:Subject:Message-Id; b=RxOgrTQ42SEyN0KYWX36zvBPowak1M1HszYqQPd9pcfSiOhc7zu1qL47a4DStnLEO5M2RystuoMgW9ma3aPOCE6tzJAL/pQwzOV6SIlS+jjRrvTzfbk/lJA8StWLOdn+bE4rbyo2nzxtVSxilPXFlrgFk5qVFYr9X3TZIUBanIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kq6sHjl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kq6sHjl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F046C433C7;
	Sun, 18 Feb 2024 21:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708292470;
	bh=dWBUEArCLUdPclBiCZ5ZnC6/AypifN6Td5geAz1/K88=;
	h=Date:To:From:Subject:From;
	b=kq6sHjl8aisnMmervpIYaYXb7nFubq4FmUou/OZcDyJbaTSfErqs/1CV4pBDr2rn7
	 Z4eh4UcxASqXF/uuzNT5cMuugjdqxU+GlhA+/AMRlRYVN7/6ZCy/zpOsSXVG/jp1p/
	 MzE2wr//4s04phiq3p9RXwL6BjSmL92HyStpSS9s=
Date: Sun, 18 Feb 2024 13:41:09 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mike.kravetz@oracle.com,mhocko@kernel.org,mgorman@suse.de,hughd@google.com,hannes@cmpxchg.org,feng.tang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,ben.widawsky@intel.com,aneesh.kumar@kernel.org,aarcange@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch added to mm-unstable branch
Message-Id: <20240218214110.0F046C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: avoid the fallthrough with MPOLD_BIND in mpol_misplaced.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch

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
Subject: mm/mempolicy: avoid the fallthrough with MPOLD_BIND in mpol_misplaced.
Date: Sat, 17 Feb 2024 01:31:34 -0600

We will update MPOL_PREFERRED_MANY in the follow up patch. This change
is required for that.

Link: https://lkml.kernel.org/r/bf7e6779f842fb65cf7bb9b2c617feb2af271cb7.1708097962.git.donettom@linux.ibm.com
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

 mm/mempolicy.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced
+++ a/mm/mempolicy.c
@@ -2769,7 +2769,15 @@ int mpol_misplaced(struct folio *folio,
 				break;
 			goto out;
 		}
-		fallthrough;
+
+		if (node_isset(curnid, pol->nodes))
+			goto out;
+		z = first_zones_zonelist(
+				node_zonelist(thisnid, GFP_HIGHUSER),
+				gfp_zone(GFP_HIGHUSER),
+				&pol->nodes);
+		polnid = zone_to_nid(z->zone);
+		break;
 
 	case MPOL_PREFERRED_MANY:
 		/*
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-mempolicy-use-the-already-fetched-local-variable.patch
mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch
mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

