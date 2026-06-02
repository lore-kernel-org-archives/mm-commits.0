Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3817A3B8920
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439021; cv=none; b=ZUI9Iva/s7XHqe/gKDTGbyTF3jRrhEmbwhw78Myq0FxMLyRYoAvpwfz+mY9oiMrc1dov1yO+mHt5RVIvpwjMkiI1GM7S7eD3N00pEsncxMrovrAJxJpCR7Fx2q7D6GtV9o2Yb4L/FxxuEXYHOd+3RqPYm122ztqVSGD+AvWbc5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439021; c=relaxed/simple;
	bh=eeRIEYS/s745jpo2YOfaT/Tfx9b6BsAr1s87uJrb7N0=;
	h=Date:To:From:Subject:Message-Id; b=ROcN+hX+VR/3FUPVyc93ijJdQozjA/Eem3JIU0Ca1QDmA/QJIGsF9PPSqNJX+2UvRARmIrdPF3Yu2jlZmHjrs/u3k5ezP7m63GBfzFBGz3X1YtUPZLBHy7UQLCY8p5VB1GQ6AS1AlcM4/8BaXjMVMFFLQXbT7JgX+AjTOyn54KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qkn5sQOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qkn5sQOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115831F00898;
	Tue,  2 Jun 2026 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439020;
	bh=GRJeSFsuyZTMvwB7DRMkaSPP8fuAo8IF6g82+3yZ0Cs=;
	h=Date:To:From:Subject;
	b=qkn5sQOA6GrIJ0zYv8CWfvsrmrVMdWRragZu9Iy13pYBFuycPC6OvkYfDkIPaW7QP
	 FocNOUdts+Zoibp5h8myRIDSvtWwoRJwF8czftSDUry5nz1kYPSxuQj1zn22ds8PyG
	 fFp/zDylvy71thkELPT/gVCn07SqzdWG5PPRJzD4=
Date: Tue, 02 Jun 2026 15:23:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch removed from -mm tree
Message-Id: <20260602222340.115831F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
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


