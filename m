Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1325E158524
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006233; cv=none; b=QJsJBwHelImVSssFCw5KyiKXpg1Pjrh9tPSeKPUf462fKOLmp9v4ODjHmwG6Eo48KOfTvM8odmphn/Gl79cq2lsryGhBeggK4pjWlznagSlTh4TZNpv5w9kAVM/zCd6UiIW2v4RGQkVbZ4yOzcKEmfm3pPKuz1aGDybF52LcWCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006233; c=relaxed/simple;
	bh=7pZ5ZhXUKnqrt2XGjNo5sSwZzl+r62fQSFfe0Kfdhis=;
	h=Date:To:From:Subject:Message-Id; b=UlX/Ai892Z5ZMJBB3xdipg8oMsFDnU71RkkC174jm+bO4jlToBCoMdiSIB8sWwzuBAQLYy3g2UWnTbfvWUoNSBrn9+AOCY/1G+qkq8i8PA4+ECdEjG43E7NlgGVX3Sx86tfDuVG885G5T6Ev59xEpkpIwvpuJ5MyLpkExcPPvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SFrfOA8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SFrfOA8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FF0C4CED6;
	Thu, 16 Jan 2025 05:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006232;
	bh=7pZ5ZhXUKnqrt2XGjNo5sSwZzl+r62fQSFfe0Kfdhis=;
	h=Date:To:From:Subject:From;
	b=SFrfOA8fGSrI9v78Ec7XOE3xXB8LpDGj++HEhlPbQJWkAemRW7ACjl8ANsVrYSpNV
	 08/hHaCoNXxWmGhyrdk8TrvC7xDyC5n2+AEWJ4YHk8LcR2WHkVsbkDkWxWaO5PONMk
	 8zdeS10xs64mjVOWz2L/ezuVGlNcyk5tDb97+Y2A=
Date: Wed, 15 Jan 2025 21:43:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch removed from -mm tree
Message-Id: <20250116054352.D9FF0C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert location_to_obj() to take zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: convert location_to_obj() to take zpdesc
Date: Tue, 17 Dec 2024 00:04:44 +0900

As all users of location_to_obj() now use zpdesc, convert
location_to_obj() to take zpdesc.

Link: https://lkml.kernel.org/r/20241216150450.1228021-14-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-location_to_obj-to-take-zpdesc
+++ a/mm/zsmalloc.c
@@ -804,15 +804,15 @@ static void obj_to_zpdesc(unsigned long
 }
 
 /**
- * location_to_obj - get obj value encoded from (<page>, <obj_idx>)
- * @page: page object resides in zspage
+ * location_to_obj - get obj value encoded from (<zpdesc>, <obj_idx>)
+ * @zpdesc: zpdesc object resides in zspage
  * @obj_idx: object index
  */
-static unsigned long location_to_obj(struct page *page, unsigned int obj_idx)
+static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx)
 {
 	unsigned long obj;
 
-	obj = page_to_pfn(page) << OBJ_INDEX_BITS;
+	obj = zpdesc_pfn(zpdesc) << OBJ_INDEX_BITS;
 	obj |= obj_idx & OBJ_INDEX_MASK;
 
 	return obj;
@@ -1358,7 +1358,7 @@ static unsigned long obj_malloc(struct z
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
-	obj = location_to_obj(zpdesc_page(m_zpdesc), obj);
+	obj = location_to_obj(m_zpdesc, obj);
 	record_obj(handle, obj);
 
 	return obj;
@@ -1845,8 +1845,7 @@ static int zs_page_migrate(struct page *
 
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
-			new_obj = (unsigned long)location_to_obj(zpdesc_page(newzpdesc),
-								obj_idx);
+			new_obj = (unsigned long)location_to_obj(newzpdesc, obj_idx);
 			record_obj(handle, new_obj);
 		}
 	}
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


