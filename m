Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BBC3B8128
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439014; cv=none; b=FcCdUPVP4aWTUCYupRVcWXiVe2hjH7UiEEJGU4BafTdma2fWNItjqtwRm24pjdW11lbCE6Wkp7Aa6O3f4IBFDZ+Paq4t7ZjYWIiPDuRPJqKqksQgF9zmEhHuaPoHB7VIUi6NclvXAQUK50izWBF3ILERGPBlr0BvBfcI6FePoUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439014; c=relaxed/simple;
	bh=8l5HbV6fhzcFmtmc+huuS207hpGeFs+p3V/aqphWKdw=;
	h=Date:To:From:Subject:Message-Id; b=qXpTOg7VBghWK85A4No9/uoEIPuWFy2Rod0XZideCXZQXBlsPKC5KMPTsQX12mwMThpNVqnNauNq+T1rh8LLlgM3X5WkzsqQcjx4G5ki9/084O1tl0ExQa6LQeExW8yk2UXYLUy/cZp89BN5SMGmfv20vJOm/19jyoe2TjsW3Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VcQiUhKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VcQiUhKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B011F00893;
	Tue,  2 Jun 2026 22:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439013;
	bh=BhnfPICZBjHPcfiJD3+mvRVzrD+0e/Rn7tjEnhnVvWc=;
	h=Date:To:From:Subject;
	b=VcQiUhKGNUkUNfXpkQoulhJBKsBkOv7YItUuHOY1T8tRBott2jYIY8c8MRsMAygkS
	 YR/Tl5BJqRb1QndMsTwBkRm+igrQarupuEbgvWYpOpg5Os28nA7EFnf+uxZ+yO6C1S
	 sMOzUPm+7IgNvxlENS5Ig0p989V9Encn8hW6bjUQ=
Date: Tue, 02 Jun 2026 15:23:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-remove-register_page_bootmem_info.patch removed from -mm tree
Message-Id: <20260602222333.34B011F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc/mm: remove register_page_bootmem_info()
has been removed from the -mm tree.  Its filename was
     sparc-mm-remove-register_page_bootmem_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


