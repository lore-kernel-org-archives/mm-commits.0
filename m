Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD96C2206E
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 06:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706682980; cv=none; b=J1z5WGNrbaiFzsc8v/yuA1ge5dwrmIu6EW690+CnSPvmR+0sfbxhBUaUNq2g0HO1CMpu9SB59kgVYSIDjAnwGhsSRjoB/fAASF3ktDPUdJvZ+O4HgQlqnFlCXfGNMagysyS/yswOq665dSrGZknn2rX5oWGgoVFPrDGIMKtyYFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706682980; c=relaxed/simple;
	bh=WDoXiKo2rbJrw5g8minztotrVwuEhBF3U3OauDu1htM=;
	h=Date:To:From:Subject:Message-Id; b=URoB4F/g2LDHJQh2TXFcfeMWrbyZ4/xqIGW/vRH1Bgy2aqPhjggSjpexvyqpqrU8XllPmzx/6UVFK/c6CdcZEt/ICY2653Vo6jJrOAscgl2eC4S2Pi5VD2RTKU11rxh1e98sdXnlRN1VdNzzlHPmDG3Hjjs/t2LyDzP1JRsG2XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oFsKUAUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oFsKUAUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95131C433C7;
	Wed, 31 Jan 2024 06:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706682979;
	bh=WDoXiKo2rbJrw5g8minztotrVwuEhBF3U3OauDu1htM=;
	h=Date:To:From:Subject:From;
	b=oFsKUAURlimIiPKmNDOSUPdfQmI+kVs8gIGT0mgN7cV3gB1hlWnBz5XrWArCyTQMs
	 /PvP8V+Z7T8XQWkSBbFwlwGZz5IgwXcQ3QPc901z9CIRDHfcP36YcWp60xPLvNNPF4
	 V552KGmE7+yyl6Yn0NunZX1kEeOef+vhxLxRhrt0=
Date: Tue, 30 Jan 2024 22:36:06 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@suse.com,mhocko@kernel.org,Jonathan.Cameron@huawei.com,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,fvdl@google.com,dan.j.williams@intel.com,corbet@lwn.net,ak@linux.intel.com,gregory.price@memverge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving-fix.patch added to mm-unstable branch
Message-Id: <20240131063618.95131C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving-fix.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving-fix.patch

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
From: Gregory Price <gregory.price@memverge.com>
Subject: mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving-fix.
Date: Wed, 31 Jan 2024 00:12:24 -0500

kill next_node in favor of operating directly on il_prev

Link: https://lkml.kernel.org/r/ZbnWuB4dRCEFRz2m@memverge.com
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hasan Al Maruf <Hasan.Maruf@amd.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving-fix
+++ a/mm/mempolicy.c
@@ -2378,7 +2378,7 @@ static unsigned long alloc_pages_bulk_ar
 	unsigned int weight_total = 0;
 	unsigned long rem_pages = nr_pages;
 	nodemask_t nodes;
-	int nnodes, node, next_node;
+	int nnodes, node;
 	int resume_node = MAX_NUMNODES - 1;
 	u8 resume_weight = 0;
 	int prev_node;
@@ -2408,7 +2408,7 @@ static unsigned long alloc_pages_bulk_ar
 		} else if (rem_pages == weight) {
 			/* move to next node / weight */
 			me->il_prev = next_node_in(node, nodes);
-			me->il_weight = get_il_weight(next_node);
+			me->il_weight = get_il_weight(me->il_prev);
 			return total_allocated;
 		}
 		/* Otherwise we adjust remaining pages, continue from there */
_

Patches currently in -mm which might be from gregory.price@memverge.com are

mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving-fix.patch

