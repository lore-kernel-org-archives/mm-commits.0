Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1426C2EA
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298483; cv=none; b=crMAnBJh4GdWVn8gYYqEbZVZejv7ReGc+dA4OhrVZBEFWD5Go+/SQznPixUGqAkjklLY3/TL81LkcnpyuQ0wj6qTeLPu2PPAR7qElkMn+cw2sAPD51RUUQB3Uj357m/icMmjznmGzn9NOiLRGiOiyjjY8fY0RZrJPVZDnN5nJQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298483; c=relaxed/simple;
	bh=PRceGwr6OCY5UebUwTPt7Xgl1aVJFkTj+8QUrYVU1mY=;
	h=Date:To:From:Subject:Message-Id; b=KvuqcKphJ9eikvWTyGM+6aN6xPZz9vJKjy2o8OSrQOvTrNBtF3AGBJDMx6Q2cVnU2vVknSOhElWfsL/Xw4HahqGFecefjJJ7a09PZ5Vz3g1T0BVQURvZBsdBMv2fs1HIpCEn5B2q62vFEgLujB1U7lc4hjTeO3dj20aTam38Ys4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cQF40Ncs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cQF40Ncs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62121F00A3A;
	Wed, 29 Jul 2026 04:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298481;
	bh=NcSxB24eOvn5/eXWLnDIb/Dy960lscYXHJsl0KycymA=;
	h=Date:To:From:Subject;
	b=cQF40Ncs8+Ou2YuMoCpvmdLFoGmYs9rvK8fwQV2P4qVCUBGOwa4Y2AnMqiNRsvC3g
	 XpfZqa/v+kSJ+turDB2KR+xWl5Nvm97lYMnUNoBySxrSIQThZyLoiVS3+rocMRf2sl
	 ZwiBBpKzqCZUFgZUbkRl7kp9YufGTdtpefi6lu6s=
Date: Tue, 28 Jul 2026 21:14:41 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch removed from -mm tree
Message-Id: <20260729041441.B62121F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: skip the remaining scan phases when interrupted
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/kmemleak: skip the remaining scan phases when interrupted
Date: Fri, 26 Jun 2026 10:56:23 -0700

kmemleak_scan() scans the per-cpu sections, the struct page ranges and the
task stacks in sequence.  Each loop now bails out once scan_block()
reports the scan was interrupted, but the later phases are still entered
and only bail on their first scan_block() call.

Jump straight to the gray list scan once a phase reports an interrupted
scan, so the remaining scan phases are not entered at all.  This does not
change the scan results, it only avoids the pointless re-entry.

Link: https://lore.kernel.org/20260626-kmemleak_improve-v1-1-d40c7616f64f@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted
+++ a/mm/kmemleak.c
@@ -1851,6 +1851,7 @@ static void kmemleak_scan(void)
 	int __maybe_unused i;
 	struct xarray dedup;
 	int new_leaks = 0;
+	int stop = 0;
 
 	jiffies_last_scan = jiffies;
 
@@ -1897,7 +1898,7 @@ static void kmemleak_scan(void)
 	for_each_possible_cpu(i) {
 		if (scan_large_block(__per_cpu_start + per_cpu_offset(i),
 				     __per_cpu_end + per_cpu_offset(i)))
-			break;
+			goto scan_gray;
 	}
 #endif
 
@@ -1909,7 +1910,6 @@ static void kmemleak_scan(void)
 		unsigned long start_pfn = zone->zone_start_pfn;
 		unsigned long end_pfn = zone_end_pfn(zone);
 		unsigned long pfn;
-		int stop = 0;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 			struct page *page = pfn_to_online_page(pfn);
@@ -1934,6 +1934,8 @@ static void kmemleak_scan(void)
 			break;
 	}
 	put_online_mems();
+	if (stop)
+		goto scan_gray;
 
 	/*
 	 * Scanning the task stacks (may introduce false negatives).
@@ -1945,6 +1947,7 @@ static void kmemleak_scan(void)
 	 * Scan the objects already referenced from the sections scanned
 	 * above.
 	 */
+scan_gray:
 	scan_gray_list();
 
 	/*
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

