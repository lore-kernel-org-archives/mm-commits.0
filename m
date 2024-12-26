Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEB115CD52
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249644; cv=none; b=gJEmRTB9gPKG+lC2BrfoZa7EgFUfBvt1TTWl8GuX536Zgk342zQL6Ghqp0PboipB7A/8wi7ZqTsGfbU8rx/sj8u9xS/BnNaCrQuT1ZhdPzpO2nJyMCofvLBfq4UFrN/+KpeNR5+BZowCxTfUIDBVfXUM/PVDY9mIK1shdhcPaao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249644; c=relaxed/simple;
	bh=wrcIQ1Xxn9lRxpVAF+M9PeR53oxuHIt9HtA5pe/JDLs=;
	h=Date:To:From:Subject:Message-Id; b=a/Vz1zEYiFhlZeqL8tFgH4s633CVK8M9pvKwJ5Cq+8bYV+ZUg7vWE/vwRkWwN5XJqSSfWLcDN6VP5oAvkYTbBlIgog26QgGvnEooHjuCZT9gET05hlztRLnXMCnofmx756vh21oKX/v+Qd80wKSWL5jhRTTgFrNEHUMXnyU2hhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=myKpLO2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myKpLO2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0264AC4CED1;
	Thu, 26 Dec 2024 21:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249644;
	bh=wrcIQ1Xxn9lRxpVAF+M9PeR53oxuHIt9HtA5pe/JDLs=;
	h=Date:To:From:Subject:From;
	b=myKpLO2o4ssRQFxaB7qgl+H7wpCZZQ3SKH62vhG51fuvoSIIVUbY/8LsMXNHVg4mC
	 xijktk37tO79+gy82lJdkFj48jDr93kzzjbvIkVZyarCGaIKIITF80CVXTGO9Aw6Sv
	 PgEa5bnYVUVZWIuPCCxbcK5gMjS8BqDkzbx6wbM4=
Date: Thu, 26 Dec 2024 13:47:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch added to mm-unstable branch
Message-Id: <20241226214724.0264AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert SetZsPageMovable and remove unused funcs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch

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
Subject: mm/zsmalloc: convert SetZsPageMovable and remove unused funcs
Date: Tue, 17 Dec 2024 00:04:47 +0900

Convert SetZsPageMovable() to use zpdesc, and then remove unused funcs:
get_next_page()/get_first_page()/is_first_page().

Link: https://lkml.kernel.org/r/20241216150450.1228021-17-42.hyeyoo@gmail.com
Originally-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs
+++ a/mm/zsmalloc.c
@@ -452,11 +452,6 @@ static DEFINE_PER_CPU(struct mapping_are
 	.lock	= INIT_LOCAL_LOCK(lock),
 };
 
-static __maybe_unused int is_first_page(struct page *page)
-{
-	return PagePrivate(page);
-}
-
 static inline bool is_first_zpdesc(struct zpdesc *zpdesc)
 {
 	return PagePrivate(zpdesc_page(zpdesc));
@@ -473,14 +468,6 @@ static inline void mod_zspage_inuse(stru
 	zspage->inuse += val;
 }
 
-static inline struct page *get_first_page(struct zspage *zspage)
-{
-	struct page *first_page = zpdesc_page(zspage->first_zpdesc);
-
-	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
-	return first_page;
-}
-
 static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
 {
 	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
@@ -765,16 +752,6 @@ static struct zspage *get_zspage(struct
 	return zspage;
 }
 
-static struct page *get_next_page(struct page *page)
-{
-	struct zspage *zspage = get_zspage(page_zpdesc(page));
-
-	if (unlikely(ZsHugePage(zspage)))
-		return NULL;
-
-	return (struct page *)page->index;
-}
-
 static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 {
 	struct zspage *zspage = get_zspage(zpdesc);
@@ -1936,13 +1913,13 @@ static void init_deferred_free(struct zs
 
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage)
 {
-	struct page *page = get_first_page(zspage);
+	struct zpdesc *zpdesc = get_first_zpdesc(zspage);
 
 	do {
-		WARN_ON(!trylock_page(page));
-		__SetPageMovable(page, &zsmalloc_mops);
-		unlock_page(page);
-	} while ((page = get_next_page(page)) != NULL);
+		WARN_ON(!zpdesc_trylock(zpdesc));
+		__zpdesc_set_movable(zpdesc, &zsmalloc_mops);
+		zpdesc_unlock(zpdesc);
+	} while ((zpdesc = get_next_zpdesc(zpdesc)) != NULL);
 }
 #else
 static inline void zs_flush_migration(struct zs_pool *pool) { }
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch
mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch
mm-zsmalloc-convert-create_page_chain-and-its-users-to-use-zpdesc.patch
mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch
mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch
mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch
mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

