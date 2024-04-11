Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10101754B
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868455; cv=none; b=i2MS32lP0Q9EIqz33SbueCyLAmYS2QTK0vSGe6JvatiT+7wtQZBPYEFFoU0yqVw0jV8kHXnqsWP0fJi11Unt8Qfp7oArWp/z7IEHoEJRNilRNqA/DmCXXa9H26/laA1MYjF96PIQickX0gM68yu+Hxz2Xfo9QtPtJIu7/5K8Dac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868455; c=relaxed/simple;
	bh=RZAoDNTAYiZp6jN8aqBo346xo4FsgeBQ/lLAQauHsh0=;
	h=Date:To:From:Subject:Message-Id; b=bqMzqAuWnUTkcBzN8hIo7aDhTp6RCVJi5QGc6fQYpzfwY9zceUx1MoXtuC5Emrc5YrE4LqsNAbpafl3FQepS5E3QYSJMUowCDNDb8Idkel3llwqDO0KL/ICzewz/swK+/BBc8DeMQtcKXPI93Bw/wipcGnWD5uaoaLcPnUKADv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SEnpzB2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SEnpzB2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293BEC072AA;
	Thu, 11 Apr 2024 20:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712868455;
	bh=RZAoDNTAYiZp6jN8aqBo346xo4FsgeBQ/lLAQauHsh0=;
	h=Date:To:From:Subject:From;
	b=SEnpzB2eveJkqvy3xbzb/zPDBDUpMiEA1/gwp8sapamDk1Cspr5Oe3vvBdAi8Ay1F
	 QS00xQASo35SVTVd2ANtPbz9vw4bNQqwXQCQJ/tJFgjqUArbcaEK0zIJOiBdyhGjDs
	 kUx8GmEEcVf3iMq7nj/BGkeFyxlJ78Sk1pOMYNUI=
Date: Thu, 11 Apr 2024 13:47:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-use-folio-in-stable_node_dup.patch added to mm-unstable branch
Message-Id: <20240411204735.293BEC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: use folio in stable_node_dup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-use-folio-in-stable_node_dup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-use-folio-in-stable_node_dup.patch

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

mm-ksm-add-ksm_get_folio.patch
mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch
mm-ksm-add-folio_set_stable_node.patch
mm-ksm-use-folio-in-remove_stable_node.patch
mm-ksm-use-folio-in-stable_node_dup.patch
mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch
mm-ksm-use-folio-in-write_protect_page.patch
mm-ksm-convert-chain-series-funcs-and-replace-get_ksm_page.patch
mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch

