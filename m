Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0922F12A3
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 19:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505101; cv=none; b=F/ZkUosNjfvaVhMTGaNMgZsCn/3V2A8N02mX40A3mHTLAaqIVGq0HSne86yk4mCiJkmatNjH3+YP2QdUvyHs1TCsYz7lA7KJ+tRVVuprup87AjZHC/vfvZrJN9XSELJCArfzmpkY5b7wLiL3rdWwWlkAmzjHfUfOQ8EdplMVB3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505101; c=relaxed/simple;
	bh=JhhzN1LqggsYCIDmqT8Pp4A3SPqpHgvdHgg8KCUm/1k=;
	h=Date:To:From:Subject:Message-Id; b=S8HiJ7469rdzIy0fQv/lbQLxpq2FriviqW3IRcru9wYgrr0661NyMerCEVRx/3NSILNpP7JVkFe9orAqh3SwNi/Y3pZByZxy0pMDLAKsMKf1QecYLawDD3sxkSq9Tn0HJCRfCZO0Y2ZePzzxqjXgstvAs5nmnwmpXRgxTI+4S/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dT1pIiaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dT1pIiaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D84AC116D0;
	Thu, 15 Jan 2026 19:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768505100;
	bh=JhhzN1LqggsYCIDmqT8Pp4A3SPqpHgvdHgg8KCUm/1k=;
	h=Date:To:From:Subject:From;
	b=dT1pIiafvhmIQRiGIS6x3MVKMU1kmN4N2OijHy5nSLnwPmL7mx1yxA0QZq/Fa2Ppt
	 kmoDX2dSPuNA7xBs0EpRlvKxU0veisOwJw322irIRGGfLYWhHl3InLvna7ZyRauDXq
	 HwGgNdKJFLeWR+BTZhby/GEzyIWYFYSM93rQf+KM=
Date: Thu, 15 Jan 2026 11:24:59 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,akpm@linux-foundation.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-enforce-brace-style.patch added to mm-new branch
Message-Id: <20260115192500.5D84AC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: enforce brace style
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-enforce-brace-style.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-enforce-brace-style.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/hugetlb: enforce brace style
Date: Thu, 15 Jan 2026 13:14:37 -0500

Documentation/process/coding-style.rst explicitly notes that if only one
branch of a conditional statement is a single statement, braces should
be used in both branches. Enforce this in mm/hugetlb.c.

No functional change intended.

Link: https://lkml.kernel.org/r/20260115181438.223620-4-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-enforce-brace-style
+++ a/mm/hugetlb.c
@@ -578,8 +578,9 @@ hugetlb_resv_map_add(struct resv_map *ma
 		record_hugetlb_cgroup_uncharge_info(cg, h, map, nrg);
 		list_add(&nrg->link, rg);
 		coalesce_file_region(map, nrg);
-	} else
+	} else {
 		*regions_needed += 1;
+	}
 
 	return to - from;
 }
@@ -1247,8 +1248,9 @@ void hugetlb_dup_vma_private(struct vm_a
 
 		if (vma_lock && vma_lock->vma != vma)
 			vma->vm_private_data = NULL;
-	} else
+	} else {
 		vma->vm_private_data = NULL;
+	}
 }
 
 /*
@@ -2076,8 +2078,9 @@ retry:
 				h->max_huge_pages++;
 				goto out;
 			}
-		} else
+		} else {
 			rc = 0;
+		}
 
 		update_and_free_hugetlb_folio(h, folio, false);
 		return rc;
@@ -2672,11 +2675,13 @@ void restore_reserve_on_error(struct hst
 				 * be consumed on a subsequent allocation.
 				 */
 				folio_set_hugetlb_restore_reserve(folio);
-		} else
+		} else {
 			/*
 			 * No reservation present, do nothing
 			 */
 			 vma_end_reservation(h, vma, address);
+
+		}
 	}
 }
 
@@ -4703,10 +4708,12 @@ static void hugetlb_vm_op_open(struct vm
 			if (vma_lock->vma != vma) {
 				vma->vm_private_data = NULL;
 				hugetlb_vma_lock_alloc(vma);
-			} else
+			} else {
 				pr_warn("HugeTLB: vma_lock already exists in %s.\n", __func__);
-		} else
+			}
+		} else {
 			hugetlb_vma_lock_alloc(vma);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-hugetlb-restore-failed-global-reservations-to-subpool.patch
mm-hugetlb-remove-unnecessary-if-condition.patch
mm-hugetlb-enforce-brace-style.patch

