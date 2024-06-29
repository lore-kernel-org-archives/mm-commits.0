Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38A57494
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628199; cv=none; b=FSUvHSgt/qYOiNf+akgvlugqEYh1alxGchSsz6jiQcOHLsUahMpWE8jwklo4GLkv6SK8erL7P3IZGgZB71XX48gAppzjbTlEcNiTrWJLFfPooD1i4TGEwVaNJKm/JZ5/nV5ya7uaXL/Hlg7vgTTwUQCA9X/YNzMn4YPZnvdWdZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628199; c=relaxed/simple;
	bh=awlcGn/yZLrVXqkqR68qnaJSJJ8pfOp2QcIXSv/XDyg=;
	h=Date:To:From:Subject:Message-Id; b=l6iwbLZmTa/2Kpq4ZaWmJKg/5moXmQh+xTWRlNp8HUaRZjlwbNiDEh1qp5ndm4VtarLeZxfWf3OhPX3h86qUSnDpe8Q5SWc0gjAHc44WFzDN1klTnAbcERHupNBnFUG/YOsy5xEczboRiFVSADfxWePZEtMDk9GzxfdINNyZ3eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OOu81XMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OOu81XMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5CDC116B1;
	Sat, 29 Jun 2024 02:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628199;
	bh=awlcGn/yZLrVXqkqR68qnaJSJJ8pfOp2QcIXSv/XDyg=;
	h=Date:To:From:Subject:From;
	b=OOu81XMWu33aF9JuXyCBBbS2qV5ThnEMe9kCIHfDH6he43EdbQT1so/HbATdYv2XQ
	 Fm1dzFskvPUuzFHE8US9gWIhUyZuPbi/d0Q+V7Q2fVZrCse+vXfIghsZMtRHEecFt8
	 ePdBow0scapqMaSPzC0l9tninhdav00TWNKkkTwk=
Date: Fri, 28 Jun 2024 19:29:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch removed from -mm tree
Message-Id: <20240629022959.7E5CDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: initialize page->_mapcount directly in __init_single_page()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/mm_init: initialize page->_mapcount directly in __init_single_page()
Date: Wed, 29 May 2024 13:19:04 +0200

Let's simply reinitialize the page->_mapcount directly.  We can now get
rid of page_mapcount_reset().

Link: https://lkml.kernel.org/r/20240529111904.2069608-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>	[zram/zsmalloc workloads]
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 -----
 mm/mm_init.c       |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page
+++ a/include/linux/mm.h
@@ -1210,11 +1210,6 @@ static inline int folio_entire_mapcount(
 	return atomic_read(&folio->_entire_mapcount) + 1;
 }
 
-static inline void page_mapcount_reset(struct page *page)
-{
-	atomic_set(&(page)->_mapcount, -1);
-}
-
 static inline int folio_large_mapcount(const struct folio *folio)
 {
 	VM_WARN_ON_FOLIO(!folio_test_large(folio), folio);
--- a/mm/mm_init.c~mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page
+++ a/mm/mm_init.c
@@ -569,7 +569,7 @@ void __meminit __init_single_page(struct
 	mm_zero_struct_page(page);
 	set_page_links(page, zone, nid, pfn);
 	init_page_count(page);
-	page_mapcount_reset(page);
+	atomic_set(&page->_mapcount, -1);
 	page_cpupid_reset_last(page);
 	page_kasan_tag_reset(page);
 
_

Patches currently in -mm which might be from david@redhat.com are


