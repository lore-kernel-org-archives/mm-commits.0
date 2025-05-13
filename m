Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126931EEA28
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119283; cv=none; b=YNWlLSl1J59ARIwndhKnZllCXTOB3+k1u3VjJbhWzIMIhNeUHGLfjI6kbRCd7BZVYc9BkRydxOACas2MScVbMx697IAQm7zgg2r7DU1Ad9fXsJzIRoXddrkW8wDA94u66K2vuIbQfvOFFu17/v3Fh/bBpOTte71tIYTIq75u1BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119283; c=relaxed/simple;
	bh=UjpanVLkNlS+CFgp+zRlnJjQ0LOnbhXwAyZ/+IKa1pk=;
	h=Date:To:From:Subject:Message-Id; b=te0yeNYLweASVSS2+NUVH+gcieFiS/PfIDqKcowc3wH0KlcXLInxw9kcusi/5pZZt7G7kLs1srRhN0/zTnTy9bm9VJL5Ds7x95MReAG+kCrLK8xFmJ2S2P9eUbbusgyUz6pMJ28TtQvFWVyBM9XalsduykB8US4MtGZfwdJSmyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ieoMdFhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ieoMdFhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5DFC4CEE4;
	Tue, 13 May 2025 06:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119282;
	bh=UjpanVLkNlS+CFgp+zRlnJjQ0LOnbhXwAyZ/+IKa1pk=;
	h=Date:To:From:Subject:From;
	b=ieoMdFhW98KNC/pgW2wevdGYf56gEyWE3DhAdMXetkmjbY7PZwA6mmECVC1VR54Ek
	 +28cFvnWRNj27BQxfOKzbV/K7tVmACCWBWRnhs72IdAj4lOEEri5sD7Htx+osF066w
	 mobhn1RPvyqZvrZAjfyzd4hFJDPjaJHrX001CWoE=
Date: Mon, 12 May 2025 23:54:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,lorenzo.stoakes@oracle.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch removed from -mm tree
Message-Id: <20250513065442.DC5DFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, PM: use for_each_valid_pfn() in kernel/power/snapshot.c
has been removed from the -mm tree.  Its filename was
     mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


