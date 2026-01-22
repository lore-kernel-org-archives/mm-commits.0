Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C37D3D523F
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 22:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769120373; cv=none; b=MHUXvWa46lBxJkDNkhchEE/TUiJV9v/o4tZ6wlz9ZX2iDzqUpXBK9LydEsGMhedwjx21Xym7ozPyqB3xGANWnXQaOgT3Q9T+eVcyvCDm5N2lTUwXg3tIcocj/+IoZgVxhtm40k94tsxcbvPcodsiZnXUPltG9DqwWof5UqNIF7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769120373; c=relaxed/simple;
	bh=sOWNNzlX0QjDBc27ad0eN34UmAQc/GGJ3HhFwIfrWAs=;
	h=Date:To:From:Subject:Message-Id; b=XMIFRQXzp67ZvYlEFSL1v2CYd5Ii4fBjmixKCnGbQw6PqIFWBHwPJ6cF+Cw4ubM8zcXvjE/XG5b07n2kbW37ZftE2UI0HUJTb+6rJ2zSa7lsaDsKjhKfKxsLOcMpeMbV/ENnNcHe6vltWJ6WmsfLDv5xUscBWBaJaSOorOS8/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZAaDAq01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZAaDAq01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1231EC116C6;
	Thu, 22 Jan 2026 22:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769120371;
	bh=sOWNNzlX0QjDBc27ad0eN34UmAQc/GGJ3HhFwIfrWAs=;
	h=Date:To:From:Subject:From;
	b=ZAaDAq018RSTfivMtYeB5PDutkVlOyIhYGBhoWtOz2X7v55Youedbe3+bmP8tezCZ
	 yzWN+lbR7k7Zs/V0lBqtmtNVHfyfFf/iuS9KYqTK3pQ++Hpw9Juiww5OxBJKPPSPWm
	 cJ5dh2Qr4wrg5BC38W5W1w649DrDBTW/SDPXjIDc=
Date: Thu, 22 Jan 2026 14:19:30 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-increase-hugepage-reservations-when-using-node-specific-hugepages=-cmdline.patch added to mm-new branch
Message-Id: <20260122221931.1231EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: increase hugepage reservations when using node-specific "hugepages=" cmdline
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-increase-hugepage-reservations-when-using-node-specific-hugepages=-cmdline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-increase-hugepage-reservations-when-using-node-specific-hugepages=-cmdline.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
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

hugetlb-increase-hugepage-reservations-when-using-node-specific-hugepages=-cmdline.patch

