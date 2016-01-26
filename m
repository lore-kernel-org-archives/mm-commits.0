From: akpm@linux-foundation.org
Subject: + mm-fix-two-typos-in-comments-for-to_vmem_altmap.patch added to
 -mm tree
Date: Mon, 25 Jan 2016 16:46:55 -0800
Message-ID: <56a6c1ff.lb7iFjYgr60d+Q2S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615AbcAZAq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 19:46:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.ziegler@fau.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix two typos in comments for to_vmem_altmap()
has been added to the -mm tree.  Its filename is
     mm-fix-two-typos-in-comments-for-to_vmem_altmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-two-typos-in-comments-for-to_vmem_altmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-two-typos-in-comments-for-to_vmem_altmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -377,7 +377,7 @@ struct vmem_altmap *to_vmem_altmap(unsig
 	/*
 	 * 'memmap_start' is the virtual address for the first "struct
 	 * page" in this range of the vmemmap array.  In the case of
-	 * CONFIG_SPARSE_VMEMMAP a page_to_pfn conversion is simple
+	 * CONFIG_SPARSEMEM_VMEMMAP a page_to_pfn conversion is simple
 	 * pointer arithmetic, so we can perform this to_vmem_altmap()
 	 * conversion without concern for the initialization state of
 	 * the struct page fields.
@@ -386,7 +386,7 @@ struct vmem_altmap *to_vmem_altmap(unsig
 	struct dev_pagemap *pgmap;
 
 	/*
-	 * Uncoditionally retrieve a dev_pagemap associated with the
+	 * Unconditionally retrieve a dev_pagemap associated with the
 	 * given physical address, this is only for use in the
 	 * arch_{add|remove}_memory() for setting up and tearing down
 	 * the memmap.
_

Patches currently in -mm which might be from andreas.ziegler@fau.de are

mm-fix-two-typos-in-comments-for-to_vmem_altmap.patch

