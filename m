From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch removed
 from -mm tree
Date: Sat, 28 Mar 2020 19:12:50 -0700
Message-ID: <20200329021250.8PmoLdGwm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgC2CMw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 22:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pankaj.gupta.linux@gmail.com, richardw.yang@linux.intel.com, rppt@linux.ibm.com, sachinp@linux.vnet.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch

This patch was dropped because it was folded into mm-sparse-fix-kernel-crash-with-pfn_section_valid-check.patch

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
