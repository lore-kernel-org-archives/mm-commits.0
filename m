Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ADA361977
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350909; cv=none; b=eQFaoGBaWVMnyj43nIdh83iPGEp028//O9cqBml1Ajl9s8zUTQrva1IeEMhE1nURgOK2zIcIqi//RW8VZeNPBL0JvF/6Htd2mR4otEt41PkcnU4lpxt/iQaQ7FjwD6B+ZBQcG9bhdmlha2ktr42ub8Jc9OHKzNHxLWmGn5tcTHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350909; c=relaxed/simple;
	bh=9v5QNiTmYeaZIqReu5hSO9rn8Ea2/r51x4+kd2cA+bU=;
	h=Date:To:From:Subject:Message-Id; b=USJkA9BcwYBSC9o9NpjBbUSrrxOSYASdRfTKyfdzoohKgNx7y366VcJFQu1OLgocXlTrTf5hvcKXUx+FXf7NIRw2dCQZarczawOultoyGWDjgw6pwq4WW7L3ILGVTdmBu5modgJiZwmGUDnQBh2dE1/E9aFM8E6BpvTF0FqxKN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BYzywm77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BYzywm77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192601F00A3A;
	Fri, 21 Aug 2026 22:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350908;
	bh=uDSUwNsf+Wv6ocyL1j7BnlgHAG2e+hJ1siI5pSDihJo=;
	h=Date:To:From:Subject;
	b=BYzywm77gmv0Gv8g4/HlVJBksmAXT9xko3BBn/PqaNC9z0alCz+jfLxcUGLSIvLpP
	 xLxxdezeqLs0EjIX9o6ZM6fy1e5bha/5cX5XuLXPpcN6nOaZTUlbwQ35VQTpo+1+nA
	 MLA6EhU1lUHqllGSeaO9Vh9M/InLaU1+aN/PGXzo=
Date: Fri, 21 Aug 2026 15:21:47 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-use-prefetched-value-in-mas_wr_store_type.patch removed from -mm tree
Message-Id: <20260821222148.192601F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use prefetched value in mas_wr_store_type()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-prefetched-value-in-mas_wr_store_type.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: use prefetched value in mas_wr_store_type()
Date: Tue, 30 Jun 2026 15:08:32 -0400

The slot contents exist in wr_mas->content, which has less overhead than
reading the slot again.

Link: https://lore.kernel.org/20260630190843.3563858-9-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-prefetched-value-in-mas_wr_store_type
+++ a/lib/maple_tree.c
@@ -3280,7 +3280,7 @@ static inline void mas_wr_slot_store(str
 	void __rcu **slots = wr_mas->slots;
 	bool gap = false;
 
-	gap |= !mt_slot_locked(mas->tree, slots, offset);
+	gap |= !wr_mas->content;
 	gap |= !mt_slot_locked(mas->tree, slots, offset + 1);
 
 	if (wr_mas->offset_end - offset == 1) {
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

