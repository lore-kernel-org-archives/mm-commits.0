Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248F318B477
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249648; cv=none; b=bzMjGJ+NuxwubOzBw+c/iXIb/31lBh0zUih2ifciFxY0jV69cQU9VEerzMeorWAm8nTSX03n9414d8lQ78BIEtBUfhU26RQTj4bWpEogqt7kM2JGadyCbgsDghfO1obu80tNWd9dCtq1BWfjvsSYXFcCcAVINbnDCOLMJOw/6+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249648; c=relaxed/simple;
	bh=iLkR2/rwogGtpB6KEbAGAJWDG2BgGcauWK6yLXKPdF0=;
	h=Date:To:From:Subject:Message-Id; b=IIgHMri6KJ+HO+a7b/fc5Gb2KBeoc/3rhEbdnFtkVoSQ04RF6zVrigJYN0H5pK7NWzay4kGuxPo9erbo+UB8q8h/Qo34aVKvVYP+ORAoG1noLNEvcJ75hbxNggakPv/TJ8pfEsC93qLeFexmciJw2JKu5530PbMfX2tRuQLbY/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RUuBMDhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RUuBMDhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFBBC4CED1;
	Thu, 26 Dec 2024 21:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249648;
	bh=iLkR2/rwogGtpB6KEbAGAJWDG2BgGcauWK6yLXKPdF0=;
	h=Date:To:From:Subject:From;
	b=RUuBMDhpDtJ+zHhjQdHG14bZIAeI5+tk7WwQ9HJK3rsnR0CTgZ2eCDIHRynrHvjHb
	 Aoh7a1/y6rOmPYlv1fnjTGCMxyG/dZvqRgorLwxfM2jP7Ic3rKLnkQaKYqNONzLnJQ
	 ZDYE/8xt8/WBXX1lASLZvkAhYONHqTyfWS4nSUps=
Date: Thu, 26 Dec 2024 13:47:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch added to mm-unstable branch
Message-Id: <20241226214727.ECFBBC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: introduce __zpdesc_clear/set_zsmalloc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

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
Subject: mm/zsmalloc: introduce __zpdesc_clear/set_zsmalloc()
Date: Tue, 17 Dec 2024 00:04:49 +0900

Add helper __zpdesc_clear_zsmalloc() for __ClearPageZsmalloc(),
__zpdesc_set_zsmalloc() for __SetPageZsmalloc(), and use them in callers.

[42.hyeyoo@gmail.com: keep reset_zpdesc() to use struct page]
Link: https://lkml.kernel.org/r/20241216150450.1228021-19-42.hyeyoo@gmail.com
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h   |   10 ++++++++++
 mm/zsmalloc.c |    6 +++---
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/mm/zpdesc.h~mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc
+++ a/mm/zpdesc.h
@@ -155,6 +155,16 @@ static inline void __zpdesc_set_movable(
 	__SetPageMovable(zpdesc_page(zpdesc), mops);
 }
 
+static inline void __zpdesc_set_zsmalloc(struct zpdesc *zpdesc)
+{
+	__SetPageZsmalloc(zpdesc_page(zpdesc));
+}
+
+static inline void __zpdesc_clear_zsmalloc(struct zpdesc *zpdesc)
+{
+	__ClearPageZsmalloc(zpdesc_page(zpdesc));
+}
+
 static inline bool zpdesc_is_isolated(struct zpdesc *zpdesc)
 {
 	return PageIsolated(zpdesc_page(zpdesc));
--- a/mm/zsmalloc.c~mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc
+++ a/mm/zsmalloc.c
@@ -1001,13 +1001,13 @@ static struct zspage *alloc_zspage(struc
 		if (!zpdesc) {
 			while (--i >= 0) {
 				zpdesc_dec_zone_page_state(zpdescs[i]);
-				__ClearPageZsmalloc(zpdesc_page(zpdescs[i]));
+				__zpdesc_clear_zsmalloc(zpdescs[i]);
 				free_zpdesc(zpdescs[i]);
 			}
 			cache_free_zspage(pool, zspage);
 			return NULL;
 		}
-		__SetPageZsmalloc(zpdesc_page(zpdesc));
+		__zpdesc_set_zsmalloc(zpdesc);
 
 		zpdesc_inc_zone_page_state(zpdesc);
 		zpdescs[i] = zpdesc;
@@ -1786,7 +1786,7 @@ static int zs_page_migrate(struct page *
 	VM_BUG_ON_PAGE(!zpdesc_is_isolated(zpdesc), zpdesc_page(zpdesc));
 
 	/* We're committed, tell the world that this is a Zsmalloc page. */
-	__SetPageZsmalloc(zpdesc_page(newzpdesc));
+	__zpdesc_set_zsmalloc(newzpdesc);
 
 	/* The page is locked, so this pointer must remain valid */
 	zspage = get_zspage(zpdesc);
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch
mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch
mm-zsmalloc-convert-create_page_chain-and-its-users-to-use-zpdesc.patch
mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch
mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch
mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch
mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

