Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DBA286D7D
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 04:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782361778; cv=none; b=XGSRT8vw7Vmmn7rVXdZRaqsLEmr28dDpJrn/FePyaVnc4IPAholP8f2JPECSTTnT0Gx0ZPUnv6pb/SQuIeEyzNutOmNoZABvv0UlqFiarKGEwGbd9HrkRdAarbJzrKOWzEFIhsqG9iLBzhgmLuAT13FTr7gnOCXH1vY6TQHaZaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782361778; c=relaxed/simple;
	bh=x5rjbBbiz3KNk0NYuLoMUPqDq8SmUKEumm0IRFsLP48=;
	h=Date:To:From:Subject:Message-Id; b=gf98F+ePQg42bD1sGlDRYXxhkxhorb8GGRpVxNFf9u4F+Lwp7qsPB4WvwEEXNa4ePs2ovjVEMFb8ideqnctrn1AGNmVP6+o99x7vVpY6bvJQlk9E+2R/cjt6dtSJuq9qV672c5MnT5ZbrYvZMWix9zDAyd5YPGW2fDSTgA35x5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A7exWDnL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A7exWDnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805711F000E9;
	Thu, 25 Jun 2026 04:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782361776;
	bh=Xf3nWj1TWxBFdjwYcQzCnVhGtqEInvlLze6+A5wH/IM=;
	h=Date:To:From:Subject;
	b=A7exWDnLy2LbP0LuWxes/W5maR7X3gVLWi6bvShIoVx7z8PuOFUwONCic50efK4TQ
	 MWUpMnV0vOAJ0M2eoEM5/g2WWVOy6ZZrH2x+ESLDTUAiHqL3WO7NlUyyXvFrI0r5+u
	 qbaVzncm+HesSWYYgtxosuupyfL3cPsEOxhF9yRw=
Date: Wed, 24 Jun 2026 21:29:36 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,oleg@redhat.com,lance.yang@linux.dev,dave@stgolabs.net,catalin.marinas@arm.com,cai@lca.pw,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch added to mm-new branch
Message-Id: <20260625042936.805711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: stop the per-cpu and struct page scans early too
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch

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
@@ -1558,18 +1558,22 @@ static int scan_block(void *_start, void
 
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
 
@@ -1889,9 +1893,11 @@ static void kmemleak_scan(void)
 
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
@@ -1902,6 +1908,7 @@ static void kmemleak_scan(void)
 		unsigned long start_pfn = zone->zone_start_pfn;
 		unsigned long end_pfn = zone_end_pfn(zone);
 		unsigned long pfn;
+		int stop = 0;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 			struct page *page = pfn_to_online_page(pfn);
@@ -1918,8 +1925,12 @@ static void kmemleak_scan(void)
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

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch

