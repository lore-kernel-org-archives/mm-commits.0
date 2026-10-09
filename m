Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9313F822F
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525440; cv=none; b=M8UOvpDeLsHBnnZHYuy8OpAc8VFvsG1n+hMzzxUWp2evhT07twld94OXyXYNLOxmnc8BR0I8USTydaLJCTz7ma8WOiG2/ml/dEH/UFMAKazqRQ+97bVaf6gAU36puhDF8KFs1/BZsWgt4aAdCDIUiP42ZwsNfS0KaJAsiiiC3RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525440; c=relaxed/simple;
	bh=oNuq6B+UmHuXM3UiGJyN8f6zyPkU0+MwKYjc6549YFk=;
	h=Date:To:From:Subject:Message-Id; b=YzLNMlJJdWaMQmIBe15n8U8JdQ1Xc7bTLC1y4Qr7L8E3kl9jikyH1ZTBgj6i8oY9W8hBSFpxXgi4NCK+M8otYNxRaTO8TyQORN+rZ3vAsJRwjLeVOcdAktaqS/RfwEd1zx35IGNNXo239DTzLxRzfx7l2uLoUS6Q5V+Ly+T5+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Xd8Vyz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Xd8Vyz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9AE1F00893;
	Fri,  9 Oct 2026 05:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525439;
	bh=GMFi4LEyIALjeEFhPmV8/FuMEXhXkLNnfukMdMhmYxY=;
	h=Date:To:From:Subject;
	b=0Xd8Vyz5yKyXyJc420cFo456VPrJ1ZaF3UwRkR2rmjisz97SObkj7bqlPGT6jVyhZ
	 JaBiKTOGVojhCAL3++1z57JKM1nJWgING6bE6KlHARRYoyRxRygDjSDiHp597F+UDQ
	 mmMsETEcF6CJ7BZDNS07cMUNtv6KCbK2CnaQ2Cw4=
Date: Thu, 08 Oct 2026 22:57:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-use-folio_page_swap_entry.patch removed from -mm tree
Message-Id: <20261009055718.EE9AE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile: use folio_page_swap_entry()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-use-folio_page_swap_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/swapfile: use folio_page_swap_entry()
Date: Tue, 08 Sep 2026 11:16:35 -0400

folio_dup_swap() and folio_put_swap() open-code the swap entry computation
from folio->swap and folio_page_idx().  Use folio_page_swap_entry()
instead.

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-5-ee6d01dfa5e1@columbia.edu
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

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-use-folio_page_swap_entry
+++ a/mm/swapfile.c
@@ -1822,7 +1822,7 @@ int folio_dup_swap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (page) {
-		entry.val += folio_page_idx(folio, page);
+		entry = folio_page_swap_entry(folio, page);
 		nr_pages = 1;
 	}
 
@@ -1849,7 +1849,7 @@ void folio_put_swap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (page) {
-		entry.val += folio_page_idx(folio, page);
+		entry = folio_page_swap_entry(folio, page);
 		nr_pages = 1;
 	}
 
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

