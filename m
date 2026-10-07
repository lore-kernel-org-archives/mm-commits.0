Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B3D3246EB
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334356; cv=none; b=uqf8I6wCHJb53PXqJ+d32KLjn7j/ITz4+SMfj/5RHDE6qvKtdadsBt+gn5hOAKO0bFUC20coE69BlV8pHjD7zg0x2xx1aHc7UBnP35Jp61AxEU6PZWKwr6xS/25Km8CPtjyAInfNRRB9UWVJsg08sZM4WClb1SwGor1QF6ichW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334356; c=relaxed/simple;
	bh=UcF6ITOZlCZ0UcZAc6yJtVRpuM0HIbywmvzLhLsKPHI=;
	h=Date:To:From:Subject:Message-Id; b=i0Nfk9bglcJIRY5OrzNDYewg0FOOlhSiRUsD++pg8DVwq4KHNG3zQeMjRxVsZ0YZj5DQSDrJy3R26nhe6231nigpBQddThXtVKS6ipIX5SeQVAaQh1gJRDDHObizToPHkFcMGQrhiSml9BdYWUxbUYDH+GWd8JZgaTmlzS+zN3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hbJRR3b4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hbJRR3b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBD81F0089B;
	Wed,  7 Oct 2026 00:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334355;
	bh=TKziEBerzg+UUjUfgcahYVhbWNbJm0IYm06yEFGH3eI=;
	h=Date:To:From:Subject;
	b=hbJRR3b47ShW/wvPDA+d4otl+Mi+hwa0miH6A7yIEdbq47OgnMA18rpAZx4xHFsjl
	 Y8mbCIeltlcGYmDXGuIkbJCPW9ZtV/U4z19R+/rOlDHmFEUl7QtrvNtHxcGA2vAj8Y
	 vE45NHPaBUbdYFlFORlgXCACFTczQNz2Z2Fk+Qu4=
Date: Tue, 06 Oct 2026 17:52:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-mark_page_reserved.patch removed from -mm tree
Message-Id: <20261007005235.6DBD81F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused mark_page_reserved()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-mark_page_reserved.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove unused mark_page_reserved()
Date: Tue, 01 Sep 2026 15:38:04 -0400

Patch series "mm: remove three unused helpers from mm.h", v2.

I happened to notice these were unused.  Two of them are relatively
recently unused, and one has been unused for a few years.  Remove them.


This patch (of 2):

mark_page_reserved() lost its last caller in commit 6215d9f4470f ("arch,
mm: consolidate empty_zero_page"). Remove it.

Link: https://lore.kernel.org/20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu
Link: https://lore.kernel.org/20260901-mm-remove-unused-helpers-v2-1-f6474e169c23@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/mm.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/mm.h~mm-remove-unused-mark_page_reserved
+++ a/include/linux/mm.h
@@ -4080,12 +4080,6 @@ static inline void free_reserved_page(st
 	free_reserved_pages(page, 0);
 }
 
-static inline void mark_page_reserved(struct page *page)
-{
-	SetPageReserved(page);
-	adjust_managed_page_count(page, -1);
-}
-
 static inline void free_reserved_ptdesc(struct ptdesc *pt)
 {
 	free_reserved_page(ptdesc_page(pt));
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
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

