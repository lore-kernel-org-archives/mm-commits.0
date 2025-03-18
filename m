Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8461D9A41
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274527; cv=none; b=mCZXaBSCDpaa5HKcKQnooWeSAuTdpcKvHHVa2FHdLU50eunnyget/lpyr4NgmD/faYRMwswsDViB83ArJxS26V6+a34HdBZhO5uCd7bBtLmBFf7ji3yk/YqA6HBBHdC0Eq0KyPQ6ry1dtNcpBsFDzDiz29sTd6AinTFXQUMQfTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274527; c=relaxed/simple;
	bh=NitNnThmmRX3prM9iaUA7NF15vZsaNa+TKwX9lCZxl0=;
	h=Date:To:From:Subject:Message-Id; b=QlTAiJxD0QJiK+nYFym2sLT3mpqaoXbkuyO50Gyll8ccgRqJyJMvIjFW9hws0oCIjyNn83QLZLd6foDEJ9Kf3OGQ6U+rfnsxv7xnkj0jaFMDOA9hIG+ZwkWG4jJe4cNGhySr8QdlXTFKSFEXx6+ORqkKqZcPkMsod50y+CjSzfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SxYPr7WT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SxYPr7WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C012BC4CEDD;
	Tue, 18 Mar 2025 05:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274526;
	bh=NitNnThmmRX3prM9iaUA7NF15vZsaNa+TKwX9lCZxl0=;
	h=Date:To:From:Subject:From;
	b=SxYPr7WTWyzUUyUxctfoCfFqITne88qddZR8brFq6y87Zem44Nywqo7ax1r0AX2dz
	 7lBYjmVls7ruRgKYluTac/cA0coC8deqLWReKTtGr25ojLLFmfKxr6BE+x45d7wpD3
	 17fnqjmSmHfTo8AFCJxOMb73pWMLuVrGf894iO0U=
Date: Mon, 17 Mar 2025 22:08:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch removed from -mm tree
Message-Id: <20250318050846.C012BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: factor out large folio handling from folio_nr_pages() into folio_large_nr_pages()
has been removed from the -mm tree.  Its filename was
     mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: factor out large folio handling from folio_nr_pages() into folio_large_nr_pages()
Date: Mon, 3 Mar 2025 17:29:55 +0100

Let's factor it out into a simple helper function.  This helper will also
come in handy when working with code where we know that our folio is
large.

While at it, let's consistently return a "long" value from all these
similar functions.  Note that we cannot use "unsigned int" (even though
_folio_nr_pages is of that type), because it would break some callers that
do stuff like "-folio_nr_pages()".  Both "int" or "unsigned long" would
work as well.

Maybe in the future we'll have the nr_pages readily available for all
large folios, maybe even for small folios, or maybe for none.

Link: https://lkml.kernel.org/r/20250303163014.1128035-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages
+++ a/include/linux/mm.h
@@ -1199,6 +1199,18 @@ static inline unsigned int folio_large_o
 	return folio->_flags_1 & 0xff;
 }
 
+#ifdef CONFIG_64BIT
+static inline long folio_large_nr_pages(const struct folio *folio)
+{
+	return folio->_folio_nr_pages;
+}
+#else
+static inline long folio_large_nr_pages(const struct folio *folio)
+{
+	return 1L << folio_large_order(folio);
+}
+#endif
+
 /*
  * compound_order() can be called without holding a reference, which means
  * that niceties like page_folio() don't work.  These callers should be
@@ -2147,11 +2159,7 @@ static inline long folio_nr_pages(const
 {
 	if (!folio_test_large(folio))
 		return 1;
-#ifdef CONFIG_64BIT
-	return folio->_folio_nr_pages;
-#else
-	return 1L << folio_large_order(folio);
-#endif
+	return folio_large_nr_pages(folio);
 }
 
 /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
@@ -2166,24 +2174,20 @@ static inline long folio_nr_pages(const
  * page.  compound_nr() can be called on a tail page, and is defined to
  * return 1 in that case.
  */
-static inline unsigned long compound_nr(struct page *page)
+static inline long compound_nr(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags))
 		return 1;
-#ifdef CONFIG_64BIT
-	return folio->_folio_nr_pages;
-#else
-	return 1L << folio_large_order(folio);
-#endif
+	return folio_large_nr_pages(folio);
 }
 
 /**
  * thp_nr_pages - The number of regular pages in this huge page.
  * @page: The head page of a huge page.
  */
-static inline int thp_nr_pages(struct page *page)
+static inline long thp_nr_pages(struct page *page)
 {
 	return folio_nr_pages((struct folio *)page);
 }
_

Patches currently in -mm which might be from david@redhat.com are


