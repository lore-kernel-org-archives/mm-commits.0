From: akpm@linux-foundation.org
Subject: [merged] mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:01 -0700
Message-ID: <20121009180702.3014C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:38405 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:05 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so59018eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, cl@linux.com, jwboyer@gmail.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()
has been removed from the -mm tree.  Its filename was
     mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()

cc9a6c87 ("cpuset: mm: reduce large amounts of memory barrier related
damage v3") introduced a potential memory corruption.  shmem_alloc_page()
uses a pseudo vma and it has one significant unique combination,
vma->vm_ops=NULL and vma->policy->flags & MPOL_F_SHARED.

get_vma_policy() does NOT increase a policy ref when vma->vm_ops=NULL and
mpol_cond_put() DOES decrease a policy ref when a policy has
MPOL_F_SHARED.  Therefore, when a cpuset update race occurs,
alloc_pages_vma() falls in 'goto retry_cpuset' path, decrements the
reference count and frees the policy prematurely.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma
+++ a/mm/mempolicy.c
@@ -1552,8 +1552,18 @@ struct mempolicy *get_vma_policy(struct 
 									addr);
 			if (vpol)
 				pol = vpol;
-		} else if (vma->vm_policy)
+		} else if (vma->vm_policy) {
 			pol = vma->vm_policy;
+
+			/*
+			 * shmem_alloc_page() passes MPOL_F_SHARED policy with
+			 * a pseudo vma whose vma->vm_ops=NULL. Take a reference
+			 * count on these policies which will be dropped by
+			 * mpol_cond_put() later
+			 */
+			if (mpol_needs_cond_ref(pol))
+				mpol_get(pol);
+		}
 	}
 	if (!pol)
 		pol = &default_policy;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

