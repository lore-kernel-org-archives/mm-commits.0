Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A03713C80D
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249615; cv=none; b=XqlnC7gDLT6lVkyTqXrWabGvCI03yHq11+qL+WEX1k6DUlaH26H1h/TKjnbO1MFlEScSgrjvntetjwJWSLAy5lnn42kIwq1l+sxnv4Q7XhNTfRmZddxJks1LBWMPmXlDKDXtf09hx/oQHmiVK17k8+SxHq4Z83Q2mgizwxUGYS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249615; c=relaxed/simple;
	bh=z1bJF+u58MZYCoIFIi13Jx6cLgsderHhvisMs4avZ70=;
	h=Date:To:From:Subject:Message-Id; b=YwhWPObbBhP42+2mZbS4otJpEI/mS7eZXaAUG6P0WEN53D98YfLhpNPFao8ViTOd/N6ncdDGwl/Fg/NwjZCYF0k5JkEuk5KTbVOhljRFzG/5nSZZz2UGiqklnm3jFCMduSQ2AvLoqEu2mm3CYdSWpoa8NpEGG1tN4TFEPfk5wTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ne9YMAlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ne9YMAlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B656C4CED1;
	Thu, 26 Dec 2024 21:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249614;
	bh=z1bJF+u58MZYCoIFIi13Jx6cLgsderHhvisMs4avZ70=;
	h=Date:To:From:Subject:From;
	b=ne9YMAlCcTJ3tzVhT2ktzzLS4ROPoFX5tZm5O9+YjNRWrp3H4AUE+7thZ4baW5woq
	 nhrzbC7BgOCtKlIR/m7HcjImN1nTEfixfkPMtre74qjCg+ydN8KQAecVcbOamNFbM2
	 EwzakbekLI7TC/rXOkKdkDl9u/fWUWN99TM53Nus=
Date: Thu, 26 Dec 2024 13:46:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch added to mm-unstable branch
Message-Id: <20241226214654.9B656C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: use zpdesc in trylock_zspage()/lock_zspage()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch

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
From: Alex Shi <alexs@kernel.org>
Subject: mm/zsmalloc: use zpdesc in trylock_zspage()/lock_zspage()
Date: Tue, 17 Dec 2024 00:04:33 +0900

Convert trylock_zspage() and lock_zspage() to use zpdesc. To achieve
that, introduce a couple of helper functions:
  - zpdesc_lock()
  - zpdesc_unlock()
  - zpdesc_trylock()
  - zpdesc_wait_locked()
  - zpdesc_get()
  - zpdesc_put()

Here we use the folio version of functions for 2 reasons.  First,
zswap.zpool currently only uses order-0 pages and using folio could save
some compound_head checks.  Second, folio_put could bypass devmap checking
that we don't need.

BTW, thanks Intel LKP found a build warning on the patch.

Originally-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Link: https://lkml.kernel.org/r/20241216150450.1228021-3-42.hyeyoo@gmail.com
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h   |   30 ++++++++++++++++++++++
 mm/zsmalloc.c |   64 ++++++++++++++++++++++++++++++++----------------
 2 files changed, 73 insertions(+), 21 deletions(-)

--- a/mm/zpdesc.h~mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage
+++ a/mm/zpdesc.h
@@ -104,4 +104,34 @@ static_assert(sizeof(struct zpdesc) <= s
 	const struct page *:		(const struct zpdesc *)(p),	\
 	struct page *:			(struct zpdesc *)(p)))
 
+static inline void zpdesc_lock(struct zpdesc *zpdesc)
+{
+	folio_lock(zpdesc_folio(zpdesc));
+}
+
+static inline bool zpdesc_trylock(struct zpdesc *zpdesc)
+{
+	return folio_trylock(zpdesc_folio(zpdesc));
+}
+
+static inline void zpdesc_unlock(struct zpdesc *zpdesc)
+{
+	folio_unlock(zpdesc_folio(zpdesc));
+}
+
+static inline void zpdesc_wait_locked(struct zpdesc *zpdesc)
+{
+	folio_wait_locked(zpdesc_folio(zpdesc));
+}
+
+static inline void zpdesc_get(struct zpdesc *zpdesc)
+{
+	folio_get(zpdesc_folio(zpdesc));
+}
+
+static inline void zpdesc_put(struct zpdesc *zpdesc)
+{
+	folio_put(zpdesc_folio(zpdesc));
+}
+
 #endif
