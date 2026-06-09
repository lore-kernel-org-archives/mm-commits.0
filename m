Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F24E377543
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781027823; cv=none; b=KWlhfY2PpU7ZTOeKn3adwRrOzRLrXeAgeeDDfi4EBw1k1sVascf0J+/n1eFFMJkaXYn7HXQFqm4Xah4GvGFC5MMLWqiSQu/jlyyAan4NtBGtMxq27cyxDXIPrH0on6jyM83FdBjf4f32zaokjHDTwROsesY9XytVV4giV5dQDig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781027823; c=relaxed/simple;
	bh=VJg6KH+3NSZXGMRXzXZy/BME/V47gRWCxMJyPQanBHw=;
	h=Date:To:From:Subject:Message-Id; b=PKSJoKJfEy5EvzRaKfPYhfg6yWhySUyY/HDDjZuFJbs9JGhuFNALgEbgv/rQJl6l9VrTtPfjXW9BFU+jJZ89kdUi/qjr3Jo0GRN6TFlR4KmhTy0zkBIeXm7t3cngtuLi5ec92CIBHFWIWaXCjhJDrC8O1HwJAgRrm0YZUoBwIAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cm3LKR4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cm3LKR4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B281F00893;
	Tue,  9 Jun 2026 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781027819;
	bh=UTh6FW0nBdGQLb4jRAYemioxbdNt9x7y2WmdGHCjji4=;
	h=Date:To:From:Subject;
	b=Cm3LKR4ewWuuisKj8EZu8kFkmg/w6S/F4EwBgKu1bP4HpJ/opRs2UA8pI1yb6uHtb
	 BzpLBnWOZ0cixXINZ4CjpbMoeHd3eqqXV2VQ8o0I8OLmc3GDL+EuvqGE9XwZnWdmsD
	 IwxCO4094HOW63PYGeTmc16zGTPt88/+G+9maMX0=
Date: Tue, 09 Jun 2026 10:56:59 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-merge-writeout-into-pageout.patch added to mm-unstable branch
Message-Id: <20260609175659.D0B281F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: merge writeout into pageout
has been added to the -mm mm-unstable branch.  Its filename is
     mm-merge-writeout-into-pageout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-merge-writeout-into-pageout.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: merge writeout into pageout
Date: Mon, 1 Jun 2026 13:34:28 +0200

writeout is only called from pageout, and a straight flow at the end, so
merge the two functions.

Link: https://lore.kernel.org/20260601113449.3464734-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   63 +++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

--- a/mm/vmscan.c~mm-merge-writeout-into-pageout
+++ a/mm/vmscan.c
@@ -612,45 +612,14 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
-static pageout_t writeout(struct folio *folio, struct address_space *mapping,
-		struct swap_iocb **plug, struct list_head *folio_list)
-{
-	int res;
-
-	folio_set_reclaim(folio);
-
-	/*
-	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
-	 * or we failed to allocate contiguous swap entries, in which case
-	 * the split out folios get added back to folio_list.
-	 */
-	if (shmem_mapping(mapping))
-		res = shmem_writeout(folio, plug, folio_list);
-	else
-		res = swap_writeout(folio, plug);
-
-	if (res < 0)
-		handle_write_error(mapping, folio, res);
-	if (res == AOP_WRITEPAGE_ACTIVATE) {
-		folio_clear_reclaim(folio);
-		return PAGE_ACTIVATE;
-	}
-
-	/* synchronous write? */
-	if (!folio_test_writeback(folio))
-		folio_clear_reclaim(folio);
-
-	trace_mm_vmscan_write_folio(folio);
-	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
-	return PAGE_SUCCESS;
-}
-
 /*
  * pageout is called by shrink_folio_list() for each dirty folio.
  */
 static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 			 struct swap_iocb **plug, struct list_head *folio_list)
 {
+	int res;
+
 	/*
 	 * We no longer attempt to writeback filesystem folios here, other
 	 * than tmpfs/shmem.  That's taken care of in page-writeback.
@@ -674,7 +643,33 @@ static pageout_t pageout(struct folio *f
 		return PAGE_ACTIVATE;
 	if (!folio_clear_dirty_for_io(folio))
 		return PAGE_CLEAN;
-	return writeout(folio, mapping, plug, folio_list);
+
+	folio_set_reclaim(folio);
+
+	/*
+	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
+	 * or we failed to allocate contiguous swap entries, in which case
+	 * the split out folios get added back to folio_list.
+	 */
+	if (shmem_mapping(mapping))
+		res = shmem_writeout(folio, plug, folio_list);
+	else
+		res = swap_writeout(folio, plug);
+
+	if (res < 0)
+		handle_write_error(mapping, folio, res);
+	if (res == AOP_WRITEPAGE_ACTIVATE) {
+		folio_clear_reclaim(folio);
+		return PAGE_ACTIVATE;
+	}
+
+	/* synchronous write? */
+	if (!folio_test_writeback(folio))
+		folio_clear_reclaim(folio);
+
+	trace_mm_vmscan_write_folio(folio);
+	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
+	return PAGE_SUCCESS;
 }
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are

mm-merge-writeout-into-pageout.patch

