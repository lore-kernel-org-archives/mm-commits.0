Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6913E8351
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 22:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785884300; cv=none; b=QPk33g2wBT00XNu4j3kE7FczIdul4mbak2jQ50TIDdbggRgZkHe9UpoEZuIbgaGWJDAzJBwDcdpB7Z/XtmRXdCFQ2iykwum9BUinr98zpxZGVrQUqc/5qEts0MptUEu+4U6+HnvosEh8cSOQL1WMpI3cuFj+vCrbAhaV9feUIYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785884300; c=relaxed/simple;
	bh=WRMuJ19kOe6XXDwR2bKt56/j+ny2pIRUbIXC1Y2z8eg=;
	h=Date:To:From:Subject:Message-Id; b=QRbEMvP2ZBwSo5BwJtK8mCNt8GSgz3Mw9ceyRQW0VmqgJjKvixohcPzzO8fcqVBi/yCoBAiPKqB9l9KQCMk+108ktIlSLblioB9bjdn36IZOdhWY2rVIT8q/9mN1/mBRP79M4ca26/7oSzuJSQRjgsIMtSpCuh1iFmxrYZFzc4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jLu8nmOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jLu8nmOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592681F00A3A;
	Tue,  4 Aug 2026 22:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785884298;
	bh=hSh6PkeVaPzaANhAfk31sfiEkCnjNPLt8gRLk2KLsK8=;
	h=Date:To:From:Subject;
	b=jLu8nmOjSeeLM65tgXXt9wXjoUL2FF4oBG14XWNnlNCHp10n/Ny8Xk52wMkaybJB8
	 Vppvd5lF/59+KwkAGjiFMbaZrdtNlInPuKDCygPJCRS5xjKjgdik55zQmlHPO7NeiI
	 2ij0uQ0TtJAA+0/werV/iYbYZjzZLOn/Uz3f8yH4=
Date: Tue, 04 Aug 2026 15:58:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xarray-honor-xa_flags_account-in-xas_split_alloc.patch removed from -mm tree
Message-Id: <20260804225818.592681F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
has been removed from the -mm tree.  Its filename was
     xarray-honor-xa_flags_account-in-xas_split_alloc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Date: Thu, 30 Jul 2026 22:18:01 -0400

XArray operations that allocate xa_nodes, such as xas_nomem() and
xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set. 
This charges the allocated memory and avoids the workingset convergence
issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
regression").

xas_split_alloc() does not have that flag. Add it when necessary.

Link: https://lore.kernel.org/20260730-add-gfp_account-to-xas_split_alloc-v2-2-5a56c2361d85@nvidia.com
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/xarray.c~xarray-honor-xa_flags_account-in-xas_split_alloc
+++ a/lib/xarray.c
@@ -1053,6 +1053,9 @@ void xas_split_alloc(struct xa_state *xa
 	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
 		return;
 
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
+
 	do {
 		struct xa_node *node;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch
a.patch

