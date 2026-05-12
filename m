Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A05357D19
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620661; cv=none; b=ocxMpOXwd0hm4b7jkljKXBaxyhIspyLhGRgPRiOyyfCYDW/ochGS8CUzHUE35IZnD647UdOB+b/HN44eDfJoNb1U55vuR2Pin3WMDemjv12lrFYPy07GoAxnbvjBAtuN7Uk4I3BFem8Qky2/pah+ImaDrQSSI86SVoh6QVllDKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620661; c=relaxed/simple;
	bh=jaC+U0vSis8AuaQ3Bi/++0V1tXHEG9nuUQ1DirjDyIA=;
	h=Date:To:From:Subject:Message-Id; b=dH8oaf4xe27LKIaOk2nqU/b70jxvHxDvhTvD8aYzbWRQGjzm9nYPsQwayMrVO59UPwZNK8ip+j8zBYuT/flHmmH8hC4MM3x05sl+qNXSJ53NmJIqPRc763vYcJOAseon8TFZxx6PvcqDfdZEsI4lSynO1vj8MVt9FEdKTHMKTxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T4+G4qDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T4+G4qDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AE6C2BCB0;
	Tue, 12 May 2026 21:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778620661;
	bh=jaC+U0vSis8AuaQ3Bi/++0V1tXHEG9nuUQ1DirjDyIA=;
	h=Date:To:From:Subject:From;
	b=T4+G4qDqaxstYmlhvT+CBDqXfiKdLgPtyoSQZcxBhC8gqXFyNvy1UYPL/bVOkX7kl
	 6MI1flePaAtzyJxWP1O6k0MLn39Vtp8IUp+h/SNWoQ56/K+xJhgF3tIM58SMy++lWJ
	 f4esACQSLhpyiqUa/Hiv9FTdhlnn9HtzjBZGcf/E=
Date: Tue, 12 May 2026 14:17:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch added to mm-new branch
Message-Id: <20260512211741.74AE6C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
has been added to the -mm mm-new branch.  Its filename is
     mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
Date: Mon, 11 May 2026 16:05:34 +0200

We never free the ms->usage data for boot memory sections (see
section_deactivate()). And to identify whether ms->usage was allocated
from memblock, we simply identify it by looking at PG_reserved.

Consequently, there is no need to mark ms->usage as MIX_SECTION_INFO.
Let's just stop doing that.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-6-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem_info.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info
+++ a/mm/bootmem_info.c
@@ -38,10 +38,8 @@ void put_page_bootmem(struct page *page)
 
 static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
-	unsigned long mapsize, section_nr, i;
+	unsigned long section_nr;
 	struct mem_section *ms;
-	struct mem_section_usage *usage;
-	struct page *page;
 
 	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
 	section_nr = pfn_to_section_nr(start_pfn);
@@ -50,14 +48,6 @@ static void __init register_page_bootmem
 	if (!preinited_vmemmap_section(ms))
 		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
 					     PAGES_PER_SECTION);
-
-	usage = ms->usage;
-	page = virt_to_page(usage);
-
-	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
-
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 }
 
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
_

Patches currently in -mm which might be from david@kernel.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch
mm-fix-__vm_normal_page-to-handle-missing-support-for-pmd_special-pud_special.patch
sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch
sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

