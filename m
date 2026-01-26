Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE30F2571A0
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 21:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769461902; cv=none; b=AKHk2fxcCorrkv5LZQx/r4/p1UN5TseSfRbeIthwo15beyAHasUAWS3JdEUlw22Ti0hNgWJAcBqTNdpPiGNSfoNtOnkvcyCTQPG2ZwDsb5oFSEAoJ/6yvtSmskosLOsrzYmoBJ1WjGJB5BWq5XlBDO3ZdSgqkDjlLFWHVR1X8Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769461902; c=relaxed/simple;
	bh=9qd06sOA/NJzGiehY0BW6Tfb3h0jVPwYEYkTxmBi/y8=;
	h=Date:To:From:Subject:Message-Id; b=YwqJyltjWKUDU798MPRdtvB9TuCGOHCSMs7BKJWZxgs51HHqQ0N721UnSBXuV5XBuLFNEmyZ1at9NJt2K35z2luHR1LGpqpTkQI9lKRaJxdtBtP7aHzjtQua8QYa2Icitak4Rjj9Zr5hZqF2ILQz9pMvL0DBgvVrTMorBNe8up4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Drn3iU29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Drn3iU29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA5BC116C6;
	Mon, 26 Jan 2026 21:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769461902;
	bh=9qd06sOA/NJzGiehY0BW6Tfb3h0jVPwYEYkTxmBi/y8=;
	h=Date:To:From:Subject:From;
	b=Drn3iU29fjNeSF1/Skl7j2P/pVxsBqgJvSw1yBXqEhZRvXYGGS1NX1B77aHB6siBq
	 NTttraB6VLBpqkqTcupnKQxhTEH1BVGdQOF7xxEL7lIfIlJ7nQu8B806qFPujKZXWH
	 MHIC/V1yo5XUjQabZsktYCvw0VNQPZO7ax6eE0YE=
Date: Mon, 26 Jan 2026 13:11:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tujinjiang@huawei.com,dev.jain@arm.com,david@kernel.org,shardul.b@mpiricsoftware.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] lib-xarray-free-unused-spare-node-in-xas_create_range.patch removed from -mm tree
Message-Id: <20260126211142.5AA5BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: xarray: free unused spare node in xas_create_range()
has been removed from the -mm tree.  Its filename was
     lib-xarray-free-unused-spare-node-in-xas_create_range.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
Subject: lib: xarray: free unused spare node in xas_create_range()
Date: Thu, 4 Dec 2025 19:56:25 +0530

xas_create_range() is typically called in a retry loop that uses
xas_nomem() to handle -ENOMEM errors.  xas_nomem() may allocate a spare
xa_node and store it in xas->xa_alloc for use in the retry.

When the lock is dropped after xas_create_range() another thread can
expand the xarray tree in the meantime.  On the next retry,
xas_create_range() can then succeed without consuming the spare node
stored in xas->xa_alloc.  If the function returns without freeing this
spare node, it leaks.

xas_create_range() calls xas_create() multiple times in a loop for
different index ranges.  A spare node that isn't needed for one range
iteration might be needed for the next, so we cannot free it after each
xas_create() call.  We can only safely free it after xas_create_range()
completes.

Fix this by calling xas_destroy() at the end of xas_create_range() to free
any unused spare node.  This makes the API safer by default and prevents
callers from needing to remember cleanup.

This fixes a memory leak in mm/khugepaged.c and potentially other callers
that use xas_nomem() with xas_create_range().

Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
Link: https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
Link: https://lkml.kernel.org/r/20251204142625.1763372-1-shardul.b@mpiricsoftware.com
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/xarray.c~lib-xarray-free-unused-spare-node-in-xas_create_range
+++ a/lib/xarray.c
@@ -744,11 +744,16 @@ restore:
 	xas->xa_shift = shift;
 	xas->xa_sibs = sibs;
 	xas->xa_index = index;
-	return;
+	goto cleanup;
+
 success:
 	xas->xa_index = index;
 	if (xas->xa_node)
 		xas_set_offset(xas);
+
+cleanup:
+	/* Free any unused spare node from xas_nomem() */
+	xas_destroy(xas);
 }
 EXPORT_SYMBOL_GPL(xas_create_range);
 
_

Patches currently in -mm which might be from shardul.b@mpiricsoftware.com are


