Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C656D403B1E
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525438; cv=none; b=ok3jSRdTbGnbd3n8gQZyMSqXVwFlybvLHJA7QoS9kA7IFyXFKfeIMEPfbnT+ckwEJzgmjZEa3IkcyyvPNQrV309TXb9/qMDCGg9W9Yf5WW4wBmsAYBGWCFef5QziFxXTfKG2185v5bGgBwrclsehTeTCb1BNN3LDzK/hQr/HcHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525438; c=relaxed/simple;
	bh=fdFUGPPexNpspiR8rUyJpm88jhznjxoma53nqqptCoQ=;
	h=Date:To:From:Subject:Message-Id; b=WezWGmgnzQ/J16HAy+r1B87oVn7zfUbhnt7lpaojnPibiONaDkYRJdpWODoCHpksKRJPb3vxsJtQPsDddQNHy7H/32q9UWTTiRlyuWwsyTSPQOIvHsV9X8x+qrUvKbUw8InFOOEkNWEQ/RnLYxmSd5HSazzg2BYMP/Q7GKrUJSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nC5JxHZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nC5JxHZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9793C1F00893;
	Fri,  9 Oct 2026 05:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525436;
	bh=0gHxE2C/3YMcHi6l1ybmvTJAJUIWgzDE2iAAGTtTpUE=;
	h=Date:To:From:Subject;
	b=nC5JxHZP14YlP+s8pk6rg2d9MHHOVy9Av3v73W/iVzQzv3og8ThVNhvT7RaOdXPDU
	 jPi5upR8mxm5xmNTDiVIFm9fbNLBXi5pXuFwdUIs7ew63E1u1vVHe71nYFmiiDOAxG
	 FiFUR0LdHzqGN93hUfsdyjBTLq+mIIK2blsdCMZU=
Date: Thu, 08 Oct 2026 22:57:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch removed from -mm tree
Message-Id: <20261009055716.9793C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: use folio_page_swap_entry() in ttu_anon_swapbacked_folio()
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/rmap: use folio_page_swap_entry() in ttu_anon_swapbacked_folio()
Date: Tue, 08 Sep 2026 11:16:33 -0400

We already have the folio here, so use folio_page_swap_entry() instead of
going through page_swap_entry().  This saves a call to compound_head().

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-3-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio
+++ a/mm/rmap.c
@@ -2147,7 +2147,7 @@ static bool ttu_anon_swapbacked_folio(st
 {
 	const bool anon_exclusive = folio_test_anon(folio) &&
 				    PageAnonExclusive(page);
-	swp_entry_t entry = page_swap_entry(page);
+	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (folio_dup_swap(folio, page) < 0)
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

