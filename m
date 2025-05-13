Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A29C1EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119351; cv=none; b=RU+W4kCWT1VRV2cUTIMgTn2MNdJasn6HKtb/1HUOJTGG8tCGiAg/QHbUgOY5u5HYsMEVZYos6+q90scw9rQJgqjzCgCfkbC9m/eLvM6ixSPjf3cRQRgUAjMtOO0mcjaKmb8hC6iqXcq57VUO7uDhPTAWMe/8ejRElkf0vFfoL5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119351; c=relaxed/simple;
	bh=Xe3OtzNBKiy3ffkGB6Zk9wuio0FcbdGHRZvI7m9cv0k=;
	h=Date:To:From:Subject:Message-Id; b=CWr0od1rHhjljoq1mHc9n/SMAv0s4c1oq/B9B6i8gL0mYlSAoJBWZQRAnq8wgXEQ47zlhQoiBw/qOAL0p9o7MtOcLlyJbAS6YJv09rVAYhz2eoUDZ2+6WhMfv1L3RCuR2Tqb0VfVGBWqMSkG8RcGG0O1l2yYS9O6FqpovB6IQNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vyKyRMWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vyKyRMWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD53C4CEE4;
	Tue, 13 May 2025 06:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119351;
	bh=Xe3OtzNBKiy3ffkGB6Zk9wuio0FcbdGHRZvI7m9cv0k=;
	h=Date:To:From:Subject:From;
	b=vyKyRMWVS/HuHMyOkg4TKZ6nGsUrz7EIIE5EwT3qfuyGGC17S5kek78xMsFBap2Y7
	 eNx/om1uTNwMd599iy5OaVrwVL3AngHrSXRakGVgs3DvR+SEBeuGE8YDX3n0p1/r2O
	 0tRs81k0cbtsOGpNca09wpoj6NbEjYfXNoUAMOSo=
Date: Mon, 12 May 2025 23:55:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-remove-mmap-retry-merge.patch removed from -mm tree
Message-Id: <20250513065551.4FD53C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: remove mmap() retry merge
has been removed from the -mm tree.  Its filename was
     mm-vma-remove-mmap-retry-merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: remove mmap() retry merge
Date: Fri, 9 May 2025 13:13:36 +0100

We have now introduced a mechanism that obviates the need for a
reattempted merge via the mmap_prepare() file hook, so eliminate this
functionality altogether.

The retry merge logic has been the cause of a great deal of complexity in
the past and required a great deal of careful manoeuvring of code to
ensure its continued and correct functionality.

It has also recently been involved in an issue surrounding maple tree
state, which again points to its problematic nature.

We make it much easier to reason about mmap() logic by eliminating this
and simply writing a VMA once.  This also opens the doors to future
optimisation and improvement in the mmap() logic.

For any device or file system which encounters unwanted VMA fragmentation
as a result of this change (that is, having not implemented .mmap_prepare
hooks), the issue is easily resolvable by doing so.

Link: https://lkml.kernel.org/r/d5d8fc74f02b89d6bec5ae8bc0e36d7853b65cda.1746792520.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/vma.c~mm-vma-remove-mmap-retry-merge
+++ a/mm/vma.c
@@ -24,7 +24,6 @@ struct mmap_state {
 	void *vm_private_data;
 
 	unsigned long charged;
-	bool retry_merge;
 
 	struct vm_area_struct *prev;
 	struct vm_area_struct *next;
@@ -2417,8 +2416,6 @@ static int __mmap_new_file_vma(struct mm
 			!(map->flags & VM_MAYWRITE) &&
 			(vma->vm_flags & VM_MAYWRITE));
 
-	/* If the flags change (and are mergeable), let's retry later. */
-	map->retry_merge = vma->vm_flags != map->flags && !(vma->vm_flags & VM_SPECIAL);
 	map->flags = vma->vm_flags;
 
 	return 0;
@@ -2622,17 +2619,6 @@ static unsigned long __mmap_region(struc
 	if (have_mmap_prepare)
 		set_vma_user_defined_fields(vma, &map);
 
-	/* If flags changed, we might be able to merge, so try again. */
-	if (map.retry_merge) {
-		struct vm_area_struct *merged;
-		VMG_MMAP_STATE(vmg, &map, vma);
-
-		vma_iter_config(map.vmi, map.addr, map.end);
-		merged = vma_merge_existing_range(&vmg);
-		if (merged)
-			vma = merged;
-	}
-
 	__mmap_complete(&map, vma);
 
 	return addr;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch

