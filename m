Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A7390CAE
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298408; cv=none; b=dawIGfbE9MIQwVG58GwMLW/B0kr3ikjyGWXhDM9sals7mgXQNV99BAPznD3uRKAeNaVi9v/x2ebPuuVR6zRD+mjD10PUWF7xNwn/uTX9m4d3lFH3hPeMFTDaco1FvqeLorYxk3zdJY5rp7sTEYhV95dZdlkl+c2TzCzv29tDksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298408; c=relaxed/simple;
	bh=KID2viy6HI2HrxL/wbfiImZRbIID7DcriZr57okK7YY=;
	h=Date:To:From:Subject:Message-Id; b=eexy6EBvhlx4d2lm40FolBSpQu8uu0ifoIvybDnzO8NBowQtM86JDGRGHBxD0cGoVwuON/jLBCVoYjYQMphr/xEv8eL6FOqKTN/Fy4q3ZPvv2Rvq6pkUMM5+Gtwz3YFOljeZWNadNvUAQN2egE/tGFkw8vMjoQwvwtL7vIkA6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qHTacFEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qHTacFEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADB81F00A3A;
	Wed, 29 Jul 2026 04:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298406;
	bh=taU0hXVJnlkVqYkzRq55W0CQWTz/VoC2g2vZ5vCGhSY=;
	h=Date:To:From:Subject;
	b=qHTacFEPV/5YUot8b6RZn9U6J6u71p1PKwTeWHBjptrS6pyfNul5MrapP00RJJ4JG
	 eXVRIc9St3qyrkLs6W6luZBnYUs7rWkYwtket7rwGved+fvvexbrfaZ08ACOs05ECm
	 ZofC8nCN18ECXAtoMYPGDoANR6YbMQO0H38Isg3c=
Date: Tue, 28 Jul 2026 21:13:26 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,oleg@redhat.com,lance.yang@linux.dev,dave@stgolabs.net,catalin.marinas@arm.com,cai@lca.pw,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch removed from -mm tree
Message-Id: <20260729041326.AADB81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: stop the per-cpu and struct page scans early too
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/kmemleak: stop the per-cpu and struct page scans early too
Date: Mon, 15 Jun 2026 10:49:08 -0700

The per-cpu and struct page scan loops have no reschedule-stop check of
their own: once a scan is interrupted they keep calling scan_block() for
every remaining block, which scans nothing useful.

Propagate scan_block()'s interrupted status through scan_large_block() and
break both loops as soon as it is set.

Link: https://lore.kernel.org/20260615-kmemleak-stack-resched-v3-3-acecd7d7fd92@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qian Cai <cai@lca.pw>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too
+++ a/mm/kmemleak.c
@@ -1559,18 +1559,22 @@ static int scan_block(void *_start, void
 
 /*
  * Scan a large memory block in MAX_SCAN_SIZE chunks to reduce the latency.
+ * Return non-zero if the scan was interrupted.
  */
 #ifdef CONFIG_SMP
-static void scan_large_block(void *start, void *end)
+static int scan_large_block(void *start, void *end)
 {
 	void *next;
 
 	while (start < end) {
 		next = min(start + MAX_SCAN_SIZE, end);
-		scan_block(start, next, NULL);
+		if (scan_block(start, next, NULL))
+			return 1;
 		start = next;
 		cond_resched();
 	}
+
+	return 0;
 }
 #endif
 
@@ -1890,9 +1894,11 @@ static void kmemleak_scan(void)
 
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */
-	for_each_possible_cpu(i)
-		scan_large_block(__per_cpu_start + per_cpu_offset(i),
-				 __per_cpu_end + per_cpu_offset(i));
+	for_each_possible_cpu(i) {
+		if (scan_large_block(__per_cpu_start + per_cpu_offset(i),
+				     __per_cpu_end + per_cpu_offset(i)))
+			break;
+	}
 #endif
 
 	/*
@@ -1903,6 +1909,7 @@ static void kmemleak_scan(void)
 		unsigned long start_pfn = zone->zone_start_pfn;
 		unsigned long end_pfn = zone_end_pfn(zone);
 		unsigned long pfn;
+		int stop = 0;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 			struct page *page = pfn_to_online_page(pfn);
@@ -1919,8 +1926,12 @@ static void kmemleak_scan(void)
 			/* only scan if page is in use */
 			if (page_count(page) == 0)
 				continue;
-			scan_block(page, page + 1, NULL);
+			stop = scan_block(page, page + 1, NULL);
+			if (stop)
+				break;
 		}
+		if (stop)
+			break;
 	}
 	put_online_mems();
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch

