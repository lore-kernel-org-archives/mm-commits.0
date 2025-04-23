Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4EB13C81B
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745444976; cv=none; b=X8BFAdBZmKgin0h/tkGbF9F8dw1e/jMZ0RyT+B1eKMfUNI9NjOQxAC5eW9G6rQKsfn3QGCy6DkmYG9gs9q1MmCV2RDPIiPd7R0HwZkHG0FkyyNtD+WwHRZdqummxjadOwUpyV4tl+Vsvo5+/M8M4Kx6/qVKfY0L1Od0IAePlH5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745444976; c=relaxed/simple;
	bh=xczgdDtcWAfi6ywfaxjFo0RSiUGrW3P7JGv13+oWZyM=;
	h=Date:To:From:Subject:Message-Id; b=N3iqNMHuYOXa3Z7HUyhD+cxz1POyWjX9W8CpkPTTgFPDWKBYFUV4qNjNdzVIZ8epa5ASfEjTj15laEJMC3YPzFJEj2Y+LPgvIeiHYupdnLk3+TA3/6kpiHPTDkwXr3hUpDhgpULn4IKslETqiz6TZxz7sqdRrCOmi7mgJNUYbyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=snZdw3wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="snZdw3wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57660C4CEE2;
	Wed, 23 Apr 2025 21:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745444975;
	bh=xczgdDtcWAfi6ywfaxjFo0RSiUGrW3P7JGv13+oWZyM=;
	h=Date:To:From:Subject:From;
	b=snZdw3wvFPTSi5hbpgz6cDzGnqZoRmTnM9cGTEO1e6JJSkR6sNaos1Go0oAXk8ALm
	 QjhXakV7uZSs7sUiUxNOKlkPyC7bKfmvhWkoW7IuYUhymSrIO5r0dN/IJglgbU/gxh
	 PcgvXx6QAKwTEyw86kKbX41PlYJ0ufDCFRVDcu6g=
Date: Wed, 23 Apr 2025 14:49:34 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch added to mm-new branch
Message-Id: <20250423214935.57660C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, PM: use for_each_valid_pfn() in kernel/power/snapshot.c
has been added to the -mm mm-new branch.  Its filename is
     mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm, PM: use for_each_valid_pfn() in kernel/power/snapshot.c
Date: Wed, 23 Apr 2025 14:33:40 +0100

Link: https://lkml.kernel.org/r/20250423133821.789413-5-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |   44 ++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

--- a/kernel/power/snapshot.c~mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc
+++ a/kernel/power/snapshot.c
@@ -1094,16 +1094,15 @@ static void mark_nosave_pages(struct mem
 			 ((unsigned long long) region->end_pfn << PAGE_SHIFT)
 				- 1);
 
-		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
-			if (pfn_valid(pfn)) {
-				/*
-				 * It is safe to ignore the result of
-				 * mem_bm_set_bit_check() here, since we won't
-				 * touch the PFNs for which the error is
-				 * returned anyway.
-				 */
-				mem_bm_set_bit_check(bm, pfn);
-			}
+		for_each_valid_pfn(pfn, region->start_pfn, region->end_pfn) {
+			/*
+			 * It is safe to ignore the result of
+			 * mem_bm_set_bit_check() here, since we won't
+			 * touch the PFNs for which the error is
+			 * returned anyway.
+			 */
+			mem_bm_set_bit_check(bm, pfn);
+		}
 	}
 }
 
@@ -1255,22 +1254,21 @@ static void mark_free_pages(struct zone
 	spin_lock_irqsave(&zone->lock, flags);
 
 	max_zone_pfn = zone_end_pfn(zone);
-	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
-		if (pfn_valid(pfn)) {
-			page = pfn_to_page(pfn);
-
-			if (!--page_count) {
-				touch_nmi_watchdog();
-				page_count = WD_PAGE_COUNT;
-			}
-
-			if (page_zone(page) != zone)
-				continue;
+	for_each_valid_pfn(pfn, zone->zone_start_pfn, max_zone_pfn) {
+		page = pfn_to_page(pfn);
 
-			if (!swsusp_page_is_forbidden(page))
-				swsusp_unset_page_free(page);
+		if (!--page_count) {
+			touch_nmi_watchdog();
+			page_count = WD_PAGE_COUNT;
 		}
 
+		if (page_zone(page) != zone)
+			continue;
+
+		if (!swsusp_page_is_forbidden(page))
+			swsusp_unset_page_free(page);
+	}
+
 	for_each_migratetype_order(order, t) {
 		list_for_each_entry(page,
 				&zone->free_area[order].free_list[t], buddy_list) {
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are

mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch
mm-implement-for_each_valid_pfn-for-config_flatmem.patch
mm-implement-for_each_valid_pfn-for-config_sparsemem.patch
mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch
mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch
mm-use-for_each_valid_pfn-in-memory_hotplug.patch
mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

