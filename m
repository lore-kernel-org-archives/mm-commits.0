Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950313264EF
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961495; cv=none; b=GsAA/QK6U8mH6jYsdCOJ51JJV5iGz+9hgHzIDSjcfF9vigGzF1lJ4Jh633IDEeAPUsGgoyyGDBzjU1il4ez9Hl0BXv+Q8eiFjfCnFt47XzQQhxsYkghKjeakrKAx1as6gj64nYNZlhKcSys5/WzaUoQoU6vz+iD+FCGtXw7c3H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961495; c=relaxed/simple;
	bh=tcO5wBhR6VpEWLAa190KLUv5XqeK6Ip58t48YFvcH2w=;
	h=Date:To:From:Subject:Message-Id; b=Jx8a22o3BGs6yPbkjPZLJ2GvCtvCJcqX0wY1p/jcg/mIwjehz4iOt5gwzyYFFbeA5TmDR6KiaRTv+OZ8N3XoMeIZ8c7eVTLiwDVMU/RFxbjW+2dH7WllRWarN+7GptMuY+n0uzJpcbEhTjxjIALGpuo8oCCO7jaaorrqtnKFrRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1xRVw0D4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1xRVw0D4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0351F00893;
	Mon, 21 Sep 2026 03:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961494;
	bh=ya74SZWMjjpm3Lr9yk1m6IQVcnOWe8PdN9ymutPXNJM=;
	h=Date:To:From:Subject;
	b=1xRVw0D4ahmRmsx1SCY7pm/FNjEo3kyHpD827R6J6nFlrHwef3GO1AwdXu7aCrMo7
	 Zs5S/u27sI7m5f8gzbv2klS27rpcj8E4X+eIldVqamz76dcXX80xTaB4bAi3FUhLsB
	 hqq+OSs3Zgy2b61eHHN6QlsCieGNVY2hLEboIAdc=
Date: Sun, 20 Sep 2026 20:31:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch removed from -mm tree
Message-Id: <20260921033134.6C0351F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: use direct assignment instead of folio_change_private()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/hugetlb: use direct assignment instead of folio_change_private()
Date: Sun, 13 Sep 2026 22:24:03 -0400

folio_change_private() should be used along with folio_attach_private()
and folio_detach_private(), where adding and remove ->private content
requires folio refcount change.  add_hugetlb_folio() simply sets
folio->private to NULL without refcount manipulation.  Change it to direct
assignment to avoid semantic confusion.

It prepares for a future commit that removes PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-direct-assignment-instead-of-folio_change_private
+++ a/mm/hugetlb.c
@@ -1446,11 +1446,8 @@ void add_hugetlb_folio(struct hstate *h,
 	}
 
 	__folio_set_hugetlb(folio);
-	folio_change_private(folio, NULL);
-	/*
-	 * We have to set hugetlb_vmemmap_optimized again as above
-	 * folio_change_private(folio, NULL) cleared it.
-	 */
+	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
+	folio->private = NULL;
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
_

Patches currently in -mm which might be from ziy@nvidia.com are

f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

