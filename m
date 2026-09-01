Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C8433E35C
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 00:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788224010; cv=none; b=Ej7daBTHV+wqy5lqATFrBQhoLAP51eMDOkNiUIqKQGl68L2OWMvCCoKtNNnzqYO2iFEVYfcLdBaCIu0kmfIsIjEyMceXSI/vxpeA3O8mPjY6MTKgfqSg9UlDVvYgEc+LKAAnW70L7QT/ulxx6RYvjdv8xJvlCFvMKdsFzYs7vNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788224010; c=relaxed/simple;
	bh=dat1+F06ea5kTJTaffBE9M791FlDv+sV1Ul+dqdQjF0=;
	h=Date:To:From:Subject:Message-Id; b=Bsiv3+0gzK+aoC8yLOeQaWqPBmmqR8uN/OgHxJp/j25orPkFelEhG4lKvWmBy20unWYyTNL+YA+6WB3za83JtVmn+k5RJTk78snon4/xUDNSZVYRKGJqWwtjKIQ/hsoYHoHHb3jUl6izSmMGSjA6MxdLIZOMI0QYwiYSuYRsM3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dV6YmC41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dV6YmC41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44271F000E9;
	Tue,  1 Sep 2026 00:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788224007;
	bh=x26qVYJExEa5fRyyAWqoO0VIqan8GoJ8vspqxL0VM0Y=;
	h=Date:To:From:Subject;
	b=dV6YmC41k02vEg8S/NZNdhJBbQK2k/G1zzmXTMhYPXdYOtiAsfzL9QM4MpL9XLkeW
	 oEDCerEge0t3Zfku2v6Mi7793saRAlSrYgnSbAlsuzGCUNZ6+nsd74iexx5B1tkEa2
	 PKlZIMOZdYbiRm18vA2xr1wAhYgbmyp1Hne71KPY=
Date: Mon, 31 Aug 2026 17:53:27 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mm_init-remove-zone_absent_pages_in_node.patch removed from -mm tree
Message-Id: <20260901005327.D44271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: remove zone_absent_pages_in_node()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-remove-zone_absent_pages_in_node.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/mm_init: remove zone_absent_pages_in_node()
Date: Thu, 27 Aug 2026 23:41:46 +0900

zone_absent_pages_in_node() returns 0 when the zone is empty and otherwise
calls __absent_pages_in_range(), which already returns 0 for an empty
range.

So remove it and call __absent_pages_in_range() directly.

No functional change.

Link: https://lore.kernel.org/20260827144151.486192-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-remove-zone_absent_pages_in_node
+++ a/mm/mm_init.c
@@ -1187,22 +1187,9 @@ unsigned long __init absent_pages_in_ran
 	return __absent_pages_in_range(MAX_NUMNODES, start_pfn, end_pfn);
 }
 
-/* Return the number of page frames in holes in a zone on a node */
-static unsigned long __init zone_absent_pages_in_node(int nid,
-					unsigned long zone_type,
-					unsigned long zone_start_pfn,
-					unsigned long zone_end_pfn)
-{
-	/* zone is empty, we don't have any absent pages */
-	if (zone_start_pfn == zone_end_pfn)
-		return 0;
-
-	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
-}
-
 /*
  * Return the number of pages a zone spans in a node, including holes
- * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
+ * present_pages = zone_spanned_pages_in_node() - __absent_pages_in_range()
  */
 static unsigned long __init zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -1292,9 +1279,8 @@ static void __init calculate_node_totalp
 						     node_end_pfn,
 						     &zone_start_pfn,
 						     &zone_end_pfn);
-		absent = zone_absent_pages_in_node(pgdat->node_id, i,
-						   zone_start_pfn,
-						   zone_end_pfn);
+		absent = __absent_pages_in_range(pgdat->node_id, zone_start_pfn,
+						 zone_end_pfn);
 
 		real_size = spanned - absent;
 
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch

