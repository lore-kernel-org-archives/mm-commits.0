Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3498D1865
	for <mm-commits@vger.kernel.org>; Sat, 22 Jun 2024 01:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719018543; cv=none; b=NSeOwyqX3LeUpn3G1ybjry1w8scjotYWE9ojyKLDWTAeTjpx9XQpUo6c8RMzjNofk2gakNxpkCc4JHPMrfMXckr98wOfApWyPzlcKGHjjIfBTWZBrITadvztqQn13Z2YUNgweHZQdCyD0A7SFJJuac7z2yp2LNnzF0uGmRssjN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719018543; c=relaxed/simple;
	bh=Ahm3HbB2fh+a4vwpkLYcNdrXJr9AjbetlcP9Jhd6T8M=;
	h=Date:To:From:Subject:Message-Id; b=pzaNFySlUTc46+6oHp3aODL4EDLKWDxW+6UlSPZosDyj/ZOTRoTbvT9J3lokUe0DGkupkUzARyytKi8EUnh5u/9yYYW/RLuxUkk8dMS1csQ6wTE0hOU0BFzMYh8PVdytvwbs/K2k9P9b9z0oU1e5V7T9idEuxBbp6k1lAbYqdzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=izK+bSGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="izK+bSGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A328DC2BBFC;
	Sat, 22 Jun 2024 01:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719018542;
	bh=Ahm3HbB2fh+a4vwpkLYcNdrXJr9AjbetlcP9Jhd6T8M=;
	h=Date:To:From:Subject:From;
	b=izK+bSGY4JyYDuuFOFpbV5avKZ6srsnPB+7LnZztRe07zy12b7Fwx4n9ksdV4ymZI
	 J0EHUwHUS0LzPdb2lnyDaycIIelBausVNN9gNuOebdllSvhmxO+P86P1JqUan2sLIp
	 ylD+dJbvHJmbEibc1hkrEkzk7S/aljDuIpS8IdKY=
Date: Fri, 21 Jun 2024 18:09:02 -0700
To: mm-commits@vger.kernel.org,shr@devkernel.io,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch added to mm-unstable branch
Message-Id: <20240622010902.A328DC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: don't waste time searching stable tree for fast changing page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-ksm-refactor-out-try_to_merge_with_zero_page.patch
mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch
mm-ksm-optimize-the-chain-chain_prune-interfaces.patch

