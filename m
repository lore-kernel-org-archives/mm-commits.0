From: akpm@linux-foundation.org
Subject: + mm-sparse-more-check-on-mem_section-number.patch added to -mm tree
Date: Mon, 23 Jul 2012 15:26:42 -0700
Message-ID: <20120723222643.BC5CE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64581 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2GWW0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 18:26:46 -0400
Received: by fat25 with SMTP id 25so345309fat.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 15:26:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm/sparse: more checks on mem_section number
has been added to the -mm tree.  Its filename is
     mm-sparse-more-check-on-mem_section-number.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm/sparse: more checks on mem_section number

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

linux-next.patch
mm-slab-remove-duplicate-check.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
mm-compaction-cleanup-on-compaction_deferred.patch
memcg-add-mem_cgroup_from_css-helper.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
memcg-add-mem_cgroup_from_css-helper-fix-2.patch
mm-sparse-optimize-sparse_index_alloc.patch
mm-sparse-more-check-on-mem_section-number.patch
mm-sparse-remove-index_init_lock.patch

