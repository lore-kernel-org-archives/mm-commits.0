Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622586;
	b=QD8HhfKKYTWzZ6KYv+xpxmy3DApCSnJ9aDCD5cV3Yfc1vKnV5S99WmOyXqM9yagA4p3L
	 glqdb5Me5gCi2QMxZ+7QArOSTA4coFwcwwrXbfZ1AmsPk+T6U1rA51RwdPul40b0loNwf
	 Zo0P2bHyptPCURBp5/vM+bjtF5P/opCHDBXX0gn8CH9DFZDTxYd/AH3pKs0E44znK3PBD
	 GdDVhcIplZCfd/ZQuGNdAZqHKSJxNA6l7UIGxLO+9i8+baZU4otnBaxECtcLLRVv8ifA7
	 thFzwVAMD/7kjr30/Q9UMcIzOxyaJmV5VDqVDsdBOaKBOn3AysNnCiXhpiDsjaxGOVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622586;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uUE886HqipF7URm9HKSwpdzrI6Wwulj99MIUWI+75zQ=;
	b=pBGLxiKAifF+oNhG2AX9b69qlnoMh4aL9rpZ22pM98wtTVBCNR/z3r5abvM0QPuC8zI2
	 XTZXpgqS9MkuFujxXFOz2GGsJ1lfKNB7eOEZRsbkh/CdOmTvqFzQRKC9V7saSPM1J92aK
	 vVK/M0W6i+HMLRXTp4j55wpywHEiqMnuQWpOkdw+auCnhmLOSCtLBJB+bMTYpdRrt7Dvb
	 vh5hL2bNAUV3Nhpuy6YbzSBqW5BaUhYMED3uVWbu6JTxRzdvoQtxRI6Mxvh6TTfPnUTub
	 Dv6XZBeSegSX2xiyu8YZMNGGPzBhS1PtIkO+0/Gkcwb814HrxTEYYF+z35typ8IJmPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zgP8TCbl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37A8606A329
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 02:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zgP8TCbl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5441F000C4;
	Sat, 14 Nov 2026 02:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794622586;
	bh=uUE886HqipF7URm9HKSwpdzrI6Wwulj99MIUWI+75zQ=;
	h=Date:To:From:Subject;
	b=zgP8TCblG+8fAlT3gn84Bgb/0t5T7JVSEGWz4TFjoPvyim47oJc0u4npKm9AlhYL2
	 ECQ4F4qOnqeAy/i+dGKk3S26QHJN6/jxpYUAqh0dNsuPLd5Y3FOx8P7SBDfBczaqdB
	 AEFxEL4j0MgwzZG0Hu/wCUVEwvbS+fmiTnQPCJtg=
Date: Fri, 13 Nov 2026 18:16:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	sj@kernel.org,rakie.kim@sk.com,joshua.hahnjy@gmail.com,david@kernel.org,
	gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-ignore-a-bind-policy-whose-nodes-have-no-memory.patch added to mm-new branch
Message-Id: <20261114021626.2A5441F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mempolicy: ignore a bind policy whose nodes have no memory
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-ignore-a-bind-policy-whose-nodes-have-no-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-ignore-a-bind-policy-whose-nodes-have-no-memory.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: mm/mempolicy: ignore a bind policy whose nodes have no memory
Date: Fri, 13 Nov 2026 14:26:42 -0500

apply_policy_zone() assumes that policy->nodes intersects N_MEMORY, so
it reads a bind policy with no N_HIGH_MEMORY node as movable-only.

On systems with CONFIG_CPUSETS=n, nothing rebinds policies when memory
is removed, so offlining all memory on the nodes a bind policy names
leaves it with none. The policy is then treated as movable-only, and
movable allocations are restricted to nodes without memory.

This results in allocations failures, a VM_FAULT_OOM leak, and then
an infinitely retrying fault that hangs the process.

  page allocation failure: order:0, mode:0x140dca ... nodemask=2
  Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF

Ignore a bind policy whose nodes have no memory. policy_nodemask()
already ignores a bind policy that does not intersect the cpuset.
This covers hugetlb's policy_mbind_nodemask() as well.

If the nodes regain memory, the policy applies again.

CPUSETS=n with HOTREMOVE=y is unlikely a common configuration, so this
isn't marked for stable.

Link: https://lore.kernel.org/20261113192642.2618878-1-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
---

 mm/mempolicy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mempolicy.c~mm-mempolicy-ignore-a-bind-policy-whose-nodes-have-no-memory
+++ a/mm/mempolicy.c
@@ -2100,6 +2100,10 @@ bool apply_policy_zone(struct mempolicy
 
 	BUG_ON(dynamic_policy_zone == ZONE_MOVABLE);
 
+	/* Memory hot-remove can leave policy->nodes without memory. */
+	if (!nodes_intersects(policy->nodes, node_states[N_MEMORY]))
+		return false;
+
 	/*
 	 * if policy->nodes has movable memory only,
 	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch
mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch
selftests-mm-add-madv_cold-and-madv_pageout-contract-tests.patch
selftests-mm-check-madv_cold-and-madv_pageout-range-handling.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch
selftests-mm-check-madv_pageout-file-permissions.patch
selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch
mm-mempolicy-ignore-a-bind-policy-whose-nodes-have-no-memory.patch
mm-hmm-reject-shadow-stack-mappings.patch

