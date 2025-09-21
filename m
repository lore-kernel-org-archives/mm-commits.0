Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13DF28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489818; cv=none; b=HVjns6rw0S0BR7vH43CfHg2Q6/BkyjQuYTyEjhxmUQqXvp1NYLkyVRMsmqLdm5HR6EYxNmE7J2b2fL6NqRyR40q/d/MV1GxzX8rumZveBT5ft0ofcR9tn/jYjh4GiWG+N6Yy7cVKsgeirgM1NVtPkkBjEIIttxPlQem3rFn+VBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489818; c=relaxed/simple;
	bh=TzGTu7M8NEn7sJZ3tarvyUX7Ijr0c/5q2V9J072ICYg=;
	h=Date:To:From:Subject:Message-Id; b=JZEtTZNf4gzneddkirFvxQH21glUG4mabKSpyWXQU9mjjRkVxwKIfCUp3oT3b+zQ18Hxa5G8RIIs8k254dnd8XKvn/ArwNd5OZ3o1zZ/9IycTPmxCkQ1xlSYbme/43n5eOt2kfQnmgHZgJ0NbDNaOOgzziiVS45sQa6lA30Zi6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2bgR2r42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2bgR2r42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CC6C4CEE7;
	Sun, 21 Sep 2025 21:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489817;
	bh=TzGTu7M8NEn7sJZ3tarvyUX7Ijr0c/5q2V9J072ICYg=;
	h=Date:To:From:Subject:From;
	b=2bgR2r42qRQLD6VtXGWxIGnKuvWuOXCF8d5V9hbnPgIdPbVQ3BtWlP1svtqFZR+oQ
	 OGYAlhZPxGMkr/035UCgQv9zwWiZW8ymY0+RM/IbtiNnqwPOnkndanCg4QlMnQ24IV
	 +vy6fsN8UgN1FgFEoDYJM6pJPfMtn7olEFZz9KkY=
Date: Sun, 21 Sep 2025 14:23:37 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-make-memmap_init_compound-look-more-like-prep_compound_page.patch removed from -mm tree
Message-Id: <20250921212337.B5CC6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-make-memmap_init_compound-look-more-like-prep_compound_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
Date: Mon, 1 Sep 2025 17:03:30 +0200

Grepping for "prep_compound_page" leaves on clueless how devdax gets its
compound pages initialized.

Let's add a comment that might help finding this open-coded
prep_compound_page() initialization more easily.

Further, let's be less smart about the ordering of initialization and just
perform the prep_compound_head() call after all tail pages were
initialized: just like prep_compound_page() does.

No need for a comment to describe the initialization order: again, just
like prep_compound_page().

Link: https://lkml.kernel.org/r/20250901150359.867252-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-make-memmap_init_compound-look-more-like-prep_compound_page
+++ a/mm/mm_init.c
@@ -1091,6 +1091,12 @@ static void __ref memmap_init_compound(s
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
 
+	/*
+	 * We have to initialize the pages, including setting up page links.
+	 * prep_compound_page() does not take care of that, so instead we
+	 * open-code prep_compound_page() so we can take care of initializing
+	 * the pages in the same go.
+	 */
 	__SetPageHead(head);
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
@@ -1098,15 +1104,8 @@ static void __ref memmap_init_compound(s
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(head, pfn - head_pfn);
 		set_page_count(page, 0);
-
-		/*
-		 * The first tail page stores important compound page info.
-		 * Call prep_compound_head() after the first tail page has
-		 * been initialized, to not have the data overwritten.
-		 */
-		if (pfn == head_pfn + 1)
-			prep_compound_head(head, order);
 	}
+	prep_compound_head(head, order);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
_

Patches currently in -mm which might be from david@redhat.com are


