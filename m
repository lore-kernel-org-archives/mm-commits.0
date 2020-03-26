From: akpm@linux-foundation.org
Subject: +
 mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch added to
 -mm tree
Date: Thu, 26 Mar 2020 12:41:30 -0700
Message-ID: <20200326194130.KQt2jbeWd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZTlc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 15:41:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pankaj.gupta.linux@gmail.com, richardw.yang@linux.intel.com, rppt@linux.ibm.com, sachinp@linux.vnet.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2
has been added to the -mm tree.  Its filename is
     mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2

add comment

Link: http://lkml.kernel.org/r/20200326133235.343616-1-aneesh.kumar@linux.ibm.com
Fixes: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2
+++ a/mm/sparse.c
@@ -781,7 +781,11 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		/* Mark the section invalid */
+		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
 		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-sparse-fix-kernel-crash-with-pfn_section_valid-check.patch
mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch
