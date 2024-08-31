Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996F42C9D
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 00:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725065623; cv=none; b=W2rU7RcMGhyTYTKtrW91Yw7dAZPcmtb0G9OJk+d1TX9tUa5/dvst8BIeU8ETC7djLU3/WLt3Yccu3zRwGLRMyA/hO4mzlrTJs7iPVHkAhjAgEcHSZrT2IZXfdqAHA2/hK9RwwBOwZkuo4xfHYf06NWzqnsuCV4JxirwrACf2zY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725065623; c=relaxed/simple;
	bh=WnV4RanUr9blT0KOOCoiJC/jFMXc6CuwF/0ahlG3ztM=;
	h=Date:To:From:Subject:Message-Id; b=HeFsAg3TZINQPnExC9yhv5j0XLFlMFnZ6ERDGIwP5H9OmLBEaFJLWvCEJRjg6+CCXSAockCzo0agBWinJR9YsRxGZB3pIDHl8bHYLdWd8fPnIA7vdhCdlxBiLXh5Xd7HYtk+KLhTn8zghfeWfCH0mQfYXFQwxmx5Ni4aL8pFbAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iiSICZBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iiSICZBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E44C4CEC2;
	Sat, 31 Aug 2024 00:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725065623;
	bh=WnV4RanUr9blT0KOOCoiJC/jFMXc6CuwF/0ahlG3ztM=;
	h=Date:To:From:Subject:From;
	b=iiSICZBXxsLZ9mNbpECQoOZDc3xbj/kdCPA32T/rDJbi0wEWqZdyVtUCXsokVaVCW
	 a5IuzOdbSTUUOKlFOojOsKCGG65L+UiLAqjri36AHLZoYKgjaiguzRNQugC6aLZdRy
	 0LvOwG2EK2dn0ZeZYyyLpeAra7R2m0FjQDs6Hulw=
Date: Fri, 30 Aug 2024 17:53:42 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-maple_treec-remove-unused-functions.patch added to mm-unstable branch
Message-Id: <20240831005342.F2E44C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/maple_tree.c: remove unused functions
has been added to the -mm mm-unstable branch.  Its filename is
     lib-maple_treec-remove-unused-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-maple_treec-remove-unused-functions.patch

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

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
lib-maple_treec-remove-unused-functions.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

