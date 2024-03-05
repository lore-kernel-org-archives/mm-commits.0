Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076A48F5B
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 00:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599774; cv=none; b=tiHUEO7qgwSX+kmOsDb4O50zMQrv/PkHlnEfhUOM9R3PRrnUDKpxvc8CyxVXt6jovpGDXUEl4hLUREXX7yWva2qfYEQ3+9bGovkBoNeu9ZO2t697XTAZZXeTeZBZMsmuwojF71ETvmZGyDAaO2BUouV2aZlItA5xg58N1NhS4fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599774; c=relaxed/simple;
	bh=CKamTjtiCJFmAUeEF8qyzRvOTPzxMZobPzwFA/97iSo=;
	h=Date:To:From:Subject:Message-Id; b=toZEIIC9O9xlDQAcHFpdWjLKJUDY0spSyp45jiLOEebgT471e+9SP8Aa8+H/HMYTEeUv4WPAMiR6ASsAO2slrwdt8lYMmCJ4/2s6nlT09SGyfbU5ahlydwmzZ/YGeoCJFcZ14jhqbuNpVeMRjgxXhPLb5pLmdey9lk0OUAHgCO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QFsBSCHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QFsBSCHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52D5C43390;
	Tue,  5 Mar 2024 00:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709599773;
	bh=CKamTjtiCJFmAUeEF8qyzRvOTPzxMZobPzwFA/97iSo=;
	h=Date:To:From:Subject:From;
	b=QFsBSCHjoIijOJl8yyuGKDWK554xDT5W3DWiPQ4LAfitYETuLq1JWc5XXTQZ63co2
	 UzXSF0Maji/PomvNhbVIQuaQbAC8VFj89ong1uIddSXmGWAqIfCnA9QLiiaYy/7trS
	 UIxBEBXuvjC5jLe6UOaIxJ9Enmvwn97brKWmtM7E=
Date: Mon, 04 Mar 2024 16:49:33 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mike.kravetz@oracle.com,mhocko@kernel.org,mgorman@suse.de,hughd@google.com,hannes@cmpxchg.org,feng.tang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,ben.widawsky@intel.com,aneesh.kumar@kernel.org,aarcange@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-use-the-already-fetched-local-variable.patch removed from -mm tree
Message-Id: <20240305004933.A52D5C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: use the already fetched local variable
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-the-already-fetched-local-variable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/mempolicy: use the already fetched local variable
Date: Sat, 17 Feb 2024 01:31:33 -0600

Avoid doing a per cpu read and use the local variable thisnid. IMHO
this also makes the code more readable.

Link: https://lkml.kernel.org/r/9c3f7b743477560d1c5b12b8c111a584a2cc92ee.1708097962.git.donettom@linux.ibm.com
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

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-the-already-fetched-local-variable
+++ a/mm/mempolicy.c
@@ -2780,7 +2780,7 @@ int mpol_misplaced(struct folio *folio,
 		if (node_isset(curnid, pol->nodes))
 			goto out;
 		z = first_zones_zonelist(
-				node_zonelist(numa_node_id(), GFP_HIGHUSER),
+				node_zonelist(thisnid, GFP_HIGHUSER),
 				gfp_zone(GFP_HIGHUSER),
 				&pol->nodes);
 		polnid = zone_to_nid(z->zone);
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch
mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

