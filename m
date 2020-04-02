From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 108/155] mm/sparsemem: get address to page struct
 instead of address to pfn
Date: Wed, 01 Apr 2020 21:09:24 -0700
Message-ID: <20200402040924.8ku8o5ahW%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEJ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:26 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, torvalds@linux-foundation.org

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
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn
+++ a/mm/sparse.c
@@ -894,7 +894,7 @@ int __meminit sparse_add_section(int nid
 
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
-		memmap = pfn_to_kaddr(section_nr_to_pfn(section_nr));
+		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
 	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
 
 	return 0;
_