--- a/mm/zsmalloc.c~mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage
+++ a/mm/zsmalloc.c
@@ -428,13 +428,17 @@ static __maybe_unused int is_first_page(
 	return PagePrivate(page);
 }
 
+static inline bool is_first_zpdesc(struct zpdesc *zpdesc)
+{
+	return PagePrivate(zpdesc_page(zpdesc));
+}
+
 /* Protected by class->lock */
 static inline int get_zspage_inuse(struct zspage *zspage)
 {
 	return zspage->inuse;
 }
 
-
 static inline void mod_zspage_inuse(struct zspage *zspage, int val)
 {
 	zspage->inuse += val;
@@ -448,6 +452,14 @@ static inline struct page *get_first_pag
 	return first_page;
 }
 
+static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
+{
+	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
+
+	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
+	return first_zpdesc;
+}
+
 #define FIRST_OBJ_PAGE_TYPE_MASK	0xffffff
 
 static inline unsigned int get_first_obj_offset(struct page *page)
@@ -734,6 +746,16 @@ static struct page *get_next_page(struct
 	return (struct page *)page->index;
 }
 
+static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
+{
+	struct zspage *zspage = get_zspage(zpdesc_page(zpdesc));
+
+	if (unlikely(ZsHugePage(zspage)))
+		return NULL;
+
+	return zpdesc->next;
+}
+
 /**
  * obj_to_location - get (<page>, <obj_idx>) from encoded object value
  * @obj: the encoded object value
@@ -803,11 +825,11 @@ static void reset_page(struct page *page
 
 static int trylock_zspage(struct zspage *zspage)
 {
-	struct page *cursor, *fail;
+	struct zpdesc *cursor, *fail;
 
-	for (cursor = get_first_page(zspage); cursor != NULL; cursor =
-					get_next_page(cursor)) {
-		if (!trylock_page(cursor)) {
+	for (cursor = get_first_zpdesc(zspage); cursor != NULL; cursor =
+					get_next_zpdesc(cursor)) {
+		if (!zpdesc_trylock(cursor)) {
 			fail = cursor;
 			goto unlock;
 		}
@@ -815,9 +837,9 @@ static int trylock_zspage(struct zspage
 
 	return 1;
 unlock:
-	for (cursor = get_first_page(zspage); cursor != fail; cursor =
-					get_next_page(cursor))
-		unlock_page(cursor);
+	for (cursor = get_first_zpdesc(zspage); cursor != fail; cursor =
+					get_next_zpdesc(cursor))
+		zpdesc_unlock(cursor);
 
 	return 0;
 }
@@ -1635,7 +1657,7 @@ static int putback_zspage(struct size_cl
  */
 static void lock_zspage(struct zspage *zspage)
 {
-	struct page *curr_page, *page;
+	struct zpdesc *curr_zpdesc, *zpdesc;
 
 	/*
 	 * Pages we haven't locked yet can be migrated off the list while we're
@@ -1647,24 +1669,24 @@ static void lock_zspage(struct zspage *z
 	 */
 	while (1) {
 		migrate_read_lock(zspage);
-		page = get_first_page(zspage);
-		if (trylock_page(page))
+		zpdesc = get_first_zpdesc(zspage);
+		if (zpdesc_trylock(zpdesc))
 			break;
-		get_page(page);
+		zpdesc_get(zpdesc);
 		migrate_read_unlock(zspage);
-		wait_on_page_locked(page);
-		put_page(page);
+		zpdesc_wait_locked(zpdesc);
+		zpdesc_put(zpdesc);
 	}
 
-	curr_page = page;
-	while ((page = get_next_page(curr_page))) {
-		if (trylock_page(page)) {
-			curr_page = page;
+	curr_zpdesc = zpdesc;
+	while ((zpdesc = get_next_zpdesc(curr_zpdesc))) {
+		if (zpdesc_trylock(zpdesc)) {
+			curr_zpdesc = zpdesc;
 		} else {
-			get_page(page);
+			zpdesc_get(zpdesc);
 			migrate_read_unlock(zspage);
-			wait_on_page_locked(page);
-			put_page(page);
+			zpdesc_wait_locked(zpdesc);
+			zpdesc_put(zpdesc);
 			migrate_read_lock(zspage);
 		}
 	}
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch
mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch
mm-zsmalloc-convert-create_page_chain-and-its-users-to-use-zpdesc.patch
mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch
mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch
mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch
mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

