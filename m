Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EEE134A0;
	Fri, 29 Dec 2023 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="049w/qyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0AFC433C7;
	Fri, 29 Dec 2023 19:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879547;
	bh=okBcGcG16HdgE1DkCuuFKfad+BCXBiyFQz8f5U8pb30=;
	h=Date:To:From:Subject:From;
	b=049w/qypdjP0flj6L1N0KNqus0WS6qisq3JNjvSf4smIOZvWtLCrQz/tSD1t7oPQD
	 3JDEeTjv9llFWsaNqukGWLi3Qa4UtITrniCHWid6+DmjN06quFcmFqBgVjzWoK/RJz
	 zWmKYG6uGscgTVgDHCQ+LnlWsgAc5FDyk3fWur7Y=
Date: Fri, 29 Dec 2023 11:52:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,osalvador@suse.de,mgorman@techsingularity.net,david@redhat.com,dan.j.williams@intel.com,aneesh.kumar@linux.ibm.com,quic_charante@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2.patch removed from -mm tree
Message-Id: <20231229195227.CF0AFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparsemem: fix race in accessing memory_section->usage
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2.patch

This patch was dropped because it was folded into mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm/sparsemem: fix race in accessing memory_section->usage
Date: Fri, 27 Oct 2023 16:19:38 +0530

use kfree_rcu() in place of synchronize_rcu(), per David

Link: https://lkml.kernel.org/r/1698403778-20938-1-git-send-email-quic_charante@quicinc.com
Fixes: f46edbd1b151 ("mm/sparsemem: add helpers track active portions of a section at boot")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ++-
 mm/sparse.c            |    5 ++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mmzone.h~mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2
+++ a/include/linux/mmzone.h
@@ -1799,6 +1799,7 @@ static inline unsigned long section_nr_t
 #define SUBSECTION_ALIGN_DOWN(pfn) ((pfn) & PAGE_SUBSECTION_MASK)
 
 struct mem_section_usage {
+	struct rcu_head rcu;
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 	DECLARE_BITMAP(subsection_map, SUBSECTIONS_PER_SECTION);
 #endif
@@ -1992,7 +1993,7 @@ static inline int pfn_section_valid(stru
 {
 	int idx = subsection_map_index(pfn);
 
-	return test_bit(idx, ms->usage->subsection_map);
+	return test_bit(idx, READ_ONCE(ms->usage)->subsection_map);
 }
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
--- a/mm/sparse.c~mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2
+++ a/mm/sparse.c
@@ -806,9 +806,8 @@ static void section_deactivate(unsigned
 		 * was allocated during boot.
 		 */
 		if (!PageReserved(virt_to_page(ms->usage))) {
-			synchronize_rcu();
-			kfree(ms->usage);
-			ms->usage = NULL;
+			kfree_rcu(ms->usage, rcu);
+			WRITE_ONCE(ms->usage, NULL);
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
 	}
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch

