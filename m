Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B703E16A9
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 18:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780337829; cv=none; b=aEbbdYMeZLeJEhUc6gfYhqKxUy0dBuwT5pi7DJBvO5ULH9li7U5MJOEtWT0L0AWQBDXyu5wjjxY8cOu4LaJzY6z8AH9I9fcy6vwElFQ5UrxGyTZmq7aoceVPv8eSLuyPhrpJ+WHyUmYNPRN+PF8RP47UcvNm8NUMYRJ7m24PjNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780337829; c=relaxed/simple;
	bh=1C2JUFnq8uXIuPWk/WU18wTUhs25D3XsOGbawID5X8U=;
	h=Date:To:From:Subject:Message-Id; b=Qht0smwcgaD2kK+uDnMaXl0j6QjQ1EscPrflntSJVw0HE3HxmmeNqHKZbfNRrc0RwYYUauoS9IArFmQjnSJznCpdJeNrjgW+SUns7/xhI5eCWGt25TvYChoTK12/4iO+DfmhUlptU6y/0gvS7fC9KSFk7vnA9kvLHH2Gmya4XS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LJ7AQWTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LJ7AQWTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5481F0089A;
	Mon,  1 Jun 2026 18:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780337822;
	bh=fJxnXjXmfXewQ5qKEXqEjf3BLTZ4Rffd7dZxe7bqu8M=;
	h=Date:To:From:Subject;
	b=LJ7AQWTX2bp9fEJIzMtIi7I6p6ZZmj+z4GINfYex1G5kc6EdPv8C3sLRKDRGSqYKs
	 b+qG5+3PbStz8e+/ewsAom1HbyMoVAncCkLsOwevJkf6JHj93NAvyi/Ue/q0LJQtNT
	 qHqxFUCKmrSJcHfev1CjGFnt6ff0vfL5MQIZGzYw=
Date: Mon, 01 Jun 2026 11:17:01 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch added to mm-new branch
Message-Id: <20260601181702.3F5481F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: loongarch/mm: drop vmemmap_check_pmd helper and use generic code
has been added to the -mm mm-new branch.  Its filename is
     loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: loongarch/mm: drop vmemmap_check_pmd helper and use generic code
Date: Mon, 1 Jun 2026 16:48:43 +0800

The generic implementations now suffice; remove the loongarch copy.

Link: https://lore.kernel.org/20260601084845.3792171-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/mm/init.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/loongarch/mm/init.c~loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code
+++ a/arch/loongarch/mm/init.c
@@ -140,17 +140,6 @@ void __meminit vmemmap_set_pmd(pmd_t *pm
 	set_pmd_at(&init_mm, addr, pmd, entry);
 }
 
-int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
-				unsigned long addr, unsigned long next)
-{
-	int huge = pmd_val(pmdp_get(pmd)) & _PAGE_HUGE;
-
-	if (huge)
-		vmemmap_verify((pte_t *)pmd, node, addr, next);
-
-	return huge;
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch
mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch
arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch
riscv-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch
loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch
sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

