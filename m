From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 =?US-ASCII?Q?mm-memmap=5Finit-iterate-over-memblock-regions-rather-that-?=
 =?US-ASCII?Q?check-each-pfn-fix.patch?= removed from -mm tree
Date: Wed, 03 Jun 2020 15:08:00 -0700
Message-ID: <20200603220800.otPhpaZaM%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgFCWIB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:08:01 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, cai@lca.pw, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix
has been removed from the -mm tree.  Its filename was
     mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix.patch

This patch was dropped because it was folded into mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix

fix a compilation warning from Clang

mm/page_alloc.c:5917:39: warning: unused function 'next_pfn' [-Wunused-function]
static inline __meminit unsigned long next_pfn(unsigned long pfn)

Link: http://lkml.kernel.org/r/CF6E407F-17DC-427C-8203-21979FB882EF@lca.pw
Cc: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/mm/page_alloc.c~mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix
+++ a/mm/page_alloc.c
@@ -5948,23 +5948,6 @@ overlap_memmap_init(unsigned long zone,
 	return false;
 }
 
-#ifdef CONFIG_SPARSEMEM
-/* Skip PFNs that belong to non-present sections */
-static inline __meminit unsigned long next_pfn(unsigned long pfn)
-{
-	const unsigned long section_nr = pfn_to_section_nr(++pfn);
-
-	if (present_section_nr(section_nr))
-		return pfn;
-	return section_nr_to_pfn(next_present_section_nr(section_nr));
-}
-#else
-static inline __meminit unsigned long next_pfn(unsigned long pfn)
-{
-	return pfn++;
-}
-#endif
