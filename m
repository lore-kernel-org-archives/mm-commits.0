Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF8B18A953
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011055; cv=none; b=fLQTTzBij6Xxj+2WIg33RLBZsDvKrFCGFAnAYhf/tRW9fIr96ZZD8/QqhZVm/VdjTZMljQiFRC34nUafDum5jjWm2Q9pMPZ+7b3dYUjo0khoO7AyTkkI5Mhl3+cOlo4jQlkKlsFq3xv9pWZB3IPzBpLIOqU3BubB9XL9qml+lu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011055; c=relaxed/simple;
	bh=9WDEW96Zxk/1qE2MGeywEun4SY45KOLjldzwgYgRYZI=;
	h=Date:To:From:Subject:Message-Id; b=VxrByRtD4sjP9fvqLJo6FnSMh5YCBmGKE/ptlye8Jk7YwiwYpg7xEuAtF1QekOrjT0l9Pji78VW/OFDVT1qbZGHOS6MGwFV/0J4cTRSc7zoFEuFjnrgp+3gzEKRlTlRr/QgjwqzxGEOb+RpZzb3aqErDRHa4Xna1jM8JqFX7eP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iKSpfxCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iKSpfxCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F3DC4CEE4;
	Mon, 12 May 2025 00:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011055;
	bh=9WDEW96Zxk/1qE2MGeywEun4SY45KOLjldzwgYgRYZI=;
	h=Date:To:From:Subject:From;
	b=iKSpfxCyfs3pNqTYMy/Ys7fC4op5UXBAfVYV2K97faYGxRc5VR01wNJg3JjleLB71
	 GbcgAkbDs3Dkgaa6uXPS8u8eQb/wv0/tPqWrURdlkCvSheQH9ydyTy/Wl4DE4E8Z5T
	 DIgFPZ+rwItcvYWG8Vl7Ea3oFbrvf1uoYZwnC060=
Date: Sun, 11 May 2025 17:50:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,linmiaohe@huawei.com,gehao@kylinos.cn,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-parameter-passed-to-page_mapcount_is_type.patch removed from -mm tree
Message-Id: <20250512005055.61F3DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix parameter passed to page_mapcount_is_type()
has been removed from the -mm tree.  Its filename was
     mm-fix-parameter-passed-to-page_mapcount_is_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm: fix parameter passed to page_mapcount_is_type()
Date: Fri, 21 Mar 2025 22:02:21 +1000

Patch series "Fix parameter passed to page_mapcount_is_type()", v2.

Found by code inspection.  There are two places where the parameter passed
to page_mapcount_is_type() is (page->_mapcount), which is incorrect since
it should be one more than the value, as explained in the comments to
page_mapcount_is_type(): (a) page_has_type() in page-flags.h (b)
__dump_folio() in mm/debug.c

PATCH[1] fixes the parameter for (a)
PATCH[2] fixes the parameter for (b)

Note that the issue doesn't cause any visible impacts due to the safety
gap introduced by PGTY_mapcount_underflow limit.  So the tag 'Cc:
stable@vger.kernel.org' isn't needed.


This patch (of 2):

As the comments of page_mapcount_is_type() indicate, the parameter passed
to the function should be one more than page->_mapcount.  However,
page->_mapcount (equivalent to page->page_type) is passed to the function
by commit 4ffca5a96678 ("mm: support only one page_type per page")
page_type_has_type() is replaced by page_mapcount_is_type(), but the
parameter isn't adjusted.

Fix it by replacing page_mapcount_is_type() with page_type_has_type() in
page_has_type().  Note that the issue doesn't cause any visible impacts
due to the safety gap introduced by PGTY_mapcount_underflow limit.

Link: https://lkml.kernel.org/r/20250321120222.1456770-1-gshan@redhat.com
Link: https://lkml.kernel.org/r/20250321120222.1456770-2-gshan@redhat.com
Fixes: 4ffca5a96678 ("mm: support only one page_type per page")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: gehao <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-fix-parameter-passed-to-page_mapcount_is_type
+++ a/include/linux/page-flags.h
@@ -982,7 +982,7 @@ static inline bool page_mapcount_is_type
 
 static inline bool page_has_type(const struct page *page)
 {
-	return page_mapcount_is_type(data_race(page->page_type));
+	return page_type_has_type(data_race(page->page_type));
 }
 
 #define FOLIO_TYPE_OPS(lname, fname)					\
_

Patches currently in -mm which might be from gshan@redhat.com are


