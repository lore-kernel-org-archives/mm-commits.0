Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A12147796
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421772; cv=none; b=RUP84t5m5duLgWnb5qIiY3g9oX2weNNYQy6OgnEDaIbDFuGPufdcKtue+vUwC8z6W70eGouk3qoWwQA7e+kiBJP6VgSOlqyK5l/j1fxHMlZR2V9FKvXCGZiNIuTZPCAi3yTj6jDhUBNhzC9oqYj/UpnKI176nY/bRleLsQvC7SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421772; c=relaxed/simple;
	bh=PpN5JwrY4cxgdA9mt5t6pUgqDbJ3BsLGBjFSt1ZtVg4=;
	h=Date:To:From:Subject:Message-Id; b=aR6qEhSw4czw0N2z0TKuVjkJpY5ED/TQZKHGOjw+7Lz0CFh2vVFLSBcnXmBMOOP483ptNVNxV0ayZfYR0TsjeHHrWiEUIMYuSRi5PuBqupROeCzSnCQyGJk5LQosn0nRggae27FXTo/KsUntaIQDsJYRzQZlTfIR5Lm4bTMR+G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zbeuIF6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zbeuIF6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6830C4CEC2;
	Wed,  4 Sep 2024 03:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421771;
	bh=PpN5JwrY4cxgdA9mt5t6pUgqDbJ3BsLGBjFSt1ZtVg4=;
	h=Date:To:From:Subject:From;
	b=zbeuIF6vHLJQgK6h5n6GqzgzpVJBa7ru5gSyryEm3cs68e8pT+axWs2ApYbU1EnTa
	 KwWn3D8Gwbq6AJ5w6ncEftME81KZNZ5dnwkpwdgZqx9Gy7OLFXB4FGV/GwfyX5KaYy
	 MbYmAvsyCUc8baLkjhd8waKf0jEqjB31qy4plNr0=
Date: Tue, 03 Sep 2024 20:49:31 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baohua@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch removed from -mm tree
Message-Id: <20240904034931.D6830C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: check all swaps belong to same swap_cgroup in swap_pte_batch()
has been removed from the -mm tree.  Its filename was
     mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch

This patch was dropped because it was folded into mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: check all swaps belong to same swap_cgroup in swap_pte_batch()
Date: Fri, 16 Aug 2024 09:36:23 +1200

Right now, it is possible two folios are contiguous in swap slots but they
don't belong to one memcg.  In this case, even we return a large nr, we
can't really batch free all slots.

Link: https://lkml.kernel.org/r/20240815215308.55233-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix
+++ a/mm/internal.h
@@ -15,6 +15,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
 
 /* Internal core VMA manipulation functions. */
@@ -275,18 +276,22 @@ static inline int swap_pte_batch(pte_t *
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
+	swp_entry_t entry = pte_to_swp_entry(pte);
 	pte_t *ptep = start_ptep + 1;
+	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
 	VM_WARN_ON(!is_swap_pte(pte));
-	VM_WARN_ON(non_swap_entry(pte_to_swp_entry(pte)));
+	VM_WARN_ON(non_swap_entry(entry));
 
+	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
 		pte = ptep_get(ptep);
 
 		if (!pte_same(pte, expected_pte))
 			break;
-
+		if (lookup_swap_cgroup_id(pte_to_swp_entry(pte)) != cgroup_id)
+			break;
 		expected_pte = pte_next_swp_offset(expected_pte);
 		ptep++;
 	}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix.patch

