Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D4333D5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422147; cv=none; b=k2NVSAm7AoKPN8PoRp0/35dHU1WsG+PsgB/lGTe4NbeSPqc82YOqbfoOPjzbfTLEB5O5zkOy6wiOw4uc8eeUqXSU3iKQtdXKsIZRwKoHpt+I5RD3wTtaiTL8ZrgpQNawNbpIucITcmrFEwfeumepXALSOKj2RORqPJ7YRTRUW5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422147; c=relaxed/simple;
	bh=VtKoBOr9dnCrlViTXPuLB0NbKPacL/GEl4f17Ek76L0=;
	h=Date:To:From:Subject:Message-Id; b=AG/R1sBqmrpIh5U1cFElXKyBIb3/BBiVfEAkN+ewNc5WiMrdfWyjDWS5IK/9wdvyM6i9+JXwoVA5WpzDWJZDz/NzoTY+kHNKznDeFGNbNy6yozaD2ot/9P2NMATWGtGm47xYNunLwgahXhjn+Xzxw59O0zvBW/HZrVRqIQ7A/Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u6L9voBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u6L9voBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ED2C4CEC2;
	Wed,  4 Sep 2024 03:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422147;
	bh=VtKoBOr9dnCrlViTXPuLB0NbKPacL/GEl4f17Ek76L0=;
	h=Date:To:From:Subject:From;
	b=u6L9voBHLkj40fm2AUKlkx3GTlm565cSyM6bqIGzyDqoDKHZkCEo8L0/m05VhUe35
	 mCTbA/tisTRtPQCpw3Ws+428sLLz+3vItIVM+dnXg20yEcgzzDl4D8+DdCVA/85u77
	 qmm2gnKLA+FLPplj7Wtz5d6gFX2tFytoLmWaqhz4=
Date: Tue, 03 Sep 2024 20:55:46 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch removed from -mm tree
Message-Id: <20240904035546.F1ED2C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4
has been removed from the -mm tree.  Its filename was
     mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch

This patch was dropped because it was folded into mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch

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

mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch

