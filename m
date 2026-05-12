Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B07A2F8E94
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620655; cv=none; b=bDhE7BagIotHbc3g9cGy5feiPjwv8r0NoRyGtAFUw4upwvI3hyo7kD5q90M/xTXBFJzqUXzVVq9Xh1IakLL5UtuVKcysrVh9Gpd4YxqetavpoqOENgbfU/P5G3v1iq4o27+MVR+my1TOx9wLcsGE4F3RzZvtX7+GpD2QwJ1uNyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620655; c=relaxed/simple;
	bh=SmZKSbHpUS3kcVHVdD1R7v+OKX6cvOCRts5t3MBaBBw=;
	h=Date:To:From:Subject:Message-Id; b=vCz1TMKUlD+zbfowUcoFuBwutzrqHLo5ocJbfn0H2wFm+fDT74taNtjY1zVu7LQlWFJGkAwJDzLRpnQjj6suI7YQLe+49a6eArDbzS4v53qQQwK/8VQc48S7DqOlXeIKD0dxeLsTlvC0JG4Jw5xIGPdCp1vKBvr0phC9lBjf6XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wunZRAo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wunZRAo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BC7C2BCB0;
	Tue, 12 May 2026 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778620654;
	bh=SmZKSbHpUS3kcVHVdD1R7v+OKX6cvOCRts5t3MBaBBw=;
	h=Date:To:From:Subject:From;
	b=wunZRAo5ffI2ngNR9Ha8FWep3jx21J4/H5zzX0SgvT23ANRzq751z7rahyMNgjf57
	 lHqZ8XJFXovojxXoOQ5X9ojzR6DID9zDh9gEYhxQ1fJLOW5bjSco5rMRIpiF3xCUWo
	 lM6RI0p/HLPNj+DvaG+jOrO3s6mpkJbhmlC49SXY=
Date: Tue, 12 May 2026 14:17:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-remove-register_page_bootmem_info.patch added to mm-new branch
Message-Id: <20260512211734.B9BC7C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc/mm: remove register_page_bootmem_info()
has been added to the -mm mm-new branch.  Its filename is
     sparc-mm-remove-register_page_bootmem_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-remove-register_page_bootmem_info.patch

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
Subject: sparc/mm: remove register_page_bootmem_info()
Date: Mon, 11 May 2026 16:05:29 +0200

Patch series "mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 1)".

We want to remove CONFIG_HAVE_BOOTMEM_INFO_NODE.  As a first step, let's
limit the remaining harm to x86 and core code, removing sparc, ppc and
s390 leftovers, starting the stepwise removal by removing and simplifying
some code.

Once a related x86 vmemmap fix [1] is in, we can merge part 2 that will
remove CONFIG_HAVE_BOOTMEM_INFO_NODE entirely.

Tested on x86-64 with hugetlb vmemmap optimization in combination with
KMEMLEAK, making sure that the problem reported in dd0ff4d12dd2 ("bootmem:
remove the vmemmap pages from kmemleak in put_page_bootmem") does not
reappear -- hoping I managed to trigger the original problem.


This patch (of 8):

sparc does not select CONFIG_HAVE_BOOTMEM_INFO_NODE, therefore,
register_page_bootmem_info_node() is a nop.

Let's just get rid of register_page_bootmem_info().

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org
Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-1-3fb0be6fc688@kernel.org
Link: https://lore.kernel.org/r/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org [1]
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

 arch/sparc/mm/init_64.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/arch/sparc/mm/init_64.c~sparc-mm-remove-register_page_bootmem_info
+++ a/arch/sparc/mm/init_64.c
@@ -27,7 +27,6 @@
 #include <linux/percpu.h>
 #include <linux/mmzone.h>
 #include <linux/gfp.h>
-#include <linux/bootmem_info.h>
 
 #include <asm/head.h>
 #include <asm/page.h>
@@ -2477,17 +2476,6 @@ int page_in_phys_avail(unsigned long pad
 	return 0;
 }
 
-static void __init register_page_bootmem_info(void)
-{
-#ifdef CONFIG_NUMA
-	int i;
-
-	for_each_online_node(i)
-		if (NODE_DATA(i)->node_spanned_pages)
-			register_page_bootmem_info_node(NODE_DATA(i));
-#endif
-}
-
 void __init arch_setup_zero_pages(void)
 {
 	phys_addr_t zero_page_pa = kern_base +
@@ -2498,14 +2486,6 @@ void __init arch_setup_zero_pages(void)
 
 void __init mem_init(void)
 {
-	/*
-	 * Must be done after boot memory is put on freelist, because here we
-	 * might set fields in deferred struct pages that have not yet been
-	 * initialized, and memblock_free_all() initializes all the reserved
-	 * deferred pages for us.
-	 */
-	register_page_bootmem_info();
-
 	if (tlb_type == cheetah || tlb_type == cheetah_plus)
 		cheetah_ecache_flush_init();
 }
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

