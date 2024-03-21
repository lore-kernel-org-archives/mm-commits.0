Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42231134420
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055018; cv=none; b=s/XK7ga1THeVAXCaqdwLsPAVzmw/+TVbcylDk6aJzOwiX9IegMTPOmT9jWknr3t1UqPXCEcJ0mecWzpqOQNIOyK+CTfyIZzqT/Q7aiz7JeNL/1iR4Ie3fV0GyOf49vmpmijXcwoPvilgYHPdO1WSnLe0oIU+0LX1ulRLPmJHuBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055018; c=relaxed/simple;
	bh=WV1FntiCZvz/ap/KHqqAS/JlzLj6thp3LPeIs556WFw=;
	h=Date:To:From:Subject:Message-Id; b=H9KuwGMCykf7TiPIa7sBWWRpF2gApxEXQhF8mS4fG8k/4rZ8/jK8t9tp6dcH+G0btD14YpOH6pN6b+G4JBnLhOK2qS96dooUYTXtsJ3Dm79DuTbF3AhKlCYsBhKRY8C7Ud2s+xgMEfterdMLcLIcHk0izdEf4tFdfsE+qp5wybc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KdU6f7iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KdU6f7iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96CDC433C7;
	Thu, 21 Mar 2024 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055017;
	bh=WV1FntiCZvz/ap/KHqqAS/JlzLj6thp3LPeIs556WFw=;
	h=Date:To:From:Subject:From;
	b=KdU6f7iy0YIliEPwtZrvhsExdvu1PhPmhg3rIlc4lv9OgTNT250SVWiHcdraUBfng
	 1BTZTP2p93LhQ1VgxQ0nM/oQ+ajH9sRjRx++yoDdcJvxgEmY4vt54vS5/awCRtiMeN
	 PalY7g63YLOAntp7Gd3TZsjHzWFlTMJ4DGOANzic=
Date: Thu, 21 Mar 2024 14:03:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-improve-dumping-of-mapcount-and-page_type.patch added to mm-unstable branch
Message-Id: <20240321210337.B96CDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: improve dumping of mapcount and page_type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-improve-dumping-of-mapcount-and-page_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-improve-dumping-of-mapcount-and-page_type.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: improve dumping of mapcount and page_type
Date: Thu, 21 Mar 2024 14:24:46 +0000

For pages that have a page_type, set the mapcount to 0, which will reduce
the confusion in people reading page dumps ("Why does this page have a
mapcount of -128?").  Now that hugetlbfs is a page_type, read the
entire_mapcount for any large folio; this is fine for all folios as no
user reuses the entire_mapcount field.

For pages which do not have a page type, do not print it to reduce
clutter.

Link: https://lkml.kernel.org/r/20240321142448.1645400-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/mm/debug.c~mm-improve-dumping-of-mapcount-and-page_type
+++ a/mm/debug.c
@@ -55,18 +55,14 @@ static void __dump_folio(struct folio *f
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-	int mapcount = 0;
+	int mapcount = atomic_read(&page->_mapcount) + 1;
 	char *type = "";
 
-	/*
-	 * page->_mapcount space in struct page is used by slab pages to
-	 * encode own info, and we must avoid calling page_folio() again.
-	 */
-	if (!folio_test_slab(folio)) {
-		mapcount = atomic_read(&page->_mapcount) + 1;
-		if (folio_test_large(folio))
-			mapcount += folio_entire_mapcount(folio);
-	}
+	/* Open-code page_mapcount() to avoid looking up a stale folio */
+	if (mapcount < 0)
+		mapcount = 0;
+	if (folio_test_large(folio))
+		mapcount += folio_entire_mapcount(folio);
 
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
@@ -99,7 +95,8 @@ static void __dump_folio(struct folio *f
 	 */
 	pr_warn("%sflags: %pGp%s\n", type, &folio->flags,
 		is_migrate_cma_folio(folio, pfn) ? " CMA" : "");
-	pr_warn("page_type: %pGt\n", &folio->page.page_type);
+	if (page_has_type(&folio->page))
+		pr_warn("page_type: %pGt\n", &folio->page.page_type);
 
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

