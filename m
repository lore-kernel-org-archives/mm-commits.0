Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB5B30566E
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968166; cv=none; b=LeV5ZXAta6iCzTMnBgraGfJ/meMaY1iI5q+e4RgaYyyJYERh5dsb6Aqd+xdZ8fmCROi8NCXENP/WDANXUNei7merALwK/tyk9wpb0ZBW5kS+V0ofoqBfPg5N5KodOvfqazyfNJ0PLIC28d69FN9mrr67z/c6+JOfvGdfXKnq/Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968166; c=relaxed/simple;
	bh=a4uvbAfx8TRJYF+G/NePgkmaRAzoLWS4o5+WF+ThP2s=;
	h=Date:To:From:Subject:Message-Id; b=BeZTor6YcFDXoPyYRgY7tkfuC0RWy+z/1bjUvdSlIaBW5RFhsrHv7JrcpVsUkRT6v+V6Ug8bNMwLtNOLSs/O+HHKWcSvQN5Gp4cw0YLnn2/JFzfI7m7Lem5S77om4ZLX1ZuGC4aO6QhNiMpa6gNEt7e9oNsg+GmbhpRQHhoETYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q7K5yuqJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q7K5yuqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A561F00898;
	Tue,  9 Jun 2026 01:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968163;
	bh=34xrXum9BM/Cxk7beqOQmwsujFHfdYVOlGDJKF8H2fk=;
	h=Date:To:From:Subject;
	b=Q7K5yuqJvQSnClDX9h9lyHT+SZcLKU6sM7bWopgB40U1KBWL9vzToPbfDAQV1PTEI
	 F390KtvTv2Blb7AeYVuL83p9E5spw7J5lgo7dJfTyQpzQy1OI2mVGAdXytShwgaCE8
	 N5e/BJTVkYfdrmQ/ovXjXnqqS8EiyObJ8S3DUSRk=
Date: Mon, 08 Jun 2026 18:22:43 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch removed from -mm tree
Message-Id: <20260609012243.89A561F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
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


