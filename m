Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39E07602B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101799; cv=none; b=WmI/T30B8VfjSQoN3mxUCuYugb5tL1i/qji0wNT0FBStleQyrNu1vyq1bTSp3fYdT38+9hTw3BOx86YeV6GdvSlBlM+UZn0HVr9acNPhKwXAqQmV563F3Oy5Lt5wdCmMWADkCssr7fCXMqD6cn6+ZXgBBzBb5B3+3d40cgSGta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101799; c=relaxed/simple;
	bh=tGQXOYxfn6NNxEo8QeV6Frq0+Tdnri+NE7JhllSeRns=;
	h=Date:To:From:Subject:Message-Id; b=lPUb/9yy10B57priqGFZv1p1bO1YLHLAYDyBXFy651Bl/eE0UXsDvYueG2668Pc0OQ5zGjo4DpuQSRkRqDDkwB0K/xPOY4F/PtTd+Bi3OES7p9I7DU8yFcr931Clyk1WCcvsbqfRpyYtFxvZqgCr6a2LqTqyiUmGDm54FpBPdrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ct/w6MiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ct/w6MiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4122DC113CD;
	Fri, 26 Apr 2024 03:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101799;
	bh=tGQXOYxfn6NNxEo8QeV6Frq0+Tdnri+NE7JhllSeRns=;
	h=Date:To:From:Subject:From;
	b=ct/w6MiXr8h/51vKPS4Ns5aKGSk9i4BwizavBin8/RBwHr5lCUvDY66srEm2fPSGn
	 qa5AGWo3JoddU2ZtEhg3/tufi7CjT+Teh+jgXcZji0oGwaXnKNn9Y0drnUmtM2q2UY
	 uexCyub1ipbj29cw7LsBe5aoDDWhCjeoAVXLhVdg=
Date: Thu, 25 Apr 2024 20:23:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-xarray-introduce-a-new-helper-xas_get_order-v4.patch removed from -mm tree
Message-Id: <20240426032319.4122DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/xarray: introduce a new helper xas_get_order
has been removed from the -mm tree.  Its filename was
     lib-xarray-introduce-a-new-helper-xas_get_order-v4.patch

This patch was dropped because it was folded into lib-xarray-introduce-a-new-helper-xas_get_order.patch

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: lib/xarray: introduce a new helper xas_get_order
Date: Tue, 16 Apr 2024 15:17:21 +0800

simplify comment, sparse warning fix, per Matthew Wilcox

Link: https://lkml.kernel.org/r/20240416071722.45997-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/xarray.c~lib-xarray-introduce-a-new-helper-xas_get_order-v4
+++ a/lib/xarray.c
@@ -1750,7 +1750,7 @@ unlock:
 EXPORT_SYMBOL(xa_store_range);
 
 /**
- * xas_get_order() - Get the order of an loaded entry after xas_load.
+ * xas_get_order() - Get the order of an entry.
  * @xas: XArray operation state.
  *
  * Called after xas_load, the xas should not be in an error state.
@@ -1769,7 +1769,7 @@ int xas_get_order(struct xa_state *xas)
 
 		if (slot >= XA_CHUNK_SIZE)
 			break;
-		if (!xa_is_sibling(xas->xa_node->slots[slot]))
+		if (!xa_is_sibling(xa_entry(xas->xa, xas->xa_node, slot)))
 			break;
 		order++;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch
mm-filemap-clean-up-hugetlb-exclusion-code.patch
lib-xarray-introduce-a-new-helper-xas_get_order.patch
mm-filemap-optimize-filemap-folio-adding.patch

