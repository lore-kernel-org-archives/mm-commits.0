Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3942AE90
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 05:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744002490; cv=none; b=JsYJcnhM9wSrPJ9unmspxQMQktEXf5HDn8hNOlYLd0P4ahOSvltmowZ60hu4j5kENowh+lSPqQ0BXSZWacwdRFm+ZhjMsbLobXty+auUSrdJBjqQHNtiN98P8xGIse1w445tR3OZjeTAo//arDs/5jmWGCiLHrDoWy6vzGa5ptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744002490; c=relaxed/simple;
	bh=zbOX0r3tbLQ22AW7RkSnpTYhzEZOlndiweOFULWH9zs=;
	h=Date:To:From:Subject:Message-Id; b=JwJkZ21qpVxfc3OoaZfv1W6EOHT2B8fCZWinjOUa9laZ8Ms1IY+d4bK2cpXUtd0ymyrpezCVFxeKt9m0pQ7KbSOP9NzUMADSC85GPnXW1olwRIgIe4PisKUxb76jpAl3ssRo51RZSZg8cIuy+wWTr6C2MKsbVuHEfatfAn1f2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UUYV3Rjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UUYV3Rjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6854C4CEDD;
	Mon,  7 Apr 2025 05:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744002490;
	bh=zbOX0r3tbLQ22AW7RkSnpTYhzEZOlndiweOFULWH9zs=;
	h=Date:To:From:Subject:From;
	b=UUYV3RjmkoUnu/wNIPUz7oJQKkG8gLNmqNQ6LARS33QhRsActMaEJjZD7CSyeL0Zb
	 aNze0PxRmgROAakD3DxUIgsLa3Y4D+buk1ShWFC+zmkYViUZbQGvjfsKk0tTDnx4nO
	 4NRawSsfcC9mTIu093Ph2NnOKKh52Soi2HacWSOE=
Date: Sun, 06 Apr 2025 22:08:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,linmiaohe@huawei.com,gehao@kylinos.cn,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-parameter-passed-to-page_mapcount_is_type.patch added to mm-new branch
Message-Id: <20250407050809.E6854C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix parameter passed to page_mapcount_is_type()
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-parameter-passed-to-page_mapcount_is_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-parameter-passed-to-page_mapcount_is_type.patch

This patch will later appear in the mm-new branch at
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
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
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

mm-fix-parameter-passed-to-page_mapcount_is_type.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch

