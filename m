Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD751A9B4D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274534; cv=none; b=axczWquxGBVb7w4SgbZF+qcmYJD+PbQxaSuJsnQGTfLCbeJMYk1JbnXcNfGzlFpcZ7OZ/mS0hLJYKQ+Rn+7cO+MOVkQcaFqNEsVvOFOzEkPQKGc6I3CMHaq0jO/xq0/437FLJqUjwO6Xd6LMDAif02LtdgrpsnTPmsUyDWsftIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274534; c=relaxed/simple;
	bh=YuIkbCaA8YKfR5Wwjs65Tm81oGilaKE7JgfHD5noydE=;
	h=Date:To:From:Subject:Message-Id; b=fy2IGAhP92NXt5FQJv+9lnJo+4Sb9TcOVyAh67Ioeq1HApKeS+Ge0OlKXaKhRdkTUZYS0rAzO88XBiRHBIDAzs7ZGOIMEpoqyBzM68+SKcYSoyIVjEWVPI0HV2i2gFgLWHpQ7DBVjJvGscnp3MOcCUjNyn3c49FkobaVnHJGNdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eQtqE89j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eQtqE89j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4B9C4CEDD;
	Tue, 18 Mar 2025 05:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274534;
	bh=YuIkbCaA8YKfR5Wwjs65Tm81oGilaKE7JgfHD5noydE=;
	h=Date:To:From:Subject:From;
	b=eQtqE89jDW3bUdNSDvFSohw5tv4NQQ+7iWEt84hSN0FvGL6QE6Uz64+owzjphLWAA
	 iEtnfpK17Vjp91JiGOb2lzDl8TYFywjPYwGPbp8p9Gy/jr4sZWK2jZkPxeD3QaDV2Z
	 u7RZF9Imm4TQODJowMIze8kegr1fR4rQQ9yzS9Fs=
Date: Mon, 17 Mar 2025 22:08:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch removed from -mm tree
Message-Id: <20250318050854.0D4B9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move _entire_mapcount in folio to page[2] on 32bit
has been removed from the -mm tree.  Its filename was
     mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: move _entire_mapcount in folio to page[2] on 32bit
Date: Mon, 3 Mar 2025 17:29:59 +0100

Let's free up some space on 32bit in page[1] by moving the _pincount to
page[2].

Ordinary folios only use the entire mapcount with PMD mappings, so order-1
folios don't apply.  Similarly, hugetlb folios are always larger than
order-1, turning the entire mapcount essentially unused for all order-1
folios.  Moving it to order-1 folios will not change anything.

On 32bit, simply check in folio_entire_mapcount() whether we have an
order-1 folio, and return 0 in that case.

Note that THPs on 32bit are not particularly common (and we don't care too
much about performance), but we want to keep it working reliably, because
likely we want to use large folios there as well in the future,
independent of PMD leaf support.

Once we dynamically allocate "struct folio", the 32bit specifics will go
away again; even small folios could then have a pincount.

Link: https://lkml.kernel.org/r/20250303163014.1128035-7-david@redhat.com
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

 include/linux/mm.h       |    2 ++
 include/linux/mm_types.h |    3 ++-
 mm/internal.h            |    5 +++--
 mm/page_alloc.c          |   12 ++++++++----
 4 files changed, 15 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-move-_entire_mapcount-in-folio-to-page-on-32bit
+++ a/include/linux/mm.h
@@ -1333,6 +1333,8 @@ static inline int is_vmalloc_or_module_a
 static inline int folio_entire_mapcount(const struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+	if (!IS_ENABLED(CONFIG_64BIT) && unlikely(folio_large_order(folio) == 1))
+		return 0;
 	return atomic_read(&folio->_entire_mapcount) + 1;
 }
 
--- a/include/linux/mm_types.h~mm-move-_entire_mapcount-in-folio-to-page-on-32bit
+++ a/include/linux/mm_types.h
@@ -385,9 +385,9 @@ struct folio {
 				struct {
 	/* public: */
 					atomic_t _large_mapcount;
-					atomic_t _entire_mapcount;
 					atomic_t _nr_pages_mapped;
 #ifdef CONFIG_64BIT
+					atomic_t _entire_mapcount;
 					atomic_t _pincount;
 #endif /* CONFIG_64BIT */
 	/* private: the union with struct page is transitional */
@@ -411,6 +411,7 @@ struct folio {
 	/* public: */
 			struct list_head _deferred_list;
 #ifndef CONFIG_64BIT
+			atomic_t _entire_mapcount;
 			atomic_t _pincount;
 #endif /* !CONFIG_64BIT */
 	/* private: the union with struct page is transitional */
--- a/mm/internal.h~mm-move-_entire_mapcount-in-folio-to-page-on-32bit
+++ a/mm/internal.h
@@ -762,10 +762,11 @@ static inline void prep_compound_head(st
 
 	folio_set_order(folio, order);
 	atomic_set(&folio->_large_mapcount, -1);
-	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
-	if (IS_ENABLED(CONFIG_64BIT) || order > 1)
+	if (IS_ENABLED(CONFIG_64BIT) || order > 1) {
 		atomic_set(&folio->_pincount, 0);
+		atomic_set(&folio->_entire_mapcount, -1);
+	}
 	if (order > 1)
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
--- a/mm/page_alloc.c~mm-move-_entire_mapcount-in-folio-to-page-on-32bit
+++ a/mm/page_alloc.c
@@ -947,10 +947,6 @@ static int free_tail_page_prepare(struct
 	switch (page - head_page) {
 	case 1:
 		/* the first tail page: these may be in place of ->mapping */
-		if (unlikely(folio_entire_mapcount(folio))) {
-			bad_page(page, "nonzero entire_mapcount");
-			goto out;
-		}
 		if (unlikely(folio_large_mapcount(folio))) {
 			bad_page(page, "nonzero large_mapcount");
 			goto out;
@@ -960,6 +956,10 @@ static int free_tail_page_prepare(struct
 			goto out;
 		}
 		if (IS_ENABLED(CONFIG_64BIT)) {
+			if (unlikely(atomic_read(&folio->_entire_mapcount) + 1)) {
+				bad_page(page, "nonzero entire_mapcount");
+				goto out;
+			}
 			if (unlikely(atomic_read(&folio->_pincount))) {
 				bad_page(page, "nonzero pincount");
 				goto out;
@@ -973,6 +973,10 @@ static int free_tail_page_prepare(struct
 			goto out;
 		}
 		if (!IS_ENABLED(CONFIG_64BIT)) {
+			if (unlikely(atomic_read(&folio->_entire_mapcount) + 1)) {
+				bad_page(page, "nonzero entire_mapcount");
+				goto out;
+			}
 			if (unlikely(atomic_read(&folio->_pincount))) {
 				bad_page(page, "nonzero pincount");
 				goto out;
_

Patches currently in -mm which might be from david@redhat.com are


