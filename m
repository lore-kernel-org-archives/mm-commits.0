Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07DF486BAB
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866055; cv=none; b=tediLwAr3/vrv4ieU8DdHghM/EH0e/+iAccxMYag7qZDaHZLkve5vWKfiCefH5AJt0DJRm+muTIriTmvjdtzHvt0FSkLs+zwTGFGZsPNclC6SbrvIaqyQ2NhG4mjcKb0e/PwqV/O5GloYvkSk0vxvrfKDmDdWcFQxgBJ3gWLAIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866055; c=relaxed/simple;
	bh=OfvLcdchSmi2uaIkbzhCENdvOAZfV6Mo3p+Z59aKLwc=;
	h=Date:To:From:Subject:Message-Id; b=h8Q/U9zpG3Z6cHETkZ9RJifYIs8w4wPkvv1p0TUsepkZKqJEIHK/G0rkytS4FmtB0MQ3rfsFAaodxkRSzDUDIRuG+oKfyd4GmNOEqTXVJNnmWkdxbJ9bgblCpu7cWkYbN8SXARqCJYdRO5qPq0qsd6FxPmzI/UYzKXbHdPDt/w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIJEt86j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIJEt86j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0E21F00899;
	Tue, 13 Oct 2026 04:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866052;
	bh=USGrxwpiweXk+LjtbtxjJKqgFH8FgifUwZOnnAIJw1o=;
	h=Date:To:From:Subject;
	b=cIJEt86j9DqOdPSHpOMVC/80xgZEzGgIe0iXNqS2i6OptfnSVQUXRk2ME0m1vcfxN
	 Umh6/LZKavqKDkghKSj5RKW9VVjSefKITop3qdNc5T0sZ6CK+xL6uBxr5Cj8htxwqy
	 mNVBfmsECEpFdU2NWbNvCU46H6JaE9LoshihILkQ=
Date: Mon, 12 Oct 2026 21:34:11 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches.patch removed from -mm tree
Message-Id: <20261013043412.2F0E21F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: scan the struct page array in MAX_SCAN_SIZE batches
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

The longest kmemleak_lock hold duration is now MAX_SCAN_SIZE worth of
bytes.  The same bound scan_large_block() already applies to the data
sections and the per-CPU areas.

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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
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


