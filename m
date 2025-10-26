Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C51257842
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761454573; cv=none; b=bUHRY+WGD/D8Bquxf/Ng6758LG+5B3gmEgCwZg3LqYPgIU1w2VlxZnZ1jOrbYXHsoozreqgB33NAy7/49vMtxqrQESaD10F8BIqjILKHbnE8XJfaFsNp6mlLSkXXBpmouGZDVvNkl84Jo5mS1s7X2IxRZiurSI31Un5gqvNtyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761454573; c=relaxed/simple;
	bh=DIvmDrsHee0oStlDtBQhhu21xBO8btX+plNQviLHsCw=;
	h=Date:To:From:Subject:Message-Id; b=fMiH2xW6ffqgyVeFBVCwKlHl9hCYoVUE1ArA24Q/F4a1maoTqZd2X95Z74em9yrrZBjoWCRh6fGLDlbx+ZdmKfwZSLV7BqnBQOTK7bXnbzhOxpaNmq13il9p/4fuFJo1bXnZ5lEUwf0r7OLHTARI5XNF0b2CzWTttbQHdz/KgzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcg5zYps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcg5zYps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93146C4CEE7;
	Sun, 26 Oct 2025 04:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761454572;
	bh=DIvmDrsHee0oStlDtBQhhu21xBO8btX+plNQviLHsCw=;
	h=Date:To:From:Subject:From;
	b=fcg5zYpsF7BTAjtr2ozVjNLwNacPgF2zDsTyUe5MBlrSNGW7psonSIMZLnfFX9ROJ
	 /4j1r/sfZEkUsIYM0q7DKFvwU8vD6kJxU19YAqavf2pOhdKq+4rnZIbD4qsZUwe9m3
	 S8hwC5NkPFYXesIOKnVEl6qPfi3ckK/eQhwpXT4A=
Date: Sat, 25 Oct 2025 21:56:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,hughd@google.com,hannes@cmpxchg.org,djwong@kernel.org,david@redhat.com,david@fromorbit.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-unmap-large-folio-on-split-failure.patch added to mm-new branch
Message-Id: <20251026045612.93146C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: unmap large folio on split failure
has been added to the -mm mm-new branch.  Its filename is
     mm-truncate-unmap-large-folio-on-split-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-unmap-large-folio-on-split-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/truncate: unmap large folio on split failure
Date: Mon, 20 Oct 2025 14:08:21 +0100

Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
supposed to generate SIGBUS.

This behavior might not be respected on truncation.

During truncation, the kernel splits a large folio in order to reclaim
memory.  As a side effect, it unmaps the folio and destroys PMD mappings
of the folio.  The folio will be refaulted as PTEs and SIGBUS semantics
are preserved.

However, if the split fails, PMD mappings are preserved and the user will
not receive SIGBUS on any accesses within the PMD.

Unmap the folio on split failure.  It will lead to refault as PTEs and
preserve SIGBUS semantics.

Link: https://lkml.kernel.org/r/20251023093251.54146-1-kirill@shutemov.name
Link: https://lkml.kernel.org/r/efm75n5srtb4xp5akp4x6sq6522p4hivzge7ufwnkodsw2yixt@ahntf6d2qe4h
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/mm/truncate.c~mm-truncate-unmap-large-folio-on-split-failure
+++ a/mm/truncate.c
@@ -177,6 +177,29 @@ int truncate_inode_folio(struct address_
 	return 0;
 }
 
+static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+				    unsigned long min_order)
+{
+	enum ttu_flags ttu_flags =
+		TTU_SYNC |
+		TTU_SPLIT_HUGE_PMD |
+		TTU_IGNORE_MLOCK;
+	int ret;
+
+	ret = try_folio_split_to_order(folio, split_at, min_order);
+
+	/*
+	 * If the split fails, unmap the folio, so it will be refaulted
+	 * with PTEs to respect SIGBUS semantics.
+	 */
+	if (ret) {
+		try_to_unmap(folio, ttu_flags);
+		WARN_ON(folio_mapped(folio));
+	}
+
+	return ret;
+}
+
 /*
  * Handle partial folios.  The folio may be entirely within the
  * range if a split has raced with us.  If not, we zero the part of the
@@ -226,7 +249,7 @@ bool truncate_inode_partial_folio(struct
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_to_order(folio, split_at, min_order)) {
+	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -250,13 +273,10 @@ bool truncate_inode_partial_folio(struct
 		if (!folio_trylock(folio2))
 			goto out;
 
-		/*
-		 * make sure folio2 is large and does not change its mapping.
-		 * Its split result does not matter here.
-		 */
+		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_to_order(folio2, split_at2, min_order);
+			try_folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
_

Patches currently in -mm which might be from kas@kernel.org are

mm-memory-do-not-populate-page-table-entries-beyond-i_size.patch
mm-truncate-unmap-large-folio-on-split-failure.patch

