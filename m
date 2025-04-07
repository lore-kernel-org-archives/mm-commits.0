Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA61221F1C
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 05:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744002492; cv=none; b=mCzjRMLZewExowVShO3gxd6Or+z05oFB86FV52nYbinabD3/YMK4j/dahBb4cjD1BdeTsuAnnHNgnsowq5BLEIfx1vKeHZZjWpwbEHRLBgLp4Q+QPHbFEE1Ul4wQ4BmkwqkGgZFvy0xVNqgZV4AZmNrSlYGGwojFw96dgwGUmZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744002492; c=relaxed/simple;
	bh=7gDSPKR6rW6KJ/+kydevXlP79sZtAhUM3qjEOxiYjag=;
	h=Date:To:From:Subject:Message-Id; b=H27qI0X26a3jFa8ebzs4n5GGNL1eq5PKD2t5idro+Vuv5ezLoYjiGkp5a2tYKSZUFdEvDDAy1zNGGPguM1N+9arHNrUtZrY6tXyiQhfTCETVIKnpI8dBvFgim316iDUUcMnA3Nke94DxOvbhzSMOm9aUV1GTGc4hVo9y3hRNJTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qejzmF2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qejzmF2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F99C4CEDD;
	Mon,  7 Apr 2025 05:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744002491;
	bh=7gDSPKR6rW6KJ/+kydevXlP79sZtAhUM3qjEOxiYjag=;
	h=Date:To:From:Subject:From;
	b=qejzmF2/yI7ElpVLOaq9ha5t9QKWx9ziPdJVe6X2Gmu5ZyuF2/Pn2fndhZpXLHsmG
	 DaC2iUG9w116y4Y77wvcvJyXiq93hirVJZtSKvOdVl3nfGWidP0jx3xhgWchozLghD
	 liIJCYt5DriT877V+43gR0iQ4514owvW8xM1JIgo=
Date: Sun, 06 Apr 2025 22:08:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,linmiaohe@huawei.com,gehao@kylinos.cn,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch added to mm-new branch
Message-Id: <20250407050811.D3F99C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug: fix parameter passed to page_mapcount_is_type()
has been added to the -mm mm-new branch.  Its filename is
     mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch

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
Subject: mm/debug: fix parameter passed to page_mapcount_is_type()
Date: Fri, 21 Mar 2025 22:02:22 +1000

As the comments of page_mapcount_is_type() indicate, the parameter passed
to the function should be one more than page->_mapcount.  However,
page->_mapcount is passed to the function by commit 4ffca5a96678 ("mm:
support only one page_type per page") where page_type_has_type() is
replaced by page_mapcount_is_type(), but the parameter isn't adjusted.

Fix the parameter for page_mapcount_is_type() to be (page->__mapcount +
1).  Note that the issue doesn't cause any visible impacts due to the
safety gap introduced by PGTY_mapcount_underflow limit.

Link: https://lkml.kernel.org/r/20250321120222.1456770-3-gshan@redhat.com
Fixes: 4ffca5a96678 ("mm: support only one page_type per page")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: gehao <gehao@kylinos.cn>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug.c~mm-debug-fix-parameter-passed-to-page_mapcount_is_type
+++ a/mm/debug.c
@@ -71,10 +71,10 @@ static void __dump_folio(struct folio *f
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-	int mapcount = atomic_read(&page->_mapcount);
+	int mapcount = atomic_read(&page->_mapcount) + 1;
 	char *type = "";
 
-	mapcount = page_mapcount_is_type(mapcount) ? 0 : mapcount + 1;
+	mapcount = page_mapcount_is_type(mapcount) ? 0 : mapcount;
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-fix-parameter-passed-to-page_mapcount_is_type.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch

