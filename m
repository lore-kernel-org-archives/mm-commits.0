Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77EF18A953
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011056; cv=none; b=ThWJzVQ3YxuVkrjxhIdbjRDpeVtnPRSLpQbq0ks4g8EW1KvhIJYRMwToK6rv7sLDu3AuWt0WRpfy2Qjk7eEL1J1w/MlUEV0IesE3+nxjJr6JSf9nIaw/Xv9y+qa9AcFBV5RP3it7/zb4Yq6+8Wo5byfp9u9wxpGoW8Zb2rjzpXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011056; c=relaxed/simple;
	bh=ytbDqux3c2RmOzbFjPzwjc9pOM78XISS7L96Ak395KI=;
	h=Date:To:From:Subject:Message-Id; b=jUmu0ZeoJFxmRgdJ36CIjAAawK2Io5rlw5RoVlG9iS7IcZJJY0GxA4RWm6zECkGRWoUPpRjl1VVadmrLMNVPjn0OEUOQj/snLplYqPUjUzvCaVlu+QOwGqBrUVGHw7Os4v4CCuGDOXS7nxYLkNH9Wj6FPXJUuI4UrMxrf1H7ebA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZleZPluB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZleZPluB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1F2C4CEE4;
	Mon, 12 May 2025 00:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011056;
	bh=ytbDqux3c2RmOzbFjPzwjc9pOM78XISS7L96Ak395KI=;
	h=Date:To:From:Subject:From;
	b=ZleZPluBjOGUFmSTOHe0qA8qNVZOYeZuVNuf1IWtTspzecOBJ2rg6k57yjvu6LO6F
	 sFAWZntdPO6w83jUd9XmQBG9jvfx4dfZVNz7fLc7C6wKGu3zccyhpL88qPctZ6rbaH
	 RqSdHSwvpEmIs24nsEcqwn0bKg0TgWuZie0dzdwk=
Date: Sun, 11 May 2025 17:50:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,linmiaohe@huawei.com,gehao@kylinos.cn,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch removed from -mm tree
Message-Id: <20250512005056.9C1F2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug: fix parameter passed to page_mapcount_is_type()
has been removed from the -mm tree.  Its filename was
     mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: simplify __dump_folio(), per David]
Link: https://lkml.kernel.org/r/20250321120222.1456770-3-gshan@redhat.com
Fixes: 4ffca5a96678 ("mm: support only one page_type per page")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: gehao <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/debug.c~mm-debug-fix-parameter-passed-to-page_mapcount_is_type
+++ a/mm/debug.c
@@ -71,10 +71,12 @@ static void __dump_folio(struct folio *f
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-	int mapcount = atomic_read(&page->_mapcount);
+	int mapcount = atomic_read(&page->_mapcount) + 1;
 	char *type = "";
 
-	mapcount = page_mapcount_is_type(mapcount) ? 0 : mapcount + 1;
+	if (page_mapcount_is_type(mapcount))
+		mapcount = 0;
+
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
_

Patches currently in -mm which might be from gshan@redhat.com are


