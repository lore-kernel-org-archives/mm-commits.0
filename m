Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BA5013B8
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 21:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632266; cv=none; b=ONbTy3grgIeaOlJEZwNSMuHCXEBDKSxGpUnpSjRVaFhSqLGnGP/ZGQssefkAr2aXp0rgEA68A8ZgnS/SboyrXeiTlYYIahqhzvvQnJ8EIRcv2ITMcLfpURMWw4GiY5eDuNOcedq7tFxcV6nNSXXJB/GKDOlIumnomUtciEj523M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632266; c=relaxed/simple;
	bh=EMItiXvlfnzjDoS2T3UDcLGkHog90qa/qJ75lTyBDvU=;
	h=Date:To:From:Subject:Message-Id; b=WnWjJgL62r6dll+WwijjcysAY9XbhskYb1iKX9jhgv9rCA/e5omUJI/1PIqzo3CgTWH9rY1F8Sg5ajNqmg+1aJHWyO/vnUFMt/B21t9cW246E0ET4ThrGvtLF03D4g6kNQVZm7UKaVScNVzib6ame4icXPQraR3aJtfjsxIAoXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fr6aUCVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fr6aUCVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177871F000FF;
	Mon, 28 Sep 2026 21:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632264;
	bh=XUIcRkqXK85dnWvBtDX90HP13V5hdS5B7zZxKrwagmo=;
	h=Date:To:From:Subject;
	b=fr6aUCVj9IYGtdsiFLYQFqLAu3m7I9wWLkR6y11DOaFNUXk8pSNwD08CxgBEB7WNn
	 Fn+Y9JUfoYuZX2qwl9ELaFR6RdyonlOwGgS3O3RxCeNUp396bGXqedzJxk4cwe4zPl
	 4FSHvTvqAGsg7G4UixiyN03afCX4x9Ntpm5L6HBg=
Date: Mon, 28 Sep 2026 14:51:03 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch removed from -mm tree
Message-Id: <20260928215104.177871F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/collapse: name the per-table scan reset for what it resets
has been removed from the -mm tree.  Its filename was
     mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch

This patch was dropped because an updated version will be issued

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

Link: https://lore.kernel.org/20260916093145.4022188-8-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
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
@@ -1609,7 +1609,7 @@ static enum scan_result collapse_scan_pm
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2680,7 +2680,7 @@ static enum scan_result collapse_scan_fi
 
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
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

