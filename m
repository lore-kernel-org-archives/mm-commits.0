Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49B139CCE0
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 17:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784049248; cv=none; b=q/K05TEZL4H2fJzZX7swtWT1oSiITvV122hIOtWcHyb1uqzYq8FLP78djDJjd+jWHTBWfyE9Tdj8GEVJKgxmv240GTQVV5WEgutx4Cn0AQvyt/VKIuxpZMhnb29oi+XIfDPK1rgwVaRfgK0fARPKRgKccinx8OZ5wYTw6PWyxAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784049248; c=relaxed/simple;
	bh=m81o1pJ1ACHYKvlZO/Oq7nB0DhnpHvtaihANNrGcI3Q=;
	h=Date:To:From:Subject:Message-Id; b=pPKyh0bdgaw6HdHYVOgWpxkkIjELtv+40D7xQV1HOypM/u9Jn7SlqZcPnfaXXiywx77xL6mz5GWYCYnyZ+FRr2XzDbm7CyaVgtP6BibkrzXig8OrzKRprMhVUvkNLlAMigibx2bdW5cXY7HYOYWvFAxhb/nXmHUCpWUVTlWN7XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PA+3Y9EG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PA+3Y9EG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FD21F00A3A;
	Tue, 14 Jul 2026 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784049246;
	bh=xDUklH5CZOOmXti3vJKUVFMIL89NwZ+3moHzzIgk/Xs=;
	h=Date:To:From:Subject;
	b=PA+3Y9EGm2G+w/Kq8JWLbNb9y9wBzwLa2ZtgQNiYoE1XFwjZ46/Al+7yIG2v0eWMB
	 8YNZ7D5eMvN5clMprPv/KOvzOKSVAW9s2qEHoRw3wSoFsk4eO5Ldx96H6T5e/H2PvS
	 34QoExraQnWHkkoT7IqklLcNhJK3rFVYe6ICOCjE=
Date: Tue, 14 Jul 2026 10:14:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,alex@ghiti.fr,wangruikang@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] riscv-mm-avoid-spurious-fault-after-hotplugging-vmemmap.patch removed from -mm tree
Message-Id: <20260714171406.31FD21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: mm: avoid spurious fault after hotplugging vmemmap
has been removed from the -mm tree.  Its filename was
     riscv-mm-avoid-spurious-fault-after-hotplugging-vmemmap.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Vivian Wang <wangruikang@iscas.ac.cn>
Subject: riscv: mm: avoid spurious fault after hotplugging vmemmap
Date: Tue, 30 Jun 2026 15:51:59 +0800

section_activate() does not flush TLB after populating new vmemmap pages. 
On most architectures, this is okay.  However it is a problem on RISC-V
since there the TLB caching non-present entries is permitted, which causes
spurious faults on some hardwares.

This seems to be most easily reproduced with DEBUG_VM=y and
PAGE_POISONING=y, which causes these newly mapped struct pages to be
poisoned i.e.  written to immediately after mapping.

Add a hook vmemmap_populate_finalize() in __populate_section_memmap()
after population, to allow architectures to handle such situations as
needed.  Then implement it on RISC-V to arrange for the existing exception
handler code to deal with these faults if they happen.

Link: https://lore.kernel.org/20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |    4 ++++
 arch/riscv/mm/init.c             |    6 ++++++
 mm/sparse-vmemmap.c              |    8 ++++++++
 3 files changed, 18 insertions(+)

--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-avoid-spurious-fault-after-hotplugging-vmemmap
+++ a/arch/riscv/include/asm/pgtable.h
@@ -1260,6 +1260,10 @@ static inline pte_t pte_swp_clear_exclus
 #define TASK_SIZE	FIXADDR_START
 #endif
 
+/* Needed on SPARSEMEM_VMEMMAP */
+#define vmemmap_populate_finalize vmemmap_populate_finalize
+void __meminit vmemmap_populate_finalize(void);
+
 #else /* CONFIG_MMU */
 
 #define PAGE_SHARED		__pgprot(0)
--- a/arch/riscv/mm/init.c~riscv-mm-avoid-spurious-fault-after-hotplugging-vmemmap
+++ a/arch/riscv/mm/init.c
@@ -1372,6 +1372,12 @@ int __meminit vmemmap_populate(unsigned
 	 */
 	return vmemmap_populate_hugepages(start, end, node, altmap);
 }
+
+void __meminit vmemmap_populate_finalize(void)
+{
+	/* Avoid faults on cached non-present TLB entries. */
+	mark_new_valid_map();
+}
 #endif
 
 #if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
--- a/mm/sparse-vmemmap.c~riscv-mm-avoid-spurious-fault-after-hotplugging-vmemmap
+++ a/mm/sparse-vmemmap.c
@@ -544,6 +544,12 @@ static int __meminit vmemmap_populate_co
 
 #endif
 
+#ifndef vmemmap_populate_finalize
+static void __meminit vmemmap_populate_finalize(void)
+{
+}
+#endif
+
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -564,6 +570,8 @@ struct page * __meminit __populate_secti
 	if (r < 0)
 		return NULL;
 
+	vmemmap_populate_finalize();
+
 	return pfn_to_page(pfn);
 }
 
_

Patches currently in -mm which might be from wangruikang@iscas.ac.cn are

riscv-mm-fix-concurrency-in-mark_new_valid_map.patch

