Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB98264A9D
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 20:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768595550; cv=none; b=BhXLg6D/Zg/6hPC0bZAija1/OooijJICfihEkeDb1J5hMTLA53ku8gxASWTLJpVF8/bes0zeuk4wHR6SUKYDO5fC902lomC+24rOQHGbofIE3eoMTRgQT4vIiq/N4egH3aNe3b74Hf6MJ72LfKlvifxYuZPcCgH/RKBkln0cbPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768595550; c=relaxed/simple;
	bh=eMZCDwhOCYZVeOdhuV2aMhGlaGce+eRRXfcAylheFmU=;
	h=Date:To:From:Subject:Message-Id; b=oIX15b1Dg6P+TBW7E4tblysR6YCqX6P1iwtlw2j0+q9Ype6L5uZY9Uf2RNdCwveb/PA2VcucY6d0nLGAa4G2Xx6uAUuNxKSzERW5+z4y+viLQLHOfSsRiTz0wnEWDsqKt/r2XHwxGVXlY8yKdsnIdluG335zFzgalqMG9Pd5Z+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oz6MNFG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oz6MNFG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37642C116C6;
	Fri, 16 Jan 2026 20:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768595550;
	bh=eMZCDwhOCYZVeOdhuV2aMhGlaGce+eRRXfcAylheFmU=;
	h=Date:To:From:Subject:From;
	b=Oz6MNFG1jkeZiJIqnaxOxrnWNJlSSwGL47mm4jfP4/Uzuj4AtZxRqsekNfaOSS8lU
	 VfKLltvBI2/8yUI+e1lmj21poodzw5w3whgwq3+vtIbY75Y1CyKu1DzCvze605/osn
	 6ZtGE7NHGNn5+DzW3VYfIGthAvzxxSq0WiFRHnEI=
Date: Fri, 16 Jan 2026 12:32:29 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-enforce-brace-style.patch added to mm-new branch
Message-Id: <20260116203230.37642C116C6@smtp.kernel.org>
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
Date: Fri, 16 Jan 2026 14:27:16 -0500

Documentation/process/coding-style.rst explicitly notes that if only one
branch of a conditional statement is a single statement, braces should be
used in both branches.  Enforce this in mm/hugetlb.c.

While add it, fix the indentation for vma_end_reservation.

No functional change intended.

Link: https://lkml.kernel.org/r/20260116192717.1600049-2-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

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
@@ -2672,11 +2675,12 @@ void restore_reserve_on_error(struct hst
 				 * be consumed on a subsequent allocation.
 				 */
 				folio_set_hugetlb_restore_reserve(folio);
-		} else
+		} else {
 			/*
 			 * No reservation present, do nothing
 			 */
-			 vma_end_reservation(h, vma, address);
+			vma_end_reservation(h, vma, address);
+		}
 	}
 }
 
@@ -4711,10 +4715,12 @@ static void hugetlb_vm_op_open(struct vm
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

