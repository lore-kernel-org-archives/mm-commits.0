Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EF7477990
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 20:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222984; cv=none; b=ZHXyz60QXcK7j4f39o8FoJ6wRruVoQFXV4ngxKCeCvhvEDXYPhGNM3CO8Wupm8NA/QWj29yy01fNeX4Sir5pHmZNGdJ0CadAxTkIxtVubxcxNfPN9muCiAaK7cv8JQaLqOMJnRvFFMdNQ5xh50X6VJfspKhUlcHWylMxic/ZMj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222984; c=relaxed/simple;
	bh=YXM3+BnhQP0/S44tmVBdmtZFJvmJLb1nGCJbA+ieZUE=;
	h=Date:To:From:Subject:Message-Id; b=WcnFlX6ZuCE3LLfpDqYT1Azt3MDeheb6q2AYfi+jAe0GIj/H152JVpnsnMA/QZpBZwlvaFupadaxxVVYk7pHpWuPp1KJge+g88n8mww/8eeL9zUmzchLR7lQQ18/ouXhPRSlQ33LcBQLAq/TZKA3awQsMVQjvljGvkJBfKGLym0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RurHAVIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RurHAVIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF844C116C6;
	Fri, 27 Feb 2026 20:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772222983;
	bh=YXM3+BnhQP0/S44tmVBdmtZFJvmJLb1nGCJbA+ieZUE=;
	h=Date:To:From:Subject:From;
	b=RurHAVIZMhl4jM96dEjVGSvYT/cdzIr5wJ8MEgTU+Kp/oDOszqa2fA+v2p5bWTqQD
	 tijKTI2VynflEhHGS6wy7c1GXzEe5hUshuuGOKDEiQ9oCdRluyblO1VgF9JK82PhGy
	 jHFNK74aQn846LYAYqCyKRURQSrWNja6gbJ0DlZM=
Date: Fri, 27 Feb 2026 12:09:43 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-align-vmemmap-to-maximal-folio-size.patch added to mm-new branch
Message-Id: <20260227200943.AF844C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv/mm: align vmemmap to maximal folio size
has been added to the -mm mm-new branch.  Its filename is
     riscv-mm-align-vmemmap-to-maximal-folio-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-align-vmemmap-to-maximal-folio-size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: riscv/mm: align vmemmap to maximal folio size
Date: Fri, 27 Feb 2026 19:42:43 +0000

The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
struct pages of the head page to be naturally aligned with regard to the
folio size.

Align vmemmap to the newly introduced MAX_FOLIO_VMEMMAP_ALIGN.

Link: https://lkml.kernel.org/r/20260227194302.274384-6-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/init.c   |    3 ++-
 include/linux/mmzone.h |   11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/init.c~riscv-mm-align-vmemmap-to-maximal-folio-size
+++ a/arch/riscv/mm/init.c
@@ -63,7 +63,8 @@ phys_addr_t phys_ram_base __ro_after_ini
 EXPORT_SYMBOL(phys_ram_base);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#define VMEMMAP_ADDR_ALIGN	(1ULL << SECTION_SIZE_BITS)
+#define VMEMMAP_ADDR_ALIGN	max(1ULL << SECTION_SIZE_BITS, \
+				    MAX_FOLIO_VMEMMAP_ALIGN)
 
 unsigned long vmemmap_start_pfn __ro_after_init;
 EXPORT_SYMBOL(vmemmap_start_pfn);
--- a/include/linux/mmzone.h~riscv-mm-align-vmemmap-to-maximal-folio-size
+++ a/include/linux/mmzone.h
@@ -92,6 +92,17 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
+/*
+ * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * be naturally aligned with regard to the folio size.
+ *
+ * HVO which is only active if the size of struct page is a power of 2.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN \
+	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
+	 is_power_of_2(sizeof(struct page)) ? \
+	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
_

Patches currently in -mm which might be from kas@kernel.org are

mm-move-max_folio_order-definition-to-mmzoneh.patch
mm-change-the-interface-of-prep_compound_tail.patch
mm-rename-the-compound_head-field-in-the-struct-page-to-compound_info.patch
mm-move-set-clear_compound_head-next-to-compound_head.patch
riscv-mm-align-vmemmap-to-maximal-folio-size.patch
loongarch-mm-align-vmemmap-to-maximal-folio-size.patch
mm-rework-compound_head-for-power-of-2-sizeofstruct-page.patch
mm-sparse-check-memmap-alignment-for-compound_info_has_mask.patch
mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch
mm-hugetlb-refactor-code-around-vmemmap_walk.patch
x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32.patch
mm-hugetlb-remove-fake-head-pages.patch
mm-drop-fake-head-checks.patch
hugetlb-remove-vmemmap_synchronize_rcu.patch
mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key.patch
mm-remove-the-branch-from-compound_head.patch
hugetlb-update-vmemmap_deduprst.patch
mm-slab-use-compound_head-in-page_slab.patch

