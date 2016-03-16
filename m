From: akpm@linux-foundation.org
Subject: [merged] mm-fix-two-typos-in-comments-for-to_vmem_altmap.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:55:29 -0700
Message-ID: <56e9ba31.LWVm74K7d22eEkvB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbcCPTza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.ziegler@fau.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix two typos in comments for to_vmem_altmap()
has been removed from the -mm tree.  Its filename was
     mm-fix-two-typos-in-comments-for-to_vmem_altmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andreas Ziegler <andreas.ziegler@fau.de>
Subject: mm: fix two typos in comments for to_vmem_altmap()

Commit 4b94ffdc4163 ("x86, mm: introduce vmem_altmap to augment
vmemmap_populate()"), introduced the to_vmem_altmap() function.

The comments in this function contain two typos (one misspelling of the
Kconfig option CONFIG_SPARSEMEM_VMEMMAP, and one missing letter 'n'),
let's fix them up.

Signed-off-by: Andreas Ziegler <andreas.ziegler@fau.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/memremap.c~mm-fix-two-typos-in-comments-for-to_vmem_altmap kernel/memremap.c
--- a/kernel/memremap.c~mm-fix-two-typos-in-comments-for-to_vmem_altmap
+++ a/kernel/memremap.c
@@ -391,7 +391,7 @@ struct vmem_altmap *to_vmem_altmap(unsig
 	/*
 	 * 'memmap_start' is the virtual address for the first "struct
 	 * page" in this range of the vmemmap array.  In the case of
-	 * CONFIG_SPARSE_VMEMMAP a page_to_pfn conversion is simple
+	 * CONFIG_SPARSEMEM_VMEMMAP a page_to_pfn conversion is simple
 	 * pointer arithmetic, so we can perform this to_vmem_altmap()
 	 * conversion without concern for the initialization state of
 	 * the struct page fields.
@@ -400,7 +400,7 @@ struct vmem_altmap *to_vmem_altmap(unsig
 	struct dev_pagemap *pgmap;
 
 	/*
-	 * Uncoditionally retrieve a dev_pagemap associated with the
+	 * Unconditionally retrieve a dev_pagemap associated with the
 	 * given physical address, this is only for use in the
 	 * arch_{add|remove}_memory() for setting up and tearing down
 	 * the memmap.
_

Patches currently in -mm which might be from andreas.ziegler@fau.de are


