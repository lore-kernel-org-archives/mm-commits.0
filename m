Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856BC1537DE
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 23:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723763186; cv=none; b=TA2RX4EYiGmQiD79Xbxs4WcG9THJC4kGFryZ6k4xnV0XuzX2ZaDYY8F0g8FAte8JaSTXK8r9LkO9pO2PbjffXuReerl9bvhIwIZvXJkIbyAkMIkRv/JX2RXBXakdJ6Xe7SnQOXEUSlfVF2MUm5A0C5ef17ekrfZUJ197jATqJ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723763186; c=relaxed/simple;
	bh=jGbkntmKnYFxA/7TNR1lG2GzVWxAbkf98CBcRbzimc4=;
	h=Date:To:From:Subject:Message-Id; b=cxtuGxp5OHjVwE40tYP39aerM6YgAMYnALeqlApSRTNrGDdzkRR388oHVrD/Ykskebs9K5rklQRKlQ4WlHutWDyZea4BVAfsdfBKJuqctTCTvBeAZQcpMsdfIzvPpiTKraZB8JbmAjCe1W3Sv3C2DxrNcmMv2C30kFCttfivfdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fj4keSmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fj4keSmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06658C32786;
	Thu, 15 Aug 2024 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723763186;
	bh=jGbkntmKnYFxA/7TNR1lG2GzVWxAbkf98CBcRbzimc4=;
	h=Date:To:From:Subject:From;
	b=Fj4keSmc3LHF+jtbMgdOAtlIMaVBdVI5vutbayQInWClf5lWZwdcQQR1Xlpufsr8n
	 EnJP3UkfKA5Xv3STQSsYbIGbAorwQlB0F67Qj14Pv3Up/vi5vmf5bd3XtF5h0kgWEa
	 58DH29IEerNoQw1yZzPZxy2yYyi2mETaubAV6tdM=
Date: Thu, 15 Aug 2024 16:06:25 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch added to mm-unstable branch
Message-Id: <20240815230626.06658C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch

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
From: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Subject: mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4
Date: Wed, 14 Aug 2024 23:51:22 +0000

added documentation of the memcg counters in cgroup-v2.rst

Link: https://lkml.kernel.org/r/20240814235122.252309-1-kaiyang2@cs.cmu.edu
Signed-off-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1617,6 +1617,25 @@ The following nested keys are defined.
 		Usually because failed to allocate some continuous swap space
 		for the huge page.
 
+	  numa_pages_migrated (npn)
+		Number of pages migrated by NUMA balancing.
+
+	  numa_pte_updates (npn)
+		Number of pages whose page table entries are modified by
+		NUMA balancing to produce NUMA hinting faults on access.
+
+	  numa_hint_faults (npn)
+		Number of NUMA hinting faults.
+
+	  pgdemote_kswapd
+		Number of pages demoted by kswapd.
+
+	  pgdemote_direct
+		Number of pages demoted directly.
+
+	  pgdemote_khugepaged
+		Number of pages demoted by khugepaged.
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.
 
_

Patches currently in -mm which might be from kaiyang2@cs.cmu.edu are

mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch
mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch
mm-print-the-promo-watermark-in-zoneinfo.patch
mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch
mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch

