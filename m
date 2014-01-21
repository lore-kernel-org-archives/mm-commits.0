From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage-fix.patch
 removed from -mm tree
Date: Tue, 21 Jan 2014 15:29:36 -0800
Message-ID: <52df02e0.83YW1XXKSKi9t2ry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaAUX3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:29:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, murzin.v@gmail.com, nasa4836@gmail.com

Subject: [folded-merged] mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage-fix.patch removed from -mm tree
To: nasa4836@gmail.com,murzin.v@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:29:36 -0800


The patch titled
     Subject: Re: mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage-fix.patch

This patch was dropped because it was folded into mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}

I just sent the incorrect patch...

it should be
 -   page = pte_page(pte);
 +  pfn = pte_pfn(pte);;

Cc: Vladimir Murzin <murzin.v@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage-fix
+++ a/mm/vmalloc.c
@@ -225,7 +225,7 @@ int is_vmalloc_or_module_addr(const void
 unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
-	unsigned long pfn;
+	unsigned long pfn = 0;
 	pgd_t *pgd = pgd_offset_k(addr);
 
 	/*
@@ -244,7 +244,7 @@ unsigned long vmalloc_to_pfn(const void
 				ptep = pte_offset_map(pmd, addr);
 				pte = *ptep;
 				if (pte_present(pte))
-					pfn = pte_page(pte);
+					pfn = pte_pfn(pte);
 				pte_unmap(ptep);
 			}
 		}
_

Patches currently in -mm which might be from nasa4836@gmail.com are

mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch

