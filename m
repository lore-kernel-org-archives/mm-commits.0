Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A67A1DC721
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 19:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725393079; cv=none; b=arJwntg2M+mDzceoeUISQGOhVQWwtpxu1qvRRP7aCS2/8QiY2TZppk4fdwfXPG9WAuaacSsKpeglxbK4mu8bAod4QE3ACy2nLLBvIa99OsCyn/PQni5W+xKcKvHl7vwJR6nKnFcCcO4Eu8d9LL+pjalT2O03uzsGm+b51lmdZQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725393079; c=relaxed/simple;
	bh=RLliXEerzfUSmeN54+V3EYRvrV8CFhfZrv0wMRTWflU=;
	h=Date:To:From:Subject:Message-Id; b=eUr2UhiXUMpyc6clTmJjRhD9y0JVKOcX9xa06KlZfl07+RNnKirr3UYO0S8h/5/KhX82uSVNyBkJHg92hu7XAbH3sgaNxhkJAqeTfIT/Zwvbmr4za/yiA1/+g+P8ArWpt4YA4U6VubrMNnaE/7V5UxSIicBu40JEve8MS0DSo50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1QZ9p+yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1QZ9p+yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BF0C4CEC4;
	Tue,  3 Sep 2024 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725393079;
	bh=RLliXEerzfUSmeN54+V3EYRvrV8CFhfZrv0wMRTWflU=;
	h=Date:To:From:Subject:From;
	b=1QZ9p+yoD8GFWuv1srFoHCUgaUbK8/SMwwhjrjO1sr68F7dvMq0QvXv2wwXsBAWIV
	 cMx+CZSCyfKEIypwIPvDNQZIEx4EDsd+ExLBf+sZhW5n4oNVRJcb+CNygRTJGNcYTn
	 VUvHcKH2cPUFcRHbxXvW3YH/sqkLzWyhn7p2ULoY=
Date: Tue, 03 Sep 2024 12:51:18 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] lib-maple_treec-remove-unused-functions.patch removed from -mm tree
Message-Id: <20240903195119.11BF0C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/maple_tree.c: remove unused functions
has been removed from the -mm tree.  Its filename was
     lib-maple_treec-remove-unused-functions.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/maple_tree.c: remove unused functions
Date: Fri Aug 30 05:46:21 PM PDT 2024

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408310728.S7EE59BN-lkp@intel.com/
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/lib/maple_tree.c~lib-maple_treec-remove-unused-functions
+++ a/lib/maple_tree.c
@@ -348,21 +348,6 @@ static inline void *mte_safe_root(const
 	return (void *)((unsigned long)node & ~MAPLE_ROOT_NODE);
 }
 
-static inline void *mte_set_full(const struct maple_enode *node)
-{
-	return (void *)((unsigned long)node & ~MAPLE_ENODE_NULL);
-}
-
-static inline void *mte_clear_full(const struct maple_enode *node)
-{
-	return (void *)((unsigned long)node | MAPLE_ENODE_NULL);
-}
-
-static inline bool mte_has_null(const struct maple_enode *node)
-{
-	return (unsigned long)node & MAPLE_ENODE_NULL;
-}
-
 static __always_inline bool ma_is_root(struct maple_node *node)
 {
 	return ((unsigned long)node->parent & MA_ROOT_PARENT);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch

