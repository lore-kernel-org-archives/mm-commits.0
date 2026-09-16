Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057DD4A7CAE
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598543; cv=none; b=qYSATex2UbvIDa0mQCyTkoTw00aNcURvtrSvC02yY3YL3Uk8GHmDGAXf601HZYcOQUpHPuSGb1Th7txhb22LozuVSh5QfXXRdgFbtprNE+La3yjOkmUFV1HyrBKBwYCyTYmyCP0SF37Ujo69Qz9eJ20pQouQIHAvr3JDKXuhK8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598543; c=relaxed/simple;
	bh=h0TGK4D9t4F6wZmRT2lEgdFm+cMQAbL+WnouyncctPs=;
	h=Date:To:From:Subject:Message-Id; b=vFHiY5cqJ+qO+5Kw+XZivan4X5Y3dZNmXWgmQpNtGh7GdO2mW4fCj43WZxPzLAm3UBYGNNxv2VonC5LfRKPrQF5PuWtlwdYWY8OcfPm+8ug0vUxAbAHgxpOjJXsvmFqjX5KQFbHWKhKsptbM0rl5WMb2GkJfcobi3qJv1U2cTAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lrv77Fz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lrv77Fz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EC91F0089B;
	Wed, 16 Sep 2026 22:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598523;
	bh=v1/blOar9BD3NONc6u7rixxhr7YuDnjpXklr1ATvQ2s=;
	h=Date:To:From:Subject;
	b=lrv77Fz0rswigJwMhl3FjEK/swn8awejcNM/Yn4Y5m2YB9p41tVbxpZ/tDZbPQTH2
	 bshly4E+CFF98CP4qjrSEZiBUd+/xPl32ajyZsbXnRy8B+m58jPeOB5VykZDC5Q5IO
	 rDubf8/dtRkN4rN0m1VsEezrdDTObdLVnH29UFvg=
Date: Wed, 16 Sep 2026 15:42:02 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch removed from -mm tree
Message-Id: <20260916224203.05EC91F0089B@smtp.kernel.org>
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
Date: Thu, 10 Sep 2026 13:02:27 +0100

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
Link: https://lore.kernel.org/20260910120238.2529819-8-kirill@shutemov.name
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
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
a.patch

