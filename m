Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D653EA953
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780337826; cv=none; b=ijcPIPDIhcHOWusMJyJfLnFJr3vpueL+icTP2ZNP+j97ZN+Vq//owJuvIVneEU9H1k/2fcKYWjGX5luviA1IrSYEWeiv+jPKlZU9yuVvzNhSkIhJcPM7MMhE1hxWrEC+QH9BrVJWooKDWohmZH4EUlJDU0zs/wJ5kzc9S85GSq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780337826; c=relaxed/simple;
	bh=jjUBkuqh4FmnPR9DXUuaPIGHWUD3fikU2KMhs3g6log=;
	h=Date:To:From:Subject:Message-Id; b=D9t5IXD5r4X2gRcPkKx0xGqMyP+9ee0Ya3qhqgcmw5ttJ7bbPdP/OeJyiGFCwXZ9/4y2lnMAs+LuF2GYv2574W+Krq+7dRk9eGmrbCN+f2k9yNz4+lTeTUE2vMVBHP0iimOYvdTQ/jCjF/fa+Z069Po9gjNEaH8TUXVLyfb8iZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ie+9Evbb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ie+9Evbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298A81F00893;
	Mon,  1 Jun 2026 18:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780337816;
	bh=JMHYrrqAo9TOpno/twQZY6sluOow+GYEgneKo9mF1pk=;
	h=Date:To:From:Subject;
	b=Ie+9EvbbflvSjZtOWJJXBmLTda3EGx21wnmzzkP/nH9REEsoBNu5Ha/sLAseOw2qf
	 wd/7/YzJR9nhvZLgxIP570Pc5fQdm1qqpSApERSAfjdafjuKW6QCsqgKHfxDaUPOLF
	 6FDtxGWyDFpdsiu9dKZ3eLfmFQw5N4BVSUSMqCvk=
Date: Mon, 01 Jun 2026 11:16:55 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch added to mm-new branch
Message-Id: <20260601181656.298A81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch

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
Subject: mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
Date: Mon, 1 Jun 2026 16:48:40 +0800

Patch series "mm/sparse-vmemmap: Provide generic vmemmap_set_pmd() and
vmemmap_check_pmd()", v3.

The weak vmemmap_set_pmd() and vmemmap_check_pmd() hooks are currently
no-ops in the generic code, which leaves architectures that need PMD-level
handling to open-code the same logic locally.

This series provides generic implementations for both helpers in
mm/sparse-vmemmap.c.  vmemmap_set_pmd() installs a huge PMD with
PAGE_KERNEL protection, and vmemmap_check_pmd() verifies a present leaf
PMD before reusing the existing vmemmap_verify() helper.

With those generic helpers in place, patches 2-5 remove the now redundant
arch-specific implementations from arm64, riscv, loongarch, and sparc.


This patch (of 5):

The two weak functions are currently no-ops on every architecture, forcing
each platform that needs them to duplicate the same handful of lines. 
Provide a generic implementation:

- vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.

- vmemmap_check_pmd() verifies that the PMD is present and leaf,
  then calls the existing vmemmap_verify() helper.

Architectures that need special handling can continue to override the weak
symbols; everyone else gets the standard version for free.

Link: https://lore.kernel.org/20260601084845.3792171-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260601084845.3792171-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/sparse-vmemmap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd
+++ a/mm/sparse-vmemmap.c
@@ -386,12 +386,17 @@ int __meminit vmemmap_populate_hvo(unsig
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
+	WARN_ON_ONCE(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));
 }
 
 int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 				       unsigned long addr, unsigned long next)
 {
-	return 0;
+	if (!pmd_leaf(pmdp_get(pmd)))
+		return 0;
+	vmemmap_verify((pte_t *)pmd, node, addr, next);
+
+	return 1;
 }
 
 int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch
mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch
arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch
riscv-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch
loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch
sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

