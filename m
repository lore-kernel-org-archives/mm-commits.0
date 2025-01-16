Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F164A15ADB4
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006232; cv=none; b=E/vqQcWi6oNoPnBBWNSfCQlYl0TU3cHQjVL9Astq+oFGMLStagkb304UxzD0QH0tPE9Kh04zyL5PGrnVbfIYmiNLQrxES08UJjyEEiEZLu7CnVPh0oS73oCXUNYMWCK0J3M9/pIQDmAaymysVev2S3p3UPGhC3tq0O+BVVel8Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006232; c=relaxed/simple;
	bh=OHs1V+3q4D+4ebW9He41k6Wg++mS6FokL0l75efazjk=;
	h=Date:To:From:Subject:Message-Id; b=u6EGw0i4kuR72Mtnl3SrghZAIi5md1Cu66jDPVWyEWgbaQ6+c0wdDVEqiUA+Abrya9uJGS469UesXBfZJVxfE7o9Eim0MUGezyivcxe4HVbzUdmWBZ6Ung31yDHQjwL2i2F+/d5CY2Q3AD3WrvNFswm3f/Gg3UzK+X70Gq1mk8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Y9WTVnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Y9WTVnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC010C4CED6;
	Thu, 16 Jan 2025 05:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006231;
	bh=OHs1V+3q4D+4ebW9He41k6Wg++mS6FokL0l75efazjk=;
	h=Date:To:From:Subject:From;
	b=0Y9WTVnpMly7OXcPOTQ4kVyyodu3EzbQMo0ccBhrMOOZiqqhIZebV3c3jTKRIrP7q
	 gVH2oKpGt/nSVX1qxjuAbbt9ciMTbXwrklGKUwLFF9k6MhQMZAMRvbFqtB8xslIAZ7
	 VmTHCUUMF2uxvOeM4bPYYQ0BLa/LY6xP+D7y/RPE=
Date: Wed, 15 Jan 2025 21:43:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch removed from -mm tree
Message-Id: <20250116054351.BC010C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert __free_zspage() to use zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: convert __free_zspage() to use zpdesc
Date: Tue, 17 Dec 2024 00:04:43 +0900

Introduce zpdesc_is_locked() and convert __free_zspage() to use zpdesc.

Link: https://lkml.kernel.org/r/20241216150450.1228021-13-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h   |    4 ++++
 mm/zsmalloc.c |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

--- a/mm/zpdesc.h~mm-zsmalloc-convert-__free_zspage-to-use-zpdesc
+++ a/mm/zpdesc.h
@@ -165,4 +165,8 @@ static inline struct zone *zpdesc_zone(s
 	return page_zone(zpdesc_page(zpdesc));
 }
 
+static inline bool zpdesc_is_locked(struct zpdesc *zpdesc)
+{
+	return folio_test_locked(zpdesc_folio(zpdesc));
+}
 #endif
--- a/mm/zsmalloc.c~mm-zsmalloc-convert-__free_zspage-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -878,23 +878,23 @@ unlock:
 static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 				struct zspage *zspage)
 {
-	struct page *page, *next;
+	struct zpdesc *zpdesc, *next;
 
 	assert_spin_locked(&class->lock);
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
-	next = page = get_first_page(zspage);
+	next = zpdesc = get_first_zpdesc(zspage);
 	do {
-		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		next = get_next_page(page);
-		reset_zpdesc(page_zpdesc(page));
-		unlock_page(page);
-		dec_zone_page_state(page, NR_ZSPAGES);
-		put_page(page);
-		page = next;
-	} while (page != NULL);
+		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
+		next = get_next_zpdesc(zpdesc);
+		reset_zpdesc(zpdesc);
+		zpdesc_unlock(zpdesc);
+		zpdesc_dec_zone_page_state(zpdesc);
+		zpdesc_put(zpdesc);
+		zpdesc = next;
+	} while (zpdesc != NULL);
 
 	cache_free_zspage(pool, zspage);
 
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


