Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD8A1EF0AA
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119285; cv=none; b=GCx8D1KhdQMdbzQOt2i8+yQ1bBaWgHKnNSrJuFVOhfUeucf+DXKFc1U68zD5fyNuRpUHIUc5WBUYgJ0L5/yvMnKTendrFZF72468C7biosWV064OGDGdY81F3hIyTCZCkTHUxYSKzDHCabCnsD4YqEEC7gICeyx6gMUbkN/PyH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119285; c=relaxed/simple;
	bh=cn/MAnklcmmp9GNyBhbOkZcnbqzuLlQ/jupo2yqhvHs=;
	h=Date:To:From:Subject:Message-Id; b=DfV9S0Z7Lv2KzfefiWmbNPz3SHyieudyXKryPHDJzr/ghcyR40noZxfftuvZOGMr+1nEoG2SRgCL4NuEoO2ugQ8C/C9iQMvgdLNvwsvUBDgJUPvr3AEJwhRL0ydHVsGL87YJB7AytqavxwcoiS1iHh2VwPiupgNKXEHRLCc8lHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K0rPEpef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K0rPEpef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DDEC4CEE4;
	Tue, 13 May 2025 06:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119285;
	bh=cn/MAnklcmmp9GNyBhbOkZcnbqzuLlQ/jupo2yqhvHs=;
	h=Date:To:From:Subject:From;
	b=K0rPEpefg6TqfNaxgWvBW1s0u5XO5aQzWgkPD5/rDXI3W8SV/aHx1jvsQ299Vv15X
	 8OVp45KGde6bIScr/y/xzuGhNU9M5pZ/swkaNYNDdDuwOpo2wXl2tRfp/EOi+8QkVM
	 VGXfMRpzIZHSjm/WPXgq9IBINa4s7Qh4DNkCOPGE=
Date: Mon, 12 May 2025 23:54:44 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,lorenzo.stoakes@oracle.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-for_each_valid_pfn-in-memory_hotplug.patch removed from -mm tree
Message-Id: <20250513065445.47DDEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use for_each_valid_pfn() in memory_hotplug
has been removed from the -mm tree.  Its filename was
     mm-use-for_each_valid_pfn-in-memory_hotplug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm: use for_each_valid_pfn() in memory_hotplug
Date: Wed, 23 Apr 2025 14:33:42 +0100

Link: https://lkml.kernel.org/r/20250423133821.789413-7-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memory_hotplug.c~mm-use-for_each_valid_pfn-in-memory_hotplug
+++ a/mm/memory_hotplug.c
@@ -1756,12 +1756,10 @@ static int scan_movable_pages(unsigned l
 {
 	unsigned long pfn;
 
-	for (pfn = start; pfn < end; pfn++) {
+	for_each_valid_pfn(pfn, start, end) {
 		struct page *page;
 		struct folio *folio;
 
-		if (!pfn_valid(pfn))
-			continue;
 		page = pfn_to_page(pfn);
 		if (PageLRU(page))
 			goto found;
@@ -1805,11 +1803,9 @@ static void do_migrate_range(unsigned lo
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+	for_each_valid_pfn(pfn, start_pfn, end_pfn) {
 		struct page *page;
 
-		if (!pfn_valid(pfn))
-			continue;
 		page = pfn_to_page(pfn);
 		folio = page_folio(page);
 
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are


