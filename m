From: akpm@linux-foundation.org
Subject: [merged] mm-sparse-more-check-on-mem_section-number.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:47 -0700
Message-ID: <20120801201847.C188B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:39454 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2HAUSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:49 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5414806obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: more checks on mem_section number
has been removed from the -mm tree.  Its filename was
     mm-sparse-more-check-on-mem_section-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/sparse: more checks on mem_section number

__section_nr() was implemented to retrieve the corresponding memory
section number according to its descriptor.  It's possible that the
specified memory section descriptor doesn't exist in the global array.  So
add more checking on that and report an error for a wrong case.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/sparse.c~mm-sparse-more-check-on-mem_section-number mm/sparse.c
--- a/mm/sparse.c~mm-sparse-more-check-on-mem_section-number
+++ a/mm/sparse.c
@@ -130,6 +130,8 @@ int __section_nr(struct mem_section* ms)
 		     break;
 	}
 
+	VM_BUG_ON(root_nr == NR_SECTION_ROOTS);
+
 	return (root_nr * SECTIONS_PER_ROOT) + (ms - root);
 }
 
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch

