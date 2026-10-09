Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061E83FC5B7
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525439; cv=none; b=kAy79qaiTcM7PTLIGmtHlJnF/XLrxOHAKiq/6Xw6dec2m6tXwEScDYFKjYCmwoc7scfwJrg+fzQZc2G8QwtKMUr2CWSHMU83vvwF3X9ANQ96kL9/iCeQqnbtazJeC951MSQQPTkJGWs4PNo3n51bnOFoAp9gQIbeg8ocwwVe21I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525439; c=relaxed/simple;
	bh=r0fdYlPWwoZ5b5eUE3ldRyQfL0t4M1uiSf4p6Lw9b7s=;
	h=Date:To:From:Subject:Message-Id; b=Kn1iz99MqIy7C13dpEw4ahjsoJiuIf9NaifwQqpKvyWrDCfdkMX4GH4I7dc375zKw2qXxIpOpAN8A4ITm2zgPZ3n89Z/1qdy2ituPlzk138LNzUAtMag27K7pXi+e74gBx181c1rlrBC7xrX1KeQrdckGdHJCfh5Ra/bhpthQ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yxamb//l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yxamb//l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C871F1F000FF;
	Fri,  9 Oct 2026 05:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525437;
	bh=avjv3A8ppeVCcJaf0fDHKbgmMg/imzUAHd4Z0H3WTp8=;
	h=Date:To:From:Subject;
	b=Yxamb//lbiN2FHbYZa5t5yjkBXVFNt9FqRP3xRJkRMYaR+5R+s82a3VLcRBOdwHZ+
	 sLoNWDmRL9l9jditCHp9PBJ8Z/mcHuoUsm7gNzak1Oy2otnvcKWz25XZjCw7r1Jj6Y
	 1dyH+3cIOPiuuaPBWL+Hc5F81HxhRJdb4xPRqKRE=
Date: Thu, 08 Oct 2026 22:57:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch removed from -mm tree
Message-Id: <20261009055717.C871F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: use folio_swap_entry() in zswap_store_page()
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/zswap: use folio_swap_entry() in zswap_store_page()
Date: Tue, 08 Sep 2026 11:16:34 -0400

zswap_store_page() open-codes the swap entry computation from folio->swap
and the page index.  Use folio_swap_entry() instead.

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-4-ee6d01dfa5e1@columbia.edu
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

 mm/zswap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-folio_swap_entry-in-zswap_store_page
+++ a/mm/zswap.c
@@ -1395,8 +1395,7 @@ static bool zswap_store_page(struct foli
 			     struct obj_cgroup *objcg,
 			     struct zswap_pool *pool)
 {
-	swp_entry_t page_swpentry = swp_entry(swp_type(folio->swap),
-					      swp_offset(folio->swap) + index);
+	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
 
 	/* allocate entry */
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

