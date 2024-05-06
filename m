Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA8A1E889
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957032; cv=none; b=YbXbvFi9o/JQ//g1R9PXkrftEKTTgP5/qjSxefFw6PxV2NAZpC+UmOm3Uw7TUFJ2gfd750ogimJkjm7ZOGUNEmjqlYV+csKfNanvFSNY/BLExm21jGcRbkjtLWnmB7NQjpPw86jo+CyU98h/5lUiQblZ7YbwziClhVDcuyaqW7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957032; c=relaxed/simple;
	bh=82GWlJ61ucUGmvR0rcoHJQSSFGBWLqR97g8aNjWe6ko=;
	h=Date:To:From:Subject:Message-Id; b=f2A+SqRoGNjpzPFTelKqGBa+y7uC8uIt60jl9aiWEh8nB+4XyaufyuMWBzHrIFzf+AhHHZB0Y97kDenFM6vgz/S9jt+V4ac2/PeVA/zNf16ur6RQymjkcSdyy5cpGI/on4W7+BUePqB3uKpXXIEyHScIkfmd9ZL4jXaCClK5+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U6kFgFlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U6kFgFlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D753CC113CC;
	Mon,  6 May 2024 00:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957031;
	bh=82GWlJ61ucUGmvR0rcoHJQSSFGBWLqR97g8aNjWe6ko=;
	h=Date:To:From:Subject:From;
	b=U6kFgFlkTxy0CYKf6WBD5pUCWVBLaxv9WRsu9D+xCYTGsLFGR01hx2HOy5tCHuA6l
	 wxDI8FUbw4Mbej9mAaj2XlRQSH9Hz0Wr72kPByewwBs6rvPc6TtR3BNdiXuLxOo21Z
	 1EuMOilVLFcwCKdpOjxNFKaMDCitVSHY8z0Kb9mA=
Date: Sun, 05 May 2024 17:57:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,chrisw@sous-sol.org,alexs@kernel.org,aarcange@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch removed from -mm tree
Message-Id: <20240506005711.D753CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: rename get_ksm_page_flags to ksm_get_folio_flags
has been removed from the -mm tree.  Its filename was
     mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: rename get_ksm_page_flags to ksm_get_folio_flags
Date: Thu, 11 Apr 2024 14:17:10 +0800

As we are removing get_ksm_page_flags(), make the flags match the new
function name.

Link: https://lkml.kernel.org/r/20240411061713.1847574-10-alexs@kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Reviewed-by: Alex Shi <alexs@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/ksm.c~mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags
+++ a/mm/ksm.c
@@ -890,10 +890,10 @@ static void remove_node_from_stable_tree
 	free_stable_node(stable_node);
 }
 
-enum get_ksm_page_flags {
-	GET_KSM_PAGE_NOLOCK,
-	GET_KSM_PAGE_LOCK,
-	GET_KSM_PAGE_TRYLOCK
+enum ksm_get_folio_flags {
+	KSM_GET_FOLIO_NOLOCK,
+	KSM_GET_FOLIO_LOCK,
+	KSM_GET_FOLIO_TRYLOCK
 };
 
 /*
@@ -916,7 +916,7 @@ enum get_ksm_page_flags {
  * is on its way to being freed; but it is an anomaly to bear in mind.
  */
 static struct folio *ksm_get_folio(struct ksm_stable_node *stable_node,
-				 enum get_ksm_page_flags flags)
+				 enum ksm_get_folio_flags flags)
 {
 	struct folio *folio;
 	void *expected_mapping;
@@ -959,15 +959,15 @@ again:
 		goto stale;
 	}
 
-	if (flags == GET_KSM_PAGE_TRYLOCK) {
+	if (flags == KSM_GET_FOLIO_TRYLOCK) {
 		if (!folio_trylock(folio)) {
 			folio_put(folio);
 			return ERR_PTR(-EBUSY);
 		}
-	} else if (flags == GET_KSM_PAGE_LOCK)
+	} else if (flags == KSM_GET_FOLIO_LOCK)
 		folio_lock(folio);
 
