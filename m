Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E225E1EEA27
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119288; cv=none; b=YEJFHChS3JfSy5J3fUR+z13FqFn6G9lpW3A5NCC5EwLYe0aOwh1ZKDUd7ZeSRavvoZmV89vWVWkCkQAurZQDrObmIOSzsM+7VuO2yItA1DzOAV24RNRkwwcVup5S2GDCjrJI9SMBhVsC+Lh2EgCVC4fEFSyf/hnP1QKHnnWgex4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119288; c=relaxed/simple;
	bh=xNZZZuA+aFy9BZ3FD4tOO6kuHbB3Hga2nHrf8DtWGSM=;
	h=Date:To:From:Subject:Message-Id; b=aF3Ov5ssI9SRh4Wdae4/AzPJG1PclxMKDTpdI59WYBeZ3EndWSmEQ+OrcXDiVYxBVL2GJ4wQPmQj8+/eOxA+wyyeo2zczlBh2ieM1xn608pDOuz4hciv2YTiTKJ8N+ra9iS0mqwHcRiyZYydlkLPmlZu6TRKVCc7XulGE14wWQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YVNlrpoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YVNlrpoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8420C4CEE4;
	Tue, 13 May 2025 06:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119287;
	bh=xNZZZuA+aFy9BZ3FD4tOO6kuHbB3Hga2nHrf8DtWGSM=;
	h=Date:To:From:Subject:From;
	b=YVNlrpoU4dAepdAr/taQ5mNw59EV1ki6anJ+5dYzOMGU/hOIhyG2rUtg7UN58Zx+2
	 ipLK9/n88sZXZsOSS3UHGSALR5FkpRidlNuMbT7yH7o206iZi2qS8KNVPGFbWaPhiN
	 ZIHtjCJ5Tcv6p3oHh2k9+DzzpRekSh/ngkpxlCI0=
Date: Mon, 12 May 2025 23:54:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,hannes@cmpxchg.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-workingset-simplify-lockdep-check-in-update_node.patch removed from -mm tree
Message-Id: <20250513065447.B8420C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: workingset: simplify lockdep check in update_node
has been removed from the -mm tree.  Its filename was
     mm-workingset-simplify-lockdep-check-in-update_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm: workingset: simplify lockdep check in update_node
Date: Mon, 21 Apr 2025 18:16:28 +0100

container_of(node->array, ..., i_pages) just to access i_pages again is an
incredibly roundabout way of accessing node->array itself.  Simplify it.

Link: https://lkml.kernel.org/r/20250421-workingset-simplify-v1-1-de5c40051e0e@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/workingset.c~mm-workingset-simplify-lockdep-check-in-update_node
+++ a/mm/workingset.c
@@ -612,7 +612,6 @@ struct list_lru shadow_nodes;
 
 void workingset_update_node(struct xa_node *node)
 {
-	struct address_space *mapping;
 	struct page *page = virt_to_page(node);
 
 	/*
@@ -623,8 +622,7 @@ void workingset_update_node(struct xa_no
 	 * already where they should be. The list_empty() test is safe
 	 * as node->private_list is protected by the i_pages lock.
 	 */
-	mapping = container_of(node->array, struct address_space, i_pages);
-	lockdep_assert_held(&mapping->i_pages.xa_lock);
+	lockdep_assert_held(&node->array->xa_lock);
 
 	if (node->count && node->count == node->nr_values) {
 		if (list_empty(&node->private_list)) {
_

Patches currently in -mm which might be from pfalcato@suse.de are


