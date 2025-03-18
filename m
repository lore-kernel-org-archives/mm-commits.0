Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82E51A8418
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274548; cv=none; b=diX0dNYFYC63aCSCvfPQgtp/3MeeCJX9C2k7kfcSpMwFo8qV8RiAkbFdVHdqpjgDuNBBOgtd8ywNUAfbxRQ5gMjGHr9F7vyghB1XEfJaBblSPVfk+3D2XIMlNSMAwpfsRkTRQSjE0ap5TYwUxm2MyeJ3JtTpQ9dtfyMc25UmOgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274548; c=relaxed/simple;
	bh=nqlAYi4nx8+d7ErekEugtMKkFcmxwquGSTJ4/UGp+3Q=;
	h=Date:To:From:Subject:Message-Id; b=GLlycG148pRazE6vgQWWQxwOE+jiAJyo1W0fr3GV+or88YssUUfC27W/MULr51BZV/MVnwI67u4DLSjHXpC7TC+ckgK3ZkI2CW1pyG0aANsc04O6gtcetaMeijv+KY0HxS9bafhVnWfIOEtAEeZnzHJXFwOVrXfrRrNwtA9zoOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WWqQQPMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WWqQQPMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4B8C4CEDD;
	Tue, 18 Mar 2025 05:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274548;
	bh=nqlAYi4nx8+d7ErekEugtMKkFcmxwquGSTJ4/UGp+3Q=;
	h=Date:To:From:Subject:From;
	b=WWqQQPMK/Te5cWvCfnGGVlkPLxax209jT+5DrAklEn1/c7EezGFKQIXkyIOGwfEsd
	 BsrskmWAok7OoNn3z/QrQO5dD29DXa41fEtQAgi9JmlKdZ1ght/iRewXPS6O879y8+
	 8JRXLNOuEQvImKeJgX//NDctbpdP5SxH2xGBAY+8=
Date: Mon, 17 Mar 2025 22:09:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch removed from -mm tree
Message-Id: <20250318050908.AB4B8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/page: remove per-page mapcount dependency for /proc/kpagecount (CONFIG_NO_PAGE_MAPCOUNT)
has been removed from the -mm tree.  Its filename was
     fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/page: remove per-page mapcount dependency for /proc/kpagecount (CONFIG_NO_PAGE_MAPCOUNT)
Date: Mon, 3 Mar 2025 17:30:09 +0100

Let's implement an alternative when per-page mapcounts in large folios are
no longer maintained -- soon with CONFIG_NO_PAGE_MAPCOUNT.

For large folios, we'll return the per-page average mapcount within the
folio, whereby we round to the closest integer when calculating the
average: however, we'll always return at least 1 if the folio is mapped.

So assuming a folio with 512 pages, the average would be:
* 0 if not pages are mapped
* 1 if there are 1 .. 767 per-page mappings
* 2 if there are 767 .. 1279 per-page mappings
...

For hugetlb folios and for large folios that are fully mapped into all
address spaces, there is no change.

We'll make use of this helper in other context next.

As an alternative, we could simply return 0 for non-hugetlb large folios,
or disable this legacy interface with CONFIG_NO_PAGE_MAPCOUNT.

But the information exposed by this interface can still be valuable, and
frequently we deal with fully-mapped large folios where the average
corresponds to the actual page mapcount.  So we'll leave it like this for
now and document the new behavior.

Note: this interface is likely not very relevant for performance.  If ever
required, we could try doing a rather expensive rmap walk to collect
precisely how often this folio page is mapped.

Link: https://lkml.kernel.org/r/20250303163014.1128035-17-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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

 Documentation/admin-guide/mm/pagemap.rst |    7 +++-
 fs/proc/internal.h                       |   35 +++++++++++++++++++++
 fs/proc/page.c                           |   11 ++++--
 3 files changed, 49 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -43,7 +43,12 @@ There are four components to pagemap:
    skip over unmapped regions.
 
  * ``/proc/kpagecount``.  This file contains a 64-bit count of the number of
-   times each page is mapped, indexed by PFN.
+   times each page is mapped, indexed by PFN. Some kernel configurations do
+   not track the precise number of times a page part of a larger allocation
+   (e.g., THP) is mapped. In these configurations, the average number of
+   mappings per page in this larger allocation is returned instead. However,
+   if any page of the large allocation is mapped, the returned value will
+   be at least 1.
 
 The page-types tool in the tools/mm directory can be used to query the
 number of times a page is mapped.
--- a/fs/proc/internal.h~fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount
+++ a/fs/proc/internal.h
@@ -188,6 +188,41 @@ static inline int folio_precise_page_map
 	return mapcount;
 }
 
+/**
+ * folio_average_page_mapcount() - Average number of mappings per page in this
+ *				   folio
+ * @folio: The folio.
+ *
+ * The average number of user page table entries that reference each page in
+ * this folio as tracked via the RMAP: either referenced directly (PTE) or
+ * as part of a larger area that covers this page (e.g., PMD).
+ *
+ * The average is calculated by rounding to the nearest integer; however,
+ * to avoid duplicated code in current callers, the average is at least
+ * 1 if any page of the folio is mapped.
+ *
+ * Returns: The average number of mappings per page in this folio.
+ */
+static inline int folio_average_page_mapcount(struct folio *folio)
+{
+	int mapcount, entire_mapcount, avg;
+
+	if (!folio_test_large(folio))
+		return atomic_read(&folio->_mapcount) + 1;
+
+	mapcount = folio_large_mapcount(folio);
+	if (unlikely(mapcount <= 0))
+		return 0;
+	entire_mapcount = folio_entire_mapcount(folio);
+	if (mapcount <= entire_mapcount)
+		return entire_mapcount;
+	mapcount -= entire_mapcount;
+
+	/* Round to closest integer ... */
+	avg = ((unsigned int)mapcount + folio_large_nr_pages(folio) / 2) >> folio_large_order(folio);
+	/* ... but return at least 1. */
+	return max_t(int, avg + entire_mapcount, 1);
+}
 /*
  * array.c
  */
--- a/fs/proc/page.c~fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount
+++ a/fs/proc/page.c
@@ -67,9 +67,14 @@ static ssize_t kpagecount_read(struct fi
 		 * memmaps that were actually initialized.
 		 */
 		page = pfn_to_online_page(pfn);
-		if (page)
-			mapcount = folio_precise_page_mapcount(page_folio(page),
-							       page);
+		if (page) {
+			struct folio *folio = page_folio(page);
+
+			if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
+				mapcount = folio_precise_page_mapcount(folio, page);
+			else
+				mapcount = folio_average_page_mapcount(folio);
+		}
 
 		if (put_user(mapcount, out)) {
 			ret = -EFAULT;
_

Patches currently in -mm which might be from david@redhat.com are


