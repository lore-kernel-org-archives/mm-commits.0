Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E62D3DFC6A
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 21:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024687; cv=none; b=lzXZoLsjsXMAmLL/+1WQcCIo8h9Cf35dVRbwRd/fHG+R+oz8Vqtlzf8FsMOeDjNbuumNsb2c161BMpqKO8RW43YnWnUWdtY9DPIK/KOkfiSrgH/WREXd2e8zGuaHjotjL04t4oE/aVvNzOXJ+wAEUEzQq9MCAAX+DRHaybz5f6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024687; c=relaxed/simple;
	bh=0XbDfflWMB/2kOCODvjz9gyDg4BY2Iro++8zz5VNijo=;
	h=Date:To:From:Subject:Message-Id; b=Dr118HLju/6GIxLkMGyGi0v4xMwStkzeDPhxasovQvlcYtJEnfuOUQWB5bIF+Qxi84gLZwnn14zm39z0fXSv9pfSowAJteNST4ag2GFpTRh8AHazmsqKACrT5VHiT3AgHYFEJ4kX7X8KYj9qXP9XAf30eqmzaGZymXfSMLYomwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XHopfMJ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XHopfMJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFA31F008AB;
	Mon, 21 Sep 2026 21:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790024685;
	bh=LVZVjuLceXAsVmHIvlY3CC3nUgauTsbPik1caTtFVp4=;
	h=Date:To:From:Subject;
	b=XHopfMJ6ycalvh5qf8X8nJfABGhNcKu8A+NfikInuHb+ZvZg03oq/Q7pHfrVJXB3F
	 ZieZLVkZr15pcPdF0fBLsPVEVpS2KcVJMzi5AjdYgal9AGy9yDkAUE+3BbEEYRGkoz
	 xp5ulSmr1cnlAwthxjDPFVR9OpVE+IAcxTiXN0N4=
Date: Mon, 21 Sep 2026 14:04:45 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-move-the-struct-page-scan-into-a-helper.patch added to mm-new branch
Message-Id: <20260921210445.7AFA31F008AB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: move the struct page scan into a helper
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-move-the-struct-page-scan-into-a-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-move-the-struct-page-scan-into-a-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: kmemleak: move the struct page scan into a helper
Date: Mon, 21 Sep 2026 05:30:26 -0700

Patch series "mm: kmemleak: batch the struct page scan".

kmemleak walks the struct page array as a scan root and hands it to
scan_block() one page at a time.

scan_block() takes kmemleak_lock with interrupts disabled for the duration
of the call, so the scanner acquires the lock once per online PFN in order
to look at a single 64-byte struct page.

Batching adjacent pages up to that size keeps exactly the same pages under
the same maximum lock hold time, with MAX_SCAN_SIZE / pagesize fewer
acquisitions.

Patch 1 lifts the loop out of __kmemleak_scan() into scan_zone_pages()
with no functional change.  Patch 2 does the batching, which is then
contained in that one function.

This improves the performance due to less atomic operations, which is not
a big deal on a regular machine, but, given kmemleak usually comes with
extra debug options, such as PROVE_LOCKING, DEBUG_SPINLOCK, etc.

For instance, measuring Meta's "debug kernel flavor" on an arm64 hosts,
this improve the scan time by 20%.

It is safe to get more work into scan_block(), given it has the
protections, added by commit eb11f56eeca560 ("mm/kmemleak: stop the task
stack scan early when interrupted")

MAX_SCAN_SIZE is also not a new maximum for a single scan_block() call. 
kmemleak_scan_task_stacks() already hands it a whole task stack in one go.
On arm64 and x86_64 THREAD_SIZE is never below 16 KiB, four times
MAX_SCAN_SIZE, and it is 64 KiB on arm64 with 64K pages.


This patch (of 2):

The struct page scanning loop sits inline in __kmemleak_scan(), nested
three levels deep and sharing the caller's "stop" variable with the
zone walk around it. Move it into scan_zone_pages(), which scans one
zone and returns 1 if scanning should stop.

No functional change; this only makes room for changing how the pages
are handed to scan_block().

Link: https://lore.kernel.org/20260921-b4-kmemleak-page-scan-v1-1-fb97d4801b3a@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---

 mm/kmemleak.c |   57 ++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-move-the-struct-page-scan-into-a-helper
+++ a/mm/kmemleak.c
@@ -1856,6 +1856,39 @@ static void dedup_flush(struct xarray *d
 }
 
 /*
+ * Scan the struct pages of a zone, skipping memory holes, pages that belong to
+ * another zone and pages that are not in use. Returns 1 if the scan should be
+ * stopped.
+ */
+static int scan_zone_pages(struct zone *zone)
+{
+	unsigned long start_pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = zone_end_pfn(zone);
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_online_page(pfn);
+
+		if (!(pfn & 63))
+			cond_resched_tasks_rcu_qs();
+
+		if (!page)
+			continue;
+
+		/* only scan pages belonging to this zone */
+		if (page_zone(page) != zone)
+			continue;
+		/* only scan if page is in use */
+		if (page_count(page) == 0)
+			continue;
+		if (scan_block(page, page + 1, NULL))
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
  * Scan data sections and all the referenced memory blocks allocated via the
  * kernel's standard allocators. This function must be called with the
  * scan_mutex held.
@@ -1928,29 +1961,7 @@ static int __kmemleak_scan(bool full)
 	 */
 	get_online_mems();
 	for_each_populated_zone(zone) {
-		unsigned long start_pfn = zone->zone_start_pfn;
-		unsigned long end_pfn = zone_end_pfn(zone);
-		unsigned long pfn;
-
-		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-			struct page *page = pfn_to_online_page(pfn);
-
-			if (!(pfn & 63))
-				cond_resched_tasks_rcu_qs();
-
-			if (!page)
-				continue;
-
-			/* only scan pages belonging to this zone */
-			if (page_zone(page) != zone)
-				continue;
-			/* only scan if page is in use */
-			if (page_count(page) == 0)
-				continue;
-			stop = scan_block(page, page + 1, NULL);
-			if (stop)
-				break;
-		}
+		stop = scan_zone_pages(zone);
 		if (stop)
 			break;
 	}
_

Patches currently in -mm which might be from leitao@debian.org are

mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch
mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch
documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch
documentation-kmemleak-fix-stale-statements-about-scanning.patch
mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch
mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch
mm-kmemleak-move-the-struct-page-scan-into-a-helper.patch
mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches.patch

