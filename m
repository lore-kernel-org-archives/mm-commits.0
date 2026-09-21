Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B234D794D
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 21:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024689; cv=none; b=SFN0b9rvtfFlah9uzd8k8PWOF/A0htHPex4nIxGCP7zTBEMMjNirhAMdzfChf3oL8NrmU47rcJVKpVIYOU4jl6uiaNYC5+pwWk1fvJZQ5Giss25AVQyeDvvhBQ19vX1nPuXylMInTzRXjIoRU31T143JdJGid2AjdAoboUxKm1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024689; c=relaxed/simple;
	bh=7Wo6rzQA+q+REg9g46erzK8Yqrmeyw6CJOfeUjjld24=;
	h=Date:To:From:Subject:Message-Id; b=d83/JpExIRJ9z0tKrDmhu5OsU/lVtK+TfD923S4Cr5lQ84yQvmxtBJgQUmoZNJXy8jKoaG+DlLYtOF2GrnG7dkXfz9Q3qGwvG51QrkRy/rtSJHFEs1uz4Z06YIN5CVRqU9g1E3dduOFmjDzN5x7bWZQr2fwsNFHZUV+KITYH70s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/X3NXLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/X3NXLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8701F008BD;
	Mon, 21 Sep 2026 21:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790024687;
	bh=Qe4nhAEN7oLwFJ1otGi+hhoqHI9JwNJCiZZCDRLDQx8=;
	h=Date:To:From:Subject;
	b=x/X3NXLDX05IFIQJin6WCyo/RMqF3ov4nJ8WK/W3yR/qcvhfXHH15LSR0psAu+lCI
	 /rS08BmCKYNHl8N4tcdJFD9CBcsyYzxyB0827ZOge1Lku4qpl9aqv7pJ/oQ5aX5oHj
	 s0HP9uS4wEnAw/cH/YdBik8KJlflyyzVPDnp7eGE=
Date: Mon, 21 Sep 2026 14:04:47 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches.patch added to mm-new branch
Message-Id: <20260921210447.6C8701F008BD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: scan the struct page array in MAX_SCAN_SIZE batches
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches.patch

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
Subject: mm: kmemleak: scan the struct page array in MAX_SCAN_SIZE batches
Date: Mon, 21 Sep 2026 05:30:27 -0700

scan_zone_pages() scans the struct page array one page per scan_block()
call:

	if (scan_block(page, page + 1, NULL))

scan_block() takes kmemleak_lock with interrupts disabled for the
duration of the call, so this acquires the lock once per online PFN to
scan a single struct page.

Gather runs of adjacent eligible struct pages and pass each run to
scan_block() in one call, capped at MAX_SCAN_SIZE.

The longest kmemleak_lock is now held is MAX_SCAN_SIZE worth of words,
the same bound scan_large_block() already applies to the data sections
and the per-CPU areas.

This can make the scan faster. On an arm64 VM with 24 GiB and ~17 GiB
in use, the struct page phase goes from 4390k scan_block() calls down
to 69k for the same 4390k pages scanned, and the whole scan about 20%
faster (on debug kernel). The win is in the per-acquisition cost, so on
a kernel built without the lock debugging options the scan time is
unchanged. I don't think it will be a problem doing more on
scan_block(), given we have the scan_should_stop() protection.

Coverage is unchanged: a temporary assertion comparing the number of
eligible pages against the number actually passed to scan_block()
matched on every zone of every scan, including while memory was being
freed underneath the scan.

Link: https://lore.kernel.org/20260921-b4-kmemleak-page-scan-v1-2-fb97d4801b3a@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---

 mm/kmemleak.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches
+++ a/mm/kmemleak.c
@@ -1862,8 +1862,11 @@ static void dedup_flush(struct xarray *d
  */
 static int scan_zone_pages(struct zone *zone)
 {
+	const unsigned int max_batch = MAX_SCAN_SIZE / sizeof(struct page);
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
+	struct page *first = NULL, *last = NULL;
+	unsigned int batch = 0;
 	unsigned long pfn;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
@@ -1872,19 +1875,29 @@ static int scan_zone_pages(struct zone *
 		if (!(pfn & 63))
 			cond_resched_tasks_rcu_qs();
 
-		if (!page)
-			continue;
+		/* only scan in-use pages belonging to this zone */
+		if (page && (page_zone(page) != zone ||
+			     page_count(page) == 0))
+			page = NULL;
 
-		/* only scan pages belonging to this zone */
-		if (page_zone(page) != zone)
-			continue;
-		/* only scan if page is in use */
-		if (page_count(page) == 0)
+		if (page && first && page == last + 1 &&
+		    batch < max_batch) {
+			last = page;
+			batch++;
 			continue;
-		if (scan_block(page, page + 1, NULL))
+		}
+
+		if (first && scan_block(first, last + 1, NULL))
 			return 1;
+
+		first = page;
+		last = page;
+		batch = page ? 1 : 0;
 	}
 
+	if (first && scan_block(first, last + 1, NULL))
+		return 1;
+
 	return 0;
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

