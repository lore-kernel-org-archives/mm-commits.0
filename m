Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCFE4BD7A9
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598946; cv=none; b=uCvY4OpVSQ0ygLI8nteZRGRUASCqFPiT0vELJZxuXBYK/t0u3tKfC557z2a1njurbHYlEWvFGUT4jkU4F7OKLPt6KeI7PX1Gt1Qd2wWZroGMIQ5BfoOaqAInDo5s3iUqnJ293u7EQfkfm7z/whCqY05JEcVGeipcF+n8hpISu4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598946; c=relaxed/simple;
	bh=UIBR1MZP84YaTi6eZBtRLr0Yz2eIErfP188O1Xf32xk=;
	h=Date:To:From:Subject:Message-Id; b=UTBGAbs8DQkUbHthrq4Hj/4MFCpy/g84kpmX1/PoQlVoERKbUQdQ+OoJAW77JSq1O2jigzWycCKuPGEzDQUGdtFE473PJWETNQjZKz/p6V/0i47O8O0GNsHRWX5gutS4y1eTXS50BhnSwHS0Tt3R+hFRlfOnPSwMFceTwnAGHhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1/2Pizxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1/2Pizxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BACB1F00893;
	Wed, 16 Sep 2026 22:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598939;
	bh=hU1yKmoSf7orYvLa/RwnPqqi0I47WW8YGsOdINgFlVQ=;
	h=Date:To:From:Subject;
	b=1/2PizxngTa4JIN7cLvyiVXC1OT79oemgTvaMGeVbHKEweajU4LzKDzvjetCRbzSf
	 A8aBnHuiyDDSTCIoc0TIfFBE0tFH0PaDlU7+cVlnd2Xg063R5Hi3Vt/MKtAQQYx8vR
	 Mln6uz4LgesTxNVlRzyphMLV3MN7s3E2vDyVvhuc=
Date: Wed, 16 Sep 2026 15:48:58 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch added to mm-unstable branch
Message-Id: <20260916224859.3BACB1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: name the per-table scan reset for what it resets
has been added to the -mm mm-unstable branch.  Its filename is
     mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: name the per-table scan reset for what it resets
Date: Wed, 16 Sep 2026 10:31:34 +0100

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init and release, run once each
for a whole series of scans.  Two names a word apart would then stand for
two different jobs.

No functional change.

Assisted-by: LLM
Link: https://lore.kernel.org/20260916093145.4022188-8-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/khugepaged.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-collapse-name-the-per-table-scan-reset-for-what-it-resets
+++ a/mm/khugepaged.c
@@ -550,7 +550,7 @@ void __khugepaged_exit(struct mm_struct
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_scan_reset(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
@@ -1579,7 +1579,7 @@ static enum scan_result collapse_scan_pm
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2650,7 +2650,7 @@ static enum scan_result collapse_scan_fi
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

