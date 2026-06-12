Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37C83A963D
	for <mm-commits@vger.kernel.org>; Fri, 12 Jun 2026 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281276; cv=none; b=OZVcXSb8QposEUCD3z8AKHnIpkOUc1kmBOQ2CHIURe2kzseh2ONceNTC1eJoecQL5UZaksDV7AVpeq6TPuQnGrZM5Yw5BQIbHf43gci+Eqp5CobRnJh13xE51NNY71qXp8a+ABWZTZDnj+4TD6MoYDj+iTjOUsa6DD7z+bte6cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281276; c=relaxed/simple;
	bh=63NdTyDaRtcGb8Y0Z2HdBOWD7w1lBD0Cuo7gZrFRohM=;
	h=Date:To:From:Subject:Message-Id; b=qzR6iUPtwplQzT1LIWjWsCK8iX+/cLnvm3+t9yFq9gTdrx5pPFO74wJXky721wLxjQx2Af4gSyXFKT4RYtd7FORUp0+jcSSFAuY5e49/hNaVEnENuN4zKH+bOToKEv53Zlx3nA3qg30N1O6GZQ6EmXDJPzuRveYyk0P7CAJ+Y+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=swprwTF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="swprwTF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816FE1F000E9;
	Fri, 12 Jun 2026 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781281274;
	bh=xug5b9x1INiYlhCAWGQlgakv93fHg7fwn9xe/RTOtWI=;
	h=Date:To:From:Subject;
	b=swprwTF82HhC1VDK4SmigDRogppWwb7F7Xt2FGTNKRZ01GCPpiZrnWxjW+eOk3hcy
	 n/p6ZmrpF2RJ7IYwbXHZbS1izR7MmSpYSon4F/B1kjvHFIRvxzICNSRbkrD4ngOjPq
	 s5W5e3FJHk98S+PGHLhXqdYSxOJFPNTq+JdvWl7I=
Date: Fri, 12 Jun 2026 09:21:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,huangsj@hygon.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-mapping_mapped-to-simplify-the-code.patch added to mm-unstable branch
Message-Id: <20260612162114.816FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use mapping_mapped to simplify the code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-mapping_mapped-to-simplify-the-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-mapping_mapped-to-simplify-the-code.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-use-mapping_mapped-to-simplify-the-code.patch

