Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABE221ABD7
	for <mm-commits@vger.kernel.org>; Mon, 24 Aug 2026 20:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787602703; cv=none; b=Zr2l1AbDmp7HDOI1m6zD/kYKv+XXkom0joflK6+T9VjbuJupzgf2A8/4hEYPB4765ntW7iPDO4PK15bmxaeBSvUkGKpcs8xce6KebsJb1Ph/Qhm6hyfzUdZ2upjkj48o2hcJFv+LyliSh3cJhi1b2CclwxFIpd11E5uX6UHOnGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787602703; c=relaxed/simple;
	bh=9N0jr8vt9x0iq1pcmAyg7V+Cyyjy7Csj0Of0W/lf2tk=;
	h=Date:To:From:Subject:Message-Id; b=FfRoaGPR5+a3PJC4D0Pa+JQr9H6aYCOuCAXRZp3+TjzoSt9qpmxxobjxyYQ2v9isxe4JShGlJwaQxlHXwgl7wmU/MOHutajzZNGvTU6E2oxQe8Gpa1FTXjg/sNCZ3JhNcJTPg9y4cp9g6sWwl2dPeTllHqGIMkyzvKZOF1ogmrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tRbAp23e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tRbAp23e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72771F000E9;
	Mon, 24 Aug 2026 20:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787602701;
	bh=W5SXKccGV5LXGq6PxUl7tFrg/SpITxQv/k0dOMeschw=;
	h=Date:To:From:Subject;
	b=tRbAp23ezgvSugfNKl2ElJU8T2Mt/TC/t51ePKBJBdv8S/PkvrL+iD7PT+hKBozBi
	 L2qWyRIscg/Hm+dRZmZOeCbzFcJW5BOh4flTZkJEE3sWId3NuqiSGvFtvKxN6rh+h7
	 QIguZD+FTKAJNTgTQ2g4mRk8aRZ1W0TKKuWBuO6Q=
Date: Mon, 24 Aug 2026 13:18:21 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,lkp@intel.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch removed from -mm tree
Message-Id: <20260824201821.A72771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix
has been removed from the -mm tree.  Its filename was
     mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch

This patch was dropped because it was folded into mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix
Date: Tue Aug 11 05:23:28 PM PDT 2026

WARN_ON_ONCE() if the handler didn't set ->locked, per Stanislav

Link: https://lore.kernel.org/anu1N-DOnQwxO1kF@skinsburskii
Cc: David Hildenbrand <david@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix
+++ a/mm/hmm.c
@@ -670,8 +670,10 @@ static int hmm_do_fault(struct mm_struct
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			if (hmm_vma_walk->locked)	/* needed by sparse */
+			if (hmm_vma_walk->locked)    /* needed by sparse */
 				*hmm_vma_walk->locked = false;
+			else
+				WARN_ON_ONCE(1);    /* broken fault handler */
 			return HMM_FAULT_UNLOCKED;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
maple_tree-document-erase-and-allocations-better-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

