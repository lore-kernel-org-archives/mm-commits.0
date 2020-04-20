From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-memmap=5Finit-iterate-over-memblock-regions-rather-that-?=
 =?US-ASCII?Q?check-each-pfn-fix.patch?= added to -mm tree
Date: Mon, 20 Apr 2020 13:32:28 -0700
Message-ID: <20200420203228.vgvKyrDKe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTUca (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 16:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, cai@lca.pw, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix
has been added to the -mm tree.  Its filename is
     mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5940,23 +5940,6 @@ overlap_memmap_init(unsigned long zone,
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
