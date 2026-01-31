Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893C838A9C0
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898386; cv=none; b=R/yz4uEt5HZjJttFU6MYMaJ0BqH1Sx1DaybIaOTLDO/nA4Gq5MAv3KF2W8eUxj2LvQHqMqF+4pP45ti7k7EEBktu0oqgAXlDdB14Bf+4payR7ntbi3uihodkS1IHsirzCiAzm9+qBFK8gA8hK1OkA9Wgnr+n2ZvwL4XEmSNG8TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898386; c=relaxed/simple;
	bh=8R1/Ool8iNSrjBHQnc+7K0LR4ALd5JTX3H6qD2+Qr8w=;
	h=Date:To:From:Subject:Message-Id; b=oIJuX2+6eR1l9/nIon5Axe0QYvmT3OBmL0fXOsPojmqNmbG39RgpXXGNNNOLSgOpqONCQq2w1V2AnG0cs5pwCCJB3PIJTvLxhKcoQ6MZ3Qs0ebkSS/L/yBYJ+1NsqJg5cQzGn36ynz1giRjc3qiJTBO0d/uB+XigAvfjbOAEI1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ynqbqXF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ynqbqXF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603B7C4CEF1;
	Sat, 31 Jan 2026 22:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898386;
	bh=8R1/Ool8iNSrjBHQnc+7K0LR4ALd5JTX3H6qD2+Qr8w=;
	h=Date:To:From:Subject:From;
	b=ynqbqXF3r1Vq81lrZl6FdN6P0TZ1dda4H1dr46/5kaT3pcNoIA81NOfUkHC9Ko2B9
	 XG+fddOrw3DJRJsQsVlBx5ZqoIPtRJ8ziwJHQzDg2BwH6cYCd12YidsynS+gnbGeRt
	 0h61ENdMIRZW/M96Mn3rdKMpQoq5leRymiPrL+oY=
Date: Sat, 31 Jan 2026 14:26:25 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-increase-hugepage-reservations-when-using-node-specific-hugepages=-cmdline.patch removed from -mm tree
Message-Id: <20260131222626.603B7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: increase hugepage reservations when using node-specific "hugepages=" cmdline
has been removed from the -mm tree.  Its filename was
     hugetlb-increase-hugepage-reservations-when-using-node-specific-hugepages=-cmdline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: hugetlb: increase hugepage reservations when using node-specific "hugepages=" cmdline
Date: Thu, 22 Jan 2026 11:50:02 +0800

Commit 3dfd02c90037 ("hugetlb: increase number of reserving hugepages via
cmdline") raised the number of hugepages that can be reserved through the
boot-time "hugepages=" parameter for the non-node-specific case, but left
the node-specific form of the same parameter unchanged.

This patch extends the same optimization to node-specific reservations. 
When HugeTLB vmemmap optimization (HVO) is enabled and a node cannot
satisfy the requested hugepages, the code first releases ordinary
struct-page memory of hugepages obtained from the buddy allocator,
allowing their struct-page memory to be reclaimed and reused for
additional hugepage reservations on that node.

This is particularly beneficial for configurations that require identical,
large per-node hugepage reservations.  On a four-node, 384 GB x86 VM, the
patch raises the attainable 2 MiB hugepage reservation from under 374 GB
to more than 379 GB.

Link: https://lkml.kernel.org/r/20260122035002.79958-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~hugetlb-increase-hugepage-reservations-when-using-node-specific-hugepages=-cmdline
+++ a/mm/hugetlb.c
@@ -3435,6 +3435,13 @@ static void __init hugetlb_hstate_alloc_
 
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
 					&node_states[N_MEMORY], NULL);
+			if (!folio && !list_empty(&folio_list) &&
+			    hugetlb_vmemmap_optimizable_size(h)) {
+				prep_and_add_allocated_folios(h, &folio_list);
+				INIT_LIST_HEAD(&folio_list);
+				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
+						&node_states[N_MEMORY], NULL);
+			}
 			if (!folio)
 				break;
 			list_add(&folio->lru, &folio_list);
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are


