Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9843BBA38
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 00:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599775; cv=none; b=jwCOLPknRCWYRE+miMfZYtx3O83z0wr21YnB91bHmMZ1VoErFs2L1L+oC4p4aupd0gO2a2hQWRtEFKtjgn71nqf1F2lZqK7Ixr3MCT1J2fMCN7SiOE2GJPkPEmh4PLQ+xm3xQUT6ilf1Go8j1DS+ElMhYP/7RHEidATYQwhv06Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599775; c=relaxed/simple;
	bh=ULXSOmGisiIe9yTYm27gB2o8JDU4tT2N1bd8U32Vsak=;
	h=Date:To:From:Subject:Message-Id; b=krNrWxN1a2QPQOCFsnJBd/ZUjHFeZxEY8AY7o3+TGzNhZCbWs8tP9kXoT6bOwj175vkJNT0eTdWJaKbD7pZCQYqLjXWXXSQgjubm9KIqVP6JNTGvXrkLmd1fAdfDrAZb4j0c1TGpKwYRXYOtQw4WQLOD9L7sfgsFuYdZmoiZoeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xlnmfDud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xlnmfDud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58E5C433C7;
	Tue,  5 Mar 2024 00:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709599775;
	bh=ULXSOmGisiIe9yTYm27gB2o8JDU4tT2N1bd8U32Vsak=;
	h=Date:To:From:Subject:From;
	b=xlnmfDudqbQZRudODZ3HHN9jPeXh2zb5SGnB2oGEKhaW71prqyR9i8HYHJr4sZB2u
	 x1w8EIgUUe30png2p3MBeNDyG2+oPGc0OJ0QwD/woRHNLKuNO7aHABGsHN2hL58b1Z
	 K4tqGcrSZTLKBw/jWer3sOp1pdBbGmC2VhWN516A=
Date: Mon, 04 Mar 2024 16:49:34 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mike.kravetz@oracle.com,mhocko@kernel.org,mgorman@suse.de,hughd@google.com,hannes@cmpxchg.org,feng.tang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,ben.widawsky@intel.com,aneesh.kumar@kernel.org,aarcange@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch removed from -mm tree
Message-Id: <20240305004934.E58E5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: avoid the fallthrough with MPOLD_BIND in mpol_misplaced.
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/mempolicy: avoid the fallthrough with MPOLD_BIND in mpol_misplaced.
Date: Sat, 17 Feb 2024 01:31:34 -0600

We will update MPOL_PREFERRED_MANY in the follow up patch. This change
is required for that.  In this patch there are no functional changes.

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

mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

