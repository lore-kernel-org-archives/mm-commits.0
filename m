Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB6D301474
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968170; cv=none; b=EHRwQ4rlXglD61Eu0wIiwoDAnNIHizPOg5brGw6Nyc5jgmnNU/yQ5Ndoc4GgZyhk6qbfv4LgrBrR+0ot4azzLP/irBdEgwH3Zb1O60uqIz+ZYqc1kl/u0GC/PFlpslZw57QjDatlk0AgRcG7aZFlpG83Ziz1ScdgBD15KDrK3mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968170; c=relaxed/simple;
	bh=irBioJyGVjaiXdXaYoOUNVM6/uv3YGBvow6n1p5ZSuA=;
	h=Date:To:From:Subject:Message-Id; b=t4Ig8wpaVO38fS06W5scnglP5sH2Iq3+j/qKKI4FR1ZMYyrqZyL8XH7O3Ok1PVK8IuInh/Al5EHR7gZC4PE1q6DBS5pUMNUJ1ZTogECobj1bURl3Iq/7WyPoO3xtXJr3aZgybB8wuSvOvzQ8sesxC6zMROeFhz5eZbaH9RdTle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yf3OqAJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yf3OqAJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553751F00898;
	Tue,  9 Jun 2026 01:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968168;
	bh=zhORNbgz7f9MPb19LpX26UqUrKcwPdBiU4g85KRoZbE=;
	h=Date:To:From:Subject;
	b=yf3OqAJ7PZEXGxbi5MYv67E4ZLLdkPa4R4nhVZQzI/UmlqJWR+Z3pA/SzGaxObYwj
	 DJj5Op6ko6gMEbU9cazGz45n81faFEikON3xnoDI9ML1vx9HXkwn92I5ZYA6idPHye
	 KXkk0j46xrCDQ368J9YI20lI0p6gbh6BIGBRHu5E=
Date: Mon, 08 Jun 2026 18:22:47 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch removed from -mm tree
Message-Id: <20260609012248.553751F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: loongarch/mm: drop vmemmap_check_pmd helper and use generic code
has been removed from the -mm tree.  Its filename was
     loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: loongarch/mm: drop vmemmap_check_pmd helper and use generic code
Date: Mon, 1 Jun 2026 16:48:43 +0800

The generic implementations now suffice; remove the loongarch copy.

Link: https://lore.kernel.org/20260601084845.3792171-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
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


