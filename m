Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF41D1547C0
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934652; cv=none; b=jA8eNlVwcr2ZDozNremXKte76PgxLUaQUsSjSPp4Or/AKnz6KC25ltsyUGZM/vi3e80AmJRJlRynEhtj8HaBYceO3CqLkMqJdM3eGYMl4G5cH7aqgzdOi2ehkZfwZjEr73mIAFM+mUyE1ko4aOQy+8lyWsZiBZ0B9h/2zN39sRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934652; c=relaxed/simple;
	bh=nt1L3cVpqvieX4kAiTywGEBIIK2NsQi0VKEpbE9AOIs=;
	h=Date:To:From:Subject:Message-Id; b=ab8Bpqkl3+Fye1YiaMAdo01pxfTVMFjc6v3yR7jV7rB6a4Ezl6Qg8Ivdy9H/MuvlrZmAxJNVWu4643bsXE5ue/KV9eD6olpNlgfWwjKmXw8H7H1rrVz3VPA1T9b763N/OLzwNczWYNZSNlZ4MNfB8scl/IKEpjdE8K19wlJ/9oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d2AuxwgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d2AuxwgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFD6C4CEE4;
	Sun, 11 May 2025 03:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934651;
	bh=nt1L3cVpqvieX4kAiTywGEBIIK2NsQi0VKEpbE9AOIs=;
	h=Date:To:From:Subject:From;
	b=d2AuxwgBfy51kO7Ub4cotvPYhkGPxr0bnlv3idZ3YGjpzlbC1YOhn5IXD6mFG1SBY
	 z6GJYHZzIe2D/bMN3TFitIz+xzWsCJaNojj+UiKw4/KefydXyibX+Bc4/zv28KW/jo
	 /nkVm7JHp2xXbaTFahYQ70TJeDXJiiovMR99BRZk=
Date: Sat, 10 May 2025 20:37:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,linmiaohe@huawei.com,gshan@redhat.com,gehao@kylinos.cn,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch removed from -mm tree
Message-Id: <20250511033731.5BFD6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix
has been removed from the -mm tree.  Its filename was
     mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch

This patch was dropped because it was folded into mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix
Date: Sun Apr  6 10:06:36 PM PDT 2025

simplify __dump_folio(), per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: gehao <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/debug.c~mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix
+++ a/mm/debug.c
@@ -74,7 +74,9 @@ static void __dump_folio(struct folio *f
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 	char *type = "";
 
-	mapcount = page_mapcount_is_type(mapcount) ? 0 : mapcount;
+	if (page_mapcount_is_type(mapcount))
+		mapcount = 0;
+
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
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

