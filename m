Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546C948551E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866057; cv=none; b=LKaGW+AO0fPHp+T4YtNQXfu/a5/AMYx1hoAlN2Rohyu2bSrOWHu2JrimnZexYNCYcNqeN58HTigEtSuOYGJUL/cUSq55/Ki/vu/7Z6uUTyeDL0lV0VBJqcg4W4w2vt3dM9UtPVLZ7ccJFUD/jtKWYxWkPJdZfImJPlLwjsxJ5Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866057; c=relaxed/simple;
	bh=pMxQisfOm6Wx9qw6N+JtKgYsSLI5FN678Jwf10//PUQ=;
	h=Date:To:From:Subject:Message-Id; b=g8EKDzuTETe4QrVez1YkuvYx6u1Dv1CocHQNax+Na+Nsas/6UKy/AhlvyP/h1Zlu9g9a+b4z9Z8VNL5kIBR4h7kncXIkal/TTFt2kz8jaysIFcjtS/GLEWzOLqrHBtiIieM5ycOe37kNFZ6tVxm9hAg38kQ6OsLrWFWQKaX8w44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YVp/uK3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YVp/uK3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226011F000FF;
	Tue, 13 Oct 2026 04:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866051;
	bh=GIoe0SXEKWDKzme2y9Lpo/Kpe3GJoWv0sQYf3NQDRFs=;
	h=Date:To:From:Subject;
	b=YVp/uK3UGHAIRsv/i/JQAEAK6Kz/R/hHl9EKZZt3JEdkmoSroLT1ZfQ75dTRiyNaB
	 kk7G2qDunbpcQiggHRa3xPsvOHsEpLrAiRuMrMWK7bR/EYjEOWQGX1wCxz1FUQ3hb8
	 VeIMzfiqW62+H8a7ZSTMMHPV31f22mz4sIUSWbTY=
Date: Mon, 12 Oct 2026 21:34:10 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-move-the-struct-page-scan-into-a-helper.patch removed from -mm tree
Message-Id: <20261013043411.226011F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: move the struct page scan into a helper
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-move-the-struct-page-scan-into-a-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
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


