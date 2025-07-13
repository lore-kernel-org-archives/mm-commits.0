Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7150020F063
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450024; cv=none; b=apJ0hsF5rZNXg+SlTjzNPt9gkff5wyH/3f67FY5iuZjDIuG1nBAA9FPnlCNUM2SQnuyJDxH0uuLeE9QtyrommdAkWkfZAkk8oyBtlayjKTFkkFnEeyGlQ4qTbknJmiJhEPX4D0LY0d+yHOzYOiVuoUGPBConR/vELk+pB1zJioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450024; c=relaxed/simple;
	bh=LrsYbji8OIEwbI8eggpFPnEOftzjA+Oj/J4xGeIbJ14=;
	h=Date:To:From:Subject:Message-Id; b=Gm7N0nO362UHbbwJiHVrF91ZpUQbJ1EZh/7LTwtt4x3DjRKszL/OPKQA9+jVIn966jLj4jxee6rmskXjzZnrjTHbfnsGl3PsQy0WDEpAQRREd5pW9cbvhr4waMqZfB0lt+ZvxzBkshNpPIK3xD2Yf7UDtQseuJtYcU4tGd6I8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmgFZh1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmgFZh1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447DBC4CEE3;
	Sun, 13 Jul 2025 23:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450024;
	bh=LrsYbji8OIEwbI8eggpFPnEOftzjA+Oj/J4xGeIbJ14=;
	h=Date:To:From:Subject:From;
	b=OmgFZh1JxXk71ZOAb0/cbIqCAmt9twHWgSHn5dOW64AxMzwUj5q3UOca7G8eGzV8f
	 1bHxKaabxqDmexfNyyfueFIoXs5NMj7j5NjQUHbmwhyc/E7+PxxKVt+GWl9W60CKW+
	 eo96g/LC+f/Z3SRaIwvP+Yc1JK7WFOi139s4DFjE=
Date: Sun, 13 Jul 2025 16:40:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,tsbogend@alpha.franken.de,pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jgg@nvidia.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,chenhuacai@kernel.org,anshuman.khandual@arm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-deduplicate-mm_get_unmapped_area.patch removed from -mm tree
Message-Id: <20250713234024.447DBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: deduplicate mm_get_unmapped_area()
has been removed from the -mm tree.  Its filename was
     mm-deduplicate-mm_get_unmapped_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: deduplicate mm_get_unmapped_area()
Date: Fri, 27 Jun 2025 12:07:39 -0400

Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
the helper instead to dedup the lines.

Link: https://lkml.kernel.org/r/20250627160739.2124768-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-deduplicate-mm_get_unmapped_area
+++ a/mm/mmap.c
@@ -871,9 +871,8 @@ mm_get_unmapped_area(struct mm_struct *m
 		     unsigned long addr, unsigned long len,
 		     unsigned long pgoff, unsigned long flags)
 {
-	if (test_bit(MMF_TOPDOWN, &mm->flags))
-		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags, 0);
-	return arch_get_unmapped_area(file, addr, len, pgoff, flags, 0);
+	return mm_get_unmapped_area_vmflags(mm, file, addr, len,
+					    pgoff, flags, 0);
 }
 EXPORT_SYMBOL(mm_get_unmapped_area);
 
_

Patches currently in -mm which might be from peterx@redhat.com are


