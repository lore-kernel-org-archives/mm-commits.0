Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3D42F83B5;
	Tue, 25 Aug 2026 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622816; cv=none; b=I/IQsWs4AILNhubHHUt0CA6Ru77oozpUHsXVv4Dolv4XTUVKoVEbnKBw/1TuO9c6RxLZWePGPuHAsR6JtlBvLfzejcUSmuV6VptISBZajL2CdbcpYX1qx2ncsZNRUtuZA4CErf+84001AtMQQQ8sOCiS2NaJN2yKvFUi/uvPFGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622816; c=relaxed/simple;
	bh=WzTI4gK88G4bcTzgpv6PZ+ecr/8nQo7R8VRf/4ykwZM=;
	h=Date:To:From:Subject:Message-Id; b=bdAIipSVuZkUiGdvGJCMGjZMca++WKgbQULE2UbVfjZFEKHIw3DPJonQU1ykC5G7IsFlFH6243Q8IefEhVNJpGmxD9C0M9QFMHIHkJY2V8Gq8oa6TvikSphet1ImLiEiOduXBXs/Lo6QiNQH+Es5XwBEGl6sQ+CFUP2Bfa9mztM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Im3vF7+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Im3vF7+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAC71F000E9;
	Tue, 25 Aug 2026 01:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622814;
	bh=38DWONlX2M0NohCYqhtudocZd8JcAgGaJUCkIU2gJz8=;
	h=Date:To:From:Subject;
	b=Im3vF7+X2fjzxqZnAatpdMdZQ9ddx7f1G1PB0i34eFqp2gWevXty/mydbYACkRepi
	 tvtfbb432M7wJNjQZ8C560XWpmkngLFBOy1v+ca2tueJshQe3oNBZ4cFfDRPgCXFb6
	 U3jBKXE3v+qXe3JUvKqJgFrqM11/p5evMPv4I500=
Date: Mon, 24 Aug 2026 18:53:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,william.kucharski@oracle.com,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xarray-honor-xa_flags_account-in-xas_split_alloc.patch removed from -mm tree
Message-Id: <20260825015334.CBAC71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
has been removed from the -mm tree.  Its filename was
     xarray-honor-xa_flags_account-in-xas_split_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Date: Tue, 04 Aug 2026 17:04:28 -0400

XArray operations that allocate xa_nodes, such as xas_nomem() and
xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set. 
This charges the allocated memory and avoids the workingset convergence
issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
regression").

xas_split_alloc() does not add _GFP_ACCOUNT when XA_FLAGS_ACCOUNT is
present.  Fix it.

Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_alloc-v3-2-38cb3ff325c5@nvidia.com
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

usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

