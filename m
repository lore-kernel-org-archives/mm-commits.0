Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE86A2701D4
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745444978; cv=none; b=LJzaQGB1OISh8iCyJbYB/u6cNOwFcUQhz15Hr0TJkSPn97HG9noLJpjTMnWRb9miaGJ67ZavVkDwV8Etd38RHxqm5wPuG07+QGga2vVP2ou+ukEeDQaKbRDfHoO7Qroo7iyAK5tx7AIg4NVkIYfCIa7zx9khSOskp4MK008PYdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745444978; c=relaxed/simple;
	bh=qABU0nKGd2UKpF12PAITjLG2gNvD1v8zTDUXpHN6pjk=;
	h=Date:To:From:Subject:Message-Id; b=qT/1/y3qoBYarwPfNIwjZWZZUVfEsNFbLU5q7PTdoDzJvMNHRY8RzGdsSzy2bJZkjN5M88mB8yfkJl2gwIqKZPB5gBFLMvN7fFOSwA3sadMaYGcXF1iGU7rIpJ0a+Ukkky9b4FSute6Dryn6+Ky6SAvd8YVw6M+rZcSUbCemLiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CSh66uH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CSh66uH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42713C4CEE2;
	Wed, 23 Apr 2025 21:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745444978;
	bh=qABU0nKGd2UKpF12PAITjLG2gNvD1v8zTDUXpHN6pjk=;
	h=Date:To:From:Subject:From;
	b=CSh66uH7fUg/h5e6gk7d4DzaoANyoMmuvR0XQ4ZlaGa1tO8xuyBYIeHD36+rkRpVO
	 HqRTd6aMM+uJjBNIWdazyI6c1GVZsFn842S7Yqn/m/OvqBFTd40xdHIPtH9aJut017
	 CHzuehz7qkd+HttS2VJ+ZkypHfxX3v3TfAND+xNI=
Date: Wed, 23 Apr 2025 14:49:37 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-for_each_valid_pfn-in-memory_hotplug.patch added to mm-new branch
Message-Id: <20250423214938.42713C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use for_each_valid_pfn() in memory_hotplug
has been added to the -mm mm-new branch.  Its filename is
     mm-use-for_each_valid_pfn-in-memory_hotplug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-for_each_valid_pfn-in-memory_hotplug.patch

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
Subject: mm: use for_each_valid_pfn() in memory_hotplug
Date: Wed, 23 Apr 2025 14:33:42 +0100

Link: https://lkml.kernel.org/r/20250423133821.789413-7-dwmw2@infradead.org
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

mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch
mm-implement-for_each_valid_pfn-for-config_flatmem.patch
mm-implement-for_each_valid_pfn-for-config_sparsemem.patch
mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch
mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch
mm-use-for_each_valid_pfn-in-memory_hotplug.patch
mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

