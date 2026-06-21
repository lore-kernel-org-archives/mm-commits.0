Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D3C370AD7
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067225; cv=none; b=BVT3L5D3hL/zWb1nIUKoaL7sH6QPPcnN6hhFU7Nm9bsy9yC25frLGkEUHB4zezpUkt24Mqr4ahl2jXk93RXlq/MSdTjOCxuKiC4oVQedvyehG9TfyxEPVD4HQ0hth4FvtvmBCfUH/Wy+xQN0OUmOJ+GWzfO+KUictnGLpFG6rPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067225; c=relaxed/simple;
	bh=yIhQHoFyydYqPiJE8s6dQk+HDEWkFj4CvFXLKCmqzvA=;
	h=Date:To:From:Subject:Message-Id; b=G6wxXVr/MRibYS3cSBO4kgNyKaBScOJ04ZrdtLwshBNDcmrlPeFemyj1973N1FLZZCiSgkKoaajCNUGWilLNe0O4+c15GxivuucN/4BYOSkd36KORudVpP4cqpHLco4MMCt+ilFnV9LwPo5p5NAEfjldIPUMSMGp8/5852JLeeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r8C1dWJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r8C1dWJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F6A1F00A3A;
	Sun, 21 Jun 2026 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067224;
	bh=aRmS2cRCAhKQz0/9R/cp7e9SgfFPyhE9BkrQseFIIgM=;
	h=Date:To:From:Subject;
	b=r8C1dWJUeXh7O/T0HjfOrIlH60S1qImxkcRBz8dZC/dU88uBo/YlARF2GiLdkpCA6
	 mvAVR1lh7ECK29c6YoQEmP1ReUdBOJYYVn5gzc/nUH8405iQUy3Rz2pWlUB3iskpby
	 1kEpwtGtO8C6SlnRB4VKVBtSK+cNwNdxseD4vgUE=
Date: Sun, 21 Jun 2026 11:40:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,huangsj@hygon.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-mapping_mapped-to-simplify-the-code.patch removed from -mm tree
Message-Id: <20260621184024.36F6A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use mapping_mapped to simplify the code
has been removed from the -mm tree.  Its filename was
     mm-use-mapping_mapped-to-simplify-the-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Shijie <huangsj@hygon.cn>
Subject: mm: use mapping_mapped to simplify the code
Date: Fri, 12 Jun 2026 15:30:32 +0800

Use mapping_mapped() to simplify the code, make the code tidy and clean.

Link: https://lore.kernel.org/20260612073032.33228-1-huangsj@hygon.cn
Signed-off-by: Huang Shijie <huangsj@hygon.cn>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 mm/memory.c          |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-use-mapping_mapped-to-simplify-the-code
+++ a/fs/hugetlbfs/inode.c
@@ -614,7 +614,7 @@ static void hugetlb_vmtruncate(struct in
 
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
-	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+	if (mapping_mapped(mapping))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
@@ -675,7 +675,7 @@ static long hugetlbfs_punch_hole(struct
 
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
-		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+		if (mapping_mapped(mapping))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
--- a/mm/memory.c~mm-use-mapping_mapped-to-simplify-the-code
+++ a/mm/memory.c
@@ -4386,7 +4386,7 @@ void unmap_mapping_folio(struct folio *f
 	details.zap_flags = ZAP_FLAG_DROP_MARKER;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
@@ -4416,7 +4416,7 @@ void unmap_mapping_pages(struct address_
 		last_index = ULONG_MAX;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
_

Patches currently in -mm which might be from huangsj@hygon.cn are


