Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DEA8C05
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141596; cv=none; b=fU9uDSyQ4afzXmCpz7aVsLtoZ15N37bZ5aHQWP+YUZqnztGz2HBzO+SMb7MeIp/St1hDBZXEjuFyJaXi3qz+7vQ3udiMYNRI+1D4yiKKsM3BX+6QWTWbrd0HxIieJasp9AtvduD6SHoVRdIVYoUsYui0rYqtoF1S8db9egITcYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141596; c=relaxed/simple;
	bh=IgOlDEfbzVy6e145rQ2yqSLi04H059uBxZGiKlj1pDU=;
	h=Date:To:From:Subject:Message-Id; b=dUnYthUybokxz2L0ueaz3uX+jPJM2YVdBoBqydaiEJz0D2R4u/HLwiDIVCkvvteAZCgu3II2IZ2m3RTsHeYInGX6JguRRu8LARRBgPkiw3Xi1F3V6WfdDexuf3muFEqB/01ezQdi58ySJd5tZovcKfPhlZJ60mmwoKXVixm8doI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJ9AYMXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJ9AYMXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3846C3277B;
	Fri,  5 Jul 2024 01:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141595;
	bh=IgOlDEfbzVy6e145rQ2yqSLi04H059uBxZGiKlj1pDU=;
	h=Date:To:From:Subject:From;
	b=PJ9AYMXFY8rFXFSVHsJm6Ppr9lJ0jQGemKQHnkkYXqt0cditMX2iaQPusRm24tiGQ
	 ZtnDREmOnCoP8Hvu+7t+6gGaJf4Y3zsuaVjQ1Wlx4EHXcCenL5ZGWOZvhFJ3WRCtkp
	 2H5QpELIr2MJS4T+8GOr/sdw+X1Ndpd3uq06dQeQ=
Date: Thu, 04 Jul 2024 18:06:35 -0700
To: mm-commits@vger.kernel.org,shr@devkernel.io,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch removed from -mm tree
Message-Id: <20240705010635.C3846C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: don't waste time searching stable tree for fast changing page
has been removed from the -mm tree.  Its filename was
     mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/ksm: don't waste time searching stable tree for fast changing page
Date: Fri, 21 Jun 2024 15:54:30 +0800

The code flow in cmp_and_merge_page() is suboptimal for handling the ksm
page and non-ksm page at the same time.  For example:

- ksm page
 1. Mostly just return if this ksm page is not migrated and this rmap_item
    has been on the rmap hlist. Or we have to fix this rmap_item mapping.
 2. But we absolutely don't need to checksum for this ksm page, since it
    can't change.

- non-ksm page
 1. First don't need to waste time searching stable tree if fast changing.
 2. Should try to merge with zero page before search the stable tree.
 3. Then search stable tree to find mergeable ksm page.

This patch optimizes the code flow so the handling differences between ksm
page and non-ksm page become clearer and more efficient too.

Link: https://lkml.kernel.org/r/20240621-b4-ksm-scan-optimize-v2-2-1c328aa9e30b@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/mm/ksm.c~mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page
+++ a/mm/ksm.c
@@ -2366,6 +2366,23 @@ static void cmp_and_merge_page(struct pa
 		 */
 		if (!is_page_sharing_candidate(stable_node))
 			max_page_sharing_bypass = true;
+	} else {
+		remove_rmap_item_from_tree(rmap_item);
+
+		/*
+		 * If the hash value of the page has changed from the last time
+		 * we calculated it, this page is changing frequently: therefore we
+		 * don't want to insert it in the unstable tree, and we don't want
+		 * to waste our time searching for something identical to it there.
+		 */
+		checksum = calc_checksum(page);
+		if (rmap_item->oldchecksum != checksum) {
+			rmap_item->oldchecksum = checksum;
+			return;
+		}
+
+		if (!try_to_merge_with_zero_page(rmap_item, page))
+			return;
 	}
 
 	/* We first start with searching the page inside the stable tree */
@@ -2396,21 +2413,6 @@ static void cmp_and_merge_page(struct pa
 		return;
 	}
 
-	/*
-	 * If the hash value of the page has changed from the last time
-	 * we calculated it, this page is changing frequently: therefore we
-	 * don't want to insert it in the unstable tree, and we don't want
-	 * to waste our time searching for something identical to it there.
-	 */
-	checksum = calc_checksum(page);
-	if (rmap_item->oldchecksum != checksum) {
-		rmap_item->oldchecksum = checksum;
-		return;
-	}
-
-	if (!try_to_merge_with_zero_page(rmap_item, page))
-		return;
-
 	tree_rmap_item =
 		unstable_tree_search_insert(rmap_item, page, &tree_page);
 	if (tree_rmap_item) {
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-use-only-one-pool-in-zswap.patch
mm-zswap-use-only-one-pool-in-zswap-v2.patch
mm-zswap-use-only-one-pool-in-zswap-v3.patch
mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch
mm-zsmalloc-move-record_obj-into-obj_malloc.patch

