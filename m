Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59BE7346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006238; cv=none; b=KZm4Frs8qG4n7d7F2neXC4ptxoFcIQIUvdgMXf5UR125qySu0HzNXoio7APbaxY9SRDRFHQf5W3NFwGsgcYqNwzqy/g537Mned72pmP1N1mkLcxznpGo1FNpwaitHeEKVlPuHJBOhQVH15LfhnMcuU/v5zW1b3xZQIVY+04K9pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006238; c=relaxed/simple;
	bh=iI1Zb2yykDTR4Sx1n2eO/Je3r6aGTEAwpey1La2wPCU=;
	h=Date:To:From:Subject:Message-Id; b=Zc/AoNas/C0TuvcN/CXbB4Ii67uieueJvkBTmFKvWbf4oF0vuzG2FHY7gQ4QZUytGt2wJjIPrFWD6l51BDzYX9gIlkkMAzLw4RLBHzLDtQFrGLIh/BCpgeokbPWxQeNk+nvyUMEvvivpIW5XU5G0TQXXvpBexuGBJosyRJHAyZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TMj6LNhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TMj6LNhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB98C4CED6;
	Thu, 16 Jan 2025 05:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006238;
	bh=iI1Zb2yykDTR4Sx1n2eO/Je3r6aGTEAwpey1La2wPCU=;
	h=Date:To:From:Subject:From;
	b=TMj6LNhxXxl2Ou/wlDBzY9WJdtmGt0lh2J8O7gCwKYPSRMXQYzHynj1849zMVNm02
	 PZSEYpZi75fZwpD+ZmrgEj9HI6rgdVFOJs0RNouYOHdQPO26dZGq7LDbUm2F2Dq9Oh
	 SJ5Hvzn8ChWmveuzrjESUc3b9O+eaHWZMVBGGRlQ=
Date: Wed, 15 Jan 2025 21:43:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch removed from -mm tree
Message-Id: <20250116054358.9AB98C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: introduce __zpdesc_clear/set_zsmalloc()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


