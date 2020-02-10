From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch
 added to -mm tree
Date: Sun, 09 Feb 2020 17:35:49 -0800
Message-ID: <20200210013549.b7iS7M4xH%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgBJBfu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 20:35:50 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/sparsemem: get address to page struct instead of address to pfn
has been added to the -mm tree.  Its filename is
     mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/sparsemem: get address to page struct instead of address to pfn

memmap should be the address to page struct instead of address to pfn.

As mentioned by David, if system memory and devmem sit within a section,
the mismatch address would lead kdump to dump unexpected memory.

Since sub-section only works for SPARSEMEM_VMEMMAP, pfn_to_page() is valid
to get the page struct address at this point.

Link: http://lkml.kernel.org/r/20200210005048.10437-1-richardw.yang@linux.intel.com
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn
+++ a/mm/sparse.c
@@ -884,7 +884,7 @@ int __meminit sparse_add_section(int nid
 
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
-		memmap = pfn_to_kaddr(section_nr_to_pfn(section_nr));
+		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
 	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
 
 	return 0;
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch
