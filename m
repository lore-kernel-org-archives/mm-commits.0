Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BFF1E8322
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751058729; cv=none; b=aWijb4ip2d63TMV6Vqtjk6JLWDYgTzBzQwRGw+wYPBJYzPkGrgRoyKpJIy7JoFig+s70R3MSh+7ktAJ5Ruaewu/ylM7Fgl2kir3yqkqQLyIgj/ZI5NqkFcU27dv90GTwVTYkeFIA3yj7Z8dzWb9G264QVqJZef0HYlMG1jxbXmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751058729; c=relaxed/simple;
	bh=wTH5KPi1rKyDmR202vV2Nk+M02jiOESSkUYCt2zZWTc=;
	h=Date:To:From:Subject:Message-Id; b=E+6Bz3u/zZDTeGDmsPIgUB9Crl11G9e1/2qTx5e5v1Pmd6NB50wXspMXTzHEJvhk/qTS1gB3OV54L2L1MeHxkK7pBSPqzqN67kvn5QZB+n/qykCtr9vJ/4Bg6IKG851Y0RCoOwvuf4v7WVXOzULvN8LfE7eLdPSHZYB1twXXSug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cSJd9nD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cSJd9nD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8366AC4CEE3;
	Fri, 27 Jun 2025 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751058728;
	bh=wTH5KPi1rKyDmR202vV2Nk+M02jiOESSkUYCt2zZWTc=;
	h=Date:To:From:Subject:From;
	b=cSJd9nD24hGGQTQ0vynBAl/nsmWzbTtvGSCHadY06rL/9Wh+NOtAMdv9tomr0R3YH
	 3PrTw+/2G9+jSI6H6mPaYanbSYZbueo6kx4jtHsiPdZXsz3Zecx2TEpBzNiqkdvyG/
	 ykKk2NurLyckrRtyDaitj8bE3D2+EurmzdnohFWQ=
Date: Fri, 27 Jun 2025 14:12:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,tsbogend@alpha.franken.de,pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jgg@nvidia.com,jannh@google.com,david@redhat.com,chenhuacai@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-deduplicate-mm_get_unmapped_area.patch added to mm-new branch
Message-Id: <20250627211208.8366AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: deduplicate mm_get_unmapped_area()
has been added to the -mm mm-new branch.  Its filename is
     mm-deduplicate-mm_get_unmapped_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-deduplicate-mm_get_unmapped_area.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch
selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch
mm-hugetlb-remove-prepare_hugepage_range.patch
mm-deduplicate-mm_get_unmapped_area.patch

