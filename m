Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DA020CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898294; cv=none; b=ERz5ZEJ/wyaqxOZCvPalDW54zkd1RskHtA5vf1uf1mYIkQbapCOIsQbeRFJdwrEaw/t2A5Cv5Pls7j1LzAOaklPQSeK5ZR2P7Xw1hKIMQqgdLmU38YdDcp5RNgwu8TUuh++808j1ra/+wIXCj9OHybceKufAPL65jYroIhNu76I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898294; c=relaxed/simple;
	bh=K7copoPEvNj5le6SX3oRP+pC3Zncaf7Khro9MVa76LE=;
	h=Date:To:From:Subject:Message-Id; b=W3ZLQIdiqWYUfDpwoWiSPmLjniG0btLN/B/NllMDr9CKIK3IsiKTNa5qLIhEISbZUeT65txofQAfq1qIRSTgY9rboYYlYlAKn/aZ6+sc5RdeFXwxBlkZkRFMBPwv6d2NUTlNi8gznX88lxqtfUtmyvwFksEDWT4qh0blRsIuduM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k6Qttgir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k6Qttgir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624FCC4CEF1;
	Sat, 31 Jan 2026 22:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898294;
	bh=K7copoPEvNj5le6SX3oRP+pC3Zncaf7Khro9MVa76LE=;
	h=Date:To:From:Subject:From;
	b=k6QttgirJLQAALfu2fHMJok9Wimct/GzvsrD+KrlPDf19krD01CF0e9m8wVUWhXZL
	 Mffh9DxfFMsMXhtkppvbcAxyq0wNExNpihXVTZDte5mA9ezy6M9rd4AFO/sUtP7bqM
	 ZfaiGG57mk3t53x9JtvFljIyqqOGsufAHF9M7km8=
Date: Sat, 31 Jan 2026 14:24:53 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-enforce-brace-style.patch removed from -mm tree
Message-Id: <20260131222454.624FCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: enforce brace style
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-enforce-brace-style.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
 
@@ -4672,10 +4676,12 @@ static void hugetlb_vm_op_open(struct vm
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

