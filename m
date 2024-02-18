Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78EDEAD7
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708292468; cv=none; b=ImCePAmjtV42Ru2FqW9ucr35PFG78DGIH+Oro5fPaj0SIQ9IkGPcSTQq7CQjv9mBBS2HpSYUYDVI1yPILELcHqDxfSj3+/gqmA7g8KCejpJjOfWbbZe5uwrPE+c8E5Gw9eVY4QcuyFW5VBnK/s+qAukUPGL7/yTV+R6FcnyvQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708292468; c=relaxed/simple;
	bh=f/YYfxrXC5D650+yRLTctm8SRkqzsGZyEg9IpRjP/4A=;
	h=Date:To:From:Subject:Message-Id; b=NSxzDl39yG/xm82lbFRAPwety1RZx1Cnpw5DTI44lqKU7rgF9oneag8PowxKYwSa5zJwXhT4wLeNCoaCyO7Ng3oenQFpDlZLMWNG9OCutq9sNSxjEUxvS82HCpb+kfa2Kn+C6bAi8BWA4sOEMQrw4/ZkR/I5WCk8PbELF9bYqp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UkG4hyb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UkG4hyb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1477FC433F1;
	Sun, 18 Feb 2024 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708292468;
	bh=f/YYfxrXC5D650+yRLTctm8SRkqzsGZyEg9IpRjP/4A=;
	h=Date:To:From:Subject:From;
	b=UkG4hyb5OwgUnQrr8OCVDso3VuNqdKJ0zhHlfVWuaWPZDGdb1eNTLCEatvjmgJdsw
	 oyLxEzLrwJ8O2DeaTPqvTiF5mw2AoV3DPNlw8artkCGNKDjJDDWrZQ7mH9K0hDtE3Q
	 x8d8pEYxD8z1JtS/WmJBckh7kyfMAT9n64d/bJF8=
Date: Sun, 18 Feb 2024 13:41:07 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mike.kravetz@oracle.com,mhocko@kernel.org,mgorman@suse.de,hughd@google.com,hannes@cmpxchg.org,feng.tang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,ben.widawsky@intel.com,aneesh.kumar@kernel.org,aarcange@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-the-already-fetched-local-variable.patch added to mm-unstable branch
Message-Id: <20240218214108.1477FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: use the already fetched local variable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-use-the-already-fetched-local-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-the-already-fetched-local-variable.patch

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

mm-mempolicy-use-the-already-fetched-local-variable.patch
mm-mempolicy-avoid-the-fallthrough-with-mpold_bind-in-mpol_misplaced.patch
mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