-	if (flags != GET_KSM_PAGE_NOLOCK) {
+	if (flags != KSM_GET_FOLIO_NOLOCK) {
 		if (READ_ONCE(folio->mapping) != expected_mapping) {
 			folio_unlock(folio);
 			folio_put(folio);
@@ -1001,7 +1001,7 @@ static void remove_rmap_item_from_tree(s
 		struct folio *folio;
 
 		stable_node = rmap_item->head;
-		folio = ksm_get_folio(stable_node, GET_KSM_PAGE_LOCK);
+		folio = ksm_get_folio(stable_node, KSM_GET_FOLIO_LOCK);
 		if (!folio)
 			goto out;
 
@@ -1116,7 +1116,7 @@ static int remove_stable_node(struct ksm
 	struct folio *folio;
 	int err;
 
-	folio = ksm_get_folio(stable_node, GET_KSM_PAGE_LOCK);
+	folio = ksm_get_folio(stable_node, KSM_GET_FOLIO_LOCK);
 	if (!folio) {
 		/*
 		 * ksm_get_folio did remove_node_from_stable_tree itself.
@@ -1656,7 +1656,7 @@ static struct folio *stable_node_dup(str
 		 * stable_node parameter itself will be freed from
 		 * under us if it returns NULL.
 		 */
-		folio = ksm_get_folio(dup, GET_KSM_PAGE_NOLOCK);
+		folio = ksm_get_folio(dup, KSM_GET_FOLIO_NOLOCK);
 		if (!folio)
 			continue;
 		nr += 1;
@@ -1779,7 +1779,7 @@ static struct folio *__stable_node_chain
 	if (!is_stable_node_chain(stable_node)) {
 		if (is_page_sharing_candidate(stable_node)) {
 			*_stable_node_dup = stable_node;
-			return ksm_get_folio(stable_node, GET_KSM_PAGE_NOLOCK);
+			return ksm_get_folio(stable_node, KSM_GET_FOLIO_NOLOCK);
 		}
 		/*
 		 * _stable_node_dup set to NULL means the stable_node
@@ -1887,7 +1887,7 @@ again:
 			 * fine to continue the walk.
 			 */
 			tree_folio = ksm_get_folio(stable_node_any,
-						   GET_KSM_PAGE_NOLOCK);
+						   KSM_GET_FOLIO_NOLOCK);
 		}
 		VM_BUG_ON(!stable_node_dup ^ !!stable_node_any);
 		if (!tree_folio) {
@@ -1948,7 +1948,7 @@ again:
 			 * than kpage, but that involves more changes.
 			 */
 			tree_folio = ksm_get_folio(stable_node_dup,
-						   GET_KSM_PAGE_TRYLOCK);
+						   KSM_GET_FOLIO_TRYLOCK);
 
 			if (PTR_ERR(tree_folio) == -EBUSY)
 				return ERR_PTR(-EBUSY);
@@ -2120,7 +2120,7 @@ again:
 			 * fine to continue the walk.
 			 */
 			tree_folio = ksm_get_folio(stable_node_any,
-						   GET_KSM_PAGE_NOLOCK);
+						   KSM_GET_FOLIO_NOLOCK);
 		}
 		VM_BUG_ON(!stable_node_dup ^ !!stable_node_any);
 		if (!tree_folio) {
@@ -2611,7 +2611,7 @@ static struct ksm_rmap_item *scan_get_ne
 			list_for_each_entry_safe(stable_node, next,
 						 &migrate_nodes, list) {
 				folio = ksm_get_folio(stable_node,
-						      GET_KSM_PAGE_NOLOCK);
+						      KSM_GET_FOLIO_NOLOCK);
 				if (folio)
 					folio_put(folio);
 				cond_resched();
_

Patches currently in -mm which might be from david@redhat.com are


