Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C96A403135
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525436; cv=none; b=cTA/mmjqWHS7W48UIjAmfdslrbsM8L4AVY02c/bClZX8p4s9D/SsYNAL+oQ38aTWcJ9f0lWT55oGmyOtU2FxN4UehEibiw5KeeBE35hjFk9YEeprPnijP0h9PQi5PTq3wCjYrkRCe2DaBZm0plbkA7oB604Vi4bVEV5496P74s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525436; c=relaxed/simple;
	bh=Nm1XsTtIIzqH0jkUscjFTJ0kYBV8VfgP3Xk/4rCdOSg=;
	h=Date:To:From:Subject:Message-Id; b=SR7r5OdHdsSDz7RZwHYJ0IA0USXbBzXsSeTT1Az8nPrGbTM8HW4cO/TMHfyRo2B8E/UskM13sXt7TZsP99awtw702BE52khhIr0TD2MgGLq6i2hymxWkX3WUZuxrImjk+tXv7bVakVymYOO8rfeA2RG9m61OYYG8PHAIlD3AO/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cTnjfECA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cTnjfECA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6CF1F000FF;
	Fri,  9 Oct 2026 05:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525435;
	bh=RqT7TGjkfMXdUB/N1YqMRJgfsUvWdM3v8vgluzCMKJs=;
	h=Date:To:From:Subject;
	b=cTnjfECAbKtokBFsBazSNmpjrKQVP7OiVS9BJk/mCcPGEfhT9Nx/UCFE0fWDqc0kk
	 TooR4yI2mqE++zdef/csRo5h1FcBtkfnsAukYSQq9pf9Uy0/Hjq7cSP/CuDXBpsjR5
	 1t3Xh6apuakk1s4bDJUZjezUgdGNlUuNNaUx0WdI=
Date: Thu, 08 Oct 2026 22:57:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch removed from -mm tree
Message-Id: <20261009055715.6D6CF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add a comment to the open-coded swap entry
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/huge_memory: add a comment to the open-coded swap entry
Date: Tue, 08 Sep 2026 11:16:32 -0400

The swap entry of each new folio in __split_folio_to_order() is computed
by hand from folio->swap rather than with folio_swap_entry(), because the
folio's page count is not valid while it is being split.  Add a comment
explaining this.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-2-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry
+++ a/mm/huge_memory.c
@@ -3762,6 +3762,10 @@ static void __split_folio_to_order(struc
 		 */
 		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
 
+		/*
+		 * Not all folio fields are valid during a split, so open-code
+		 * the swap entry rather than using folio_swap_entry().
+		 */
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
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

