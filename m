Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3CF18635
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957026; cv=none; b=e/n83SfEZ8cA//CxbSItS2VSwhBZ0bIqOcr5hCAMxKllCt6FQ45r1IaI/gNKK+Y6jDNi7Udn847lzQa8VpCRsueVIDydt1VvezRDVMtrVUSzXvVumWd+O+c2PMIZdCMl2xep3Nejfp4tw1OCpeHR/48vayp7mnBwF3mvcmZOSyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957026; c=relaxed/simple;
	bh=iXImNqLlZDkBf+Kll/QQMg8ZIJIf2UYEZ1yXCrYeY3o=;
	h=Date:To:From:Subject:Message-Id; b=FKBSl/P/5JIqrSVTKz/Aibo48aghPTTsBwb9NkVv8MwtipbAwSMtxV/apNoLMcXrmlxS00J5n/Cn19LAghS/v4p6bJqpNfjKbSpYxzg0aa9cyUmUpgp+ci72P+OHsdvuBYohPgStddEEP5SmIhxySgR9yxHzyEt68ge7MaokFJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vOeA8l3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vOeA8l3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C6EC116B1;
	Mon,  6 May 2024 00:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957025;
	bh=iXImNqLlZDkBf+Kll/QQMg8ZIJIf2UYEZ1yXCrYeY3o=;
	h=Date:To:From:Subject:From;
	b=vOeA8l3eFGvqMeMYpGmHx6yrQ6d4fMomG8aSyuR723xd+dpcbxEbeLg/zA6asqdv4
	 6r0I/ADTm07ogdEmUf7G4jNmL1KfT9x6asb9aDyVP7OKszp+pc/iva9tSt91OPmSsQ
	 AYf/F+0wXZ7J/rZPWwdkRzlFa7HObVcrgsh5fDn8=
Date: Sun, 05 May 2024 17:57:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-use-folio-in-stable_node_dup.patch removed from -mm tree
Message-Id: <20240506005705.D5C6EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: use folio in stable_node_dup
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-folio-in-stable_node_dup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: use folio in stable_node_dup
Date: Thu, 11 Apr 2024 14:17:06 +0800

Use ksm_get_folio() and save 2 compound_head calls.

Link: https://lkml.kernel.org/r/20240411061713.1847574-6-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-folio-in-stable_node_dup
+++ a/mm/ksm.c
@@ -1638,7 +1638,7 @@ static struct page *stable_node_dup(stru
 {
 	struct ksm_stable_node *dup, *found = NULL, *stable_node = *_stable_node;
 	struct hlist_node *hlist_safe;
-	struct page *_tree_page, *tree_page = NULL;
+	struct folio *folio, *tree_folio = NULL;
 	int nr = 0;
 	int found_rmap_hlist_len;
 
@@ -1657,24 +1657,24 @@ static struct page *stable_node_dup(stru
 		 * We must walk all stable_node_dup to prune the stale
 		 * stable nodes during lookup.
 		 *
-		 * get_ksm_page can drop the nodes from the
+		 * ksm_get_folio can drop the nodes from the
 		 * stable_node->hlist if they point to freed pages
 		 * (that's why we do a _safe walk). The "dup"
 		 * stable_node parameter itself will be freed from
 		 * under us if it returns NULL.
 		 */
-		_tree_page = get_ksm_page(dup, GET_KSM_PAGE_NOLOCK);
-		if (!_tree_page)
+		folio = ksm_get_folio(dup, GET_KSM_PAGE_NOLOCK);
+		if (!folio)
 			continue;
 		nr += 1;
 		if (is_page_sharing_candidate(dup)) {
 			if (!found ||
 			    dup->rmap_hlist_len > found_rmap_hlist_len) {
 				if (found)
-					put_page(tree_page);
+					folio_put(tree_folio);
 				found = dup;
 				found_rmap_hlist_len = found->rmap_hlist_len;
-				tree_page = _tree_page;
+				tree_folio = folio;
 
 				/* skip put_page for found dup */
 				if (!prune_stale_stable_nodes)
@@ -1682,7 +1682,7 @@ static struct page *stable_node_dup(stru
 				continue;
 			}
 		}
-		put_page(_tree_page);
+		folio_put(folio);
 	}
 
 	if (found) {
@@ -1747,7 +1747,7 @@ static struct page *stable_node_dup(stru
 	}
 
 	*_stable_node_dup = found;
-	return tree_page;
+	return &tree_folio->page;
 }
 
 static struct ksm_stable_node *stable_node_dup_any(struct ksm_stable_node *stable_node,
_

Patches currently in -mm which might be from alexs@kernel.org are


