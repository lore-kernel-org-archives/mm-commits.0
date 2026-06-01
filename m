Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D902A3E95AB
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 18:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780337833; cv=none; b=DXiztRvniCvREIrajXpmlOgBnvWUGFU0td91juFu6xV0HhiIbS4WNIiYDJxtsxaQ1jhU9QoZspitsJgwtYkShLBCdS7KVOC1qfkZUEKyLhj1qP9KGTD5ZqpGkQTbTtg5kfRiwzqIzMIgDqFySvHgP4ImvS7J5LjW+1yNxKvJPlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780337833; c=relaxed/simple;
	bh=PAuukEyyZZVuL0lYt2FMzrOLxFkX4fE8/OX3eiwjyuM=;
	h=Date:To:From:Subject:Message-Id; b=enjS7Gr/j1aF0ysiGQUF4T4sRgEADfqHW1VCBorOinbzrEMrIX95aYE2FwtLJrpAwL06uR9CQ3JPgb7mrhmo9Ab5ZI+3RQ2vc19grsmRF9EIU6YH93NEfhZQnry58l0TkotH73wHOFfR4kwWWHu4AGRQbYlFzTtVYpLzGmUDZ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EHhcVTra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EHhcVTra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446D61F0089B;
	Mon,  1 Jun 2026 18:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780337824;
	bh=XvxjD6CfRVrYY7IUZ4knbXgdaCndWPsYfTm6ZxEFEnw=;
	h=Date:To:From:Subject;
	b=EHhcVTraH9NN3aVOiZlqztZDh+ZJlyI6H0xI1PDXFVX/ig6GOfxNErmlQ70iB4f5H
	 sxIgw03OzZhu/1eolq5fYd7lzcBFTowuuU65Gl0YkwuHqLelhKdCmEX/1ruIfgwBuO
	 3B/Lev/IHXox5O/KdHogA0YfozuNVzzzwQs3HHDE=
Date: Mon, 01 Jun 2026 11:17:03 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch added to mm-new branch
Message-Id: <20260601181704.446D61F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc/mm: drop vmemmap_check_pmd helper and use generic code
has been added to the -mm mm-new branch.  Its filename is
     sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

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
Subject: sparc/mm: drop vmemmap_check_pmd helper and use generic code
Date: Mon, 1 Jun 2026 16:48:44 +0800

The generic implementations now suffice; remove the sparc copy.

Link: https://lore.kernel.org/20260601084845.3792171-6-songmuchun@bytedance.com
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

 arch/sparc/mm/init_64.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/sparc/mm/init_64.c~sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code
+++ a/arch/sparc/mm/init_64.c
@@ -2559,17 +2559,6 @@ void __meminit vmemmap_set_pmd(pmd_t *pm
 	pmd_val(*pmd) = pte_base | __pa(p);
 }
 
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	int large = pmd_leaf(*pmdp);
-
-	if (large)
-		vmemmap_verify((pte_t *)pmdp, node, addr, next);
-
-	return large;
-}
-
 int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
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

