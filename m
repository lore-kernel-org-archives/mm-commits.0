Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794696817;
	b=3vxQ1XtwsZTTt6HftNY30fDVu+C96FhifARVMFaNmxikTSwl0BiQRcn/83RCIUzYYPNw
	 ELjpxcLJIaaUyCv/hKPYAVYxfQ/xYksbmcxswRt5GdkYFAy5GxnUaVaolzv7RCwC5/CXR
	 ntLUNA5AXA3hDknX6D02mEBqgdsEdefh6j3xDnkXNn6xzvPaOtQrgsMe10cQlX0PfMHbO
	 2kzLa1Gc3LIXH/CKzzyYs8H1yTijIXLhRjiIyLXBl5/hBxfvv6HMcNwzWr4luxFvpbRW0
	 zT5gu6m8ZJSMaDR9ae/LA+5iVAzAJeELsMbgOcIjgJnT+EvBKR3iyXpWMG7oCU+YRJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794696817;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PbT8vJYDlo+qSlAXu6zcJfjiJY4gNzDyXvfbsy8gX38=;
	b=WSeh+asBOIIuaxw/btosR6aPrPO3p8r4wRqF2KCzavmDl7mWh2a+Fy+4LKZ6A4QQiADc
	 qsB3ftBW5K0DcV7H1+Y+D//Mv0nc8pmdYbasI9Zz3qY5qMJl+xjrHcUf0xWhe5eDCqsgM
	 bvi+yRfp2tH1TK5AP8M5mQ6KBbEeBF/AKiGbZknJQ9U+usBhen7VbPXneYleUA4LfvYrM
	 zAu4NQ0ZnYhq4jCTMBVt0RjOdmVzWzoEhSP04Yjrvqh1bB+mxwJxYIG6+kaSg4e8NLUIk
	 jlEmG47A0xwAbW6wvqV78eaHP8lxTWLti433fJr335yiCnCVrVw8+p+Wt9uR4ORE4lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="CG/vVGzL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C17C606A32E
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CG/vVGzL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AF11F000C5;
	Sat, 14 Nov 2026 22:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794696816;
	bh=PbT8vJYDlo+qSlAXu6zcJfjiJY4gNzDyXvfbsy8gX38=;
	h=Date:To:From:Subject;
	b=CG/vVGzLeco+ITCicgcKmeOwIcaDg3LEVko4+FB9JVgM2XRA0ibqCJ8rulm4lm1l9
	 yQlr2MI/zWTe44r+Gp5O4mAZzGqR0hGQeXsKp3s2WumOw0b2WHbOsOduCGb9n+8x8j
	 ok6J/PC5LEaX5CihyPYgV2xntlvXfbg2oa5LLNdo=
Date: Sat, 14 Nov 2026 14:53:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	sj@kernel.org,rakie.kim@sk.com,joshua.hahnjy@gmail.com,david@kernel.org,
	gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mempolicy-ignore-a-bind-policy-whose-nodes-have-no-memory.patch removed from -mm tree
Message-Id: <20261114225336.98AF11F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mempolicy: ignore a bind policy whose nodes have no memory
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-ignore-a-bind-policy-whose-nodes-have-no-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-hmm-reject-shadow-stack-mappings.patch

