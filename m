Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6542117BB6
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934710; cv=none; b=r3hjNCYgjLc5OvTDwSMbhRM7ovJUbjogaqS+5eMXcaDa64TYGiF3iWDPKXBPs1Gz95eBNLXZal96mTLtNmr1uUOBUKjCgP2BVvqxn328xqNuUvIQdrOsb45ZZdsm0swGZ+gWJCUurj8EB5NiuXsLoAKBHPbDAxvJqfb/lplz/Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934710; c=relaxed/simple;
	bh=QLUQ8LBOVQTAfivdPfUBE2ucjMF2mdLyfk6L6++kZOU=;
	h=Date:To:From:Subject:Message-Id; b=QeGJSmPr3m1mm3WJYM3I9EFcvYRK8wf6H7YjNKO0zxZgpGdEXcr2Tg6ZW/qWGtVvn1zZ0Z1l+fT2ELIJUCzgtvOyxVVtlUxLzBeIGsBRwMLEn3E3+7g5Nsn++M7KNd73kim/3MaknvtZ6HSxZu3COjy8IRSIK7OHDva04SHbGoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kR0BssfF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kR0BssfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CF4C4CEE4;
	Sun, 11 May 2025 03:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934709;
	bh=QLUQ8LBOVQTAfivdPfUBE2ucjMF2mdLyfk6L6++kZOU=;
	h=Date:To:From:Subject:From;
	b=kR0BssfFtjRxi/WX+Ir4GgG0TFFRwsvre4s0Vyv9sNxEKZeKFdzn8KDcsWZtpMetq
	 9V4PUP3I4WePbvFN0Vmx0m+1/jZdhzKC6hCvXOxut/Samm0KnJQY6rmhq+i6N8Z9kn
	 ZbzQFlCd3kfHYFuZI8LSTCngbdjx9chtQUv7PB8U=
Date: Sat, 10 May 2025 20:38:29 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,lkp@intel.com,hch@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] vmalloc-switch-to-for_each_vmap_node-helper-fix.patch removed from -mm tree
Message-Id: <20250511033829.86CF4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc-switch-to-for_each_vmap_node-helper-fix
has been removed from the -mm tree.  Its filename was
     vmalloc-switch-to-for_each_vmap_node-helper-fix.patch

This patch was dropped because it was folded into vmalloc-switch-to-for_each_vmap_node-helper.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmalloc-switch-to-for_each_vmap_node-helper-fix
Date: Wed Apr  9 05:30:24 PM PDT 2025

fix build warning

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504100130.OjlBJLkQ-lkp@intel.com/
Cc: Christop Hellwig <hch@infradead.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~vmalloc-switch-to-for_each_vmap_node-helper-fix
+++ a/mm/vmalloc.c
@@ -5101,7 +5101,7 @@ static void __init vmap_init_free_space(
 static void vmap_init_nodes(void)
 {
 	struct vmap_node *vn;
-	int i, n;
+	int i;
 
 #if BITS_PER_LONG == 64
 	/*
@@ -5118,7 +5118,7 @@ static void vmap_init_nodes(void)
 	 * set of cores. Therefore a per-domain purging is supposed to
 	 * be added as well as a per-domain balancing.
 	 */
-	n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
+	int n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
 
 	if (n > 1) {
 		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT | __GFP_NOWARN);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vmalloc-switch-to-for_each_vmap_node-helper.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

