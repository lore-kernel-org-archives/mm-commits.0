Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AA6D310
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255741; cv=none; b=NxhMlqwzHywdIOF+BFLSVfLF+uiiooBl5nXjr0aTwSU49u4vfb3p+pIr4mYX/KqzzQWuQmgkAlasYUBlPv0jyoCc29kEyg2nrjJtFpe1Dj/hBKptVugkvwjfOokE9nsfWKPTkBsswTsCVRTUx/jVFCD7DLcsShn16Ph5zdSFDnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255741; c=relaxed/simple;
	bh=7ZH1/p9MqIq6rf/rTmMvXju4aeywFuvdSCc3Rwugc78=;
	h=Date:To:From:Subject:Message-Id; b=eaFJetSblLGrAwFCcOfcOeLNgiAn1x5HFjcPuwEziaZLl41Nth+ZvxKwyo0Z06X62qKnQEpjalmxuPYgvw27pL3yMKSDPe++C6i15kClSUcxVJOQVlJh4X1lJlP0isLQx4fwaYH5/Kr2QyUuvxWkBqAHh0nQKBpdoAf010814CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yhC2IrcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yhC2IrcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29279C433F1;
	Fri, 26 Jan 2024 07:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255740;
	bh=7ZH1/p9MqIq6rf/rTmMvXju4aeywFuvdSCc3Rwugc78=;
	h=Date:To:From:Subject:From;
	b=yhC2IrcGJMNwHfx1VfXfXcQbmRY2HW3tZxUXqc/O+J1Y5K9lUtu7I9Gun0dyx1vsD
	 ZLRffoONYpD5/qi4QXZBfScY8fPIgr1cyyv1AYQOiCAtGBScp0IHg0o1yFlZV9ebMz
	 3aeVS+7gWl+lCzmmOs4x1DUVy0lVlcH8RkGLZwK8=
Date: Thu, 25 Jan 2024 23:55:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty.patch removed from -mm tree
Message-Id: <20240126075540.29279C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix folio_set_dirty() vs. folio_mark_dirty()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: fix folio_set_dirty() vs. folio_mark_dirty()
Date: Mon, 22 Jan 2024 18:54:07 +0100

The correct folio replacement for "set_page_dirty()" is
"folio_mark_dirty()", not "folio_set_dirty()".  Using the latter won't
properly inform the FS using the dirty_folio() callback.

This has been found by code inspection, but likely this can result in some
real trouble.

Link: https://lkml.kernel.org/r/20240122175407.307992-1-david@redhat.com
Fixes: a8e61d584eda0 ("mm/huge_memory: page_remove_rmap() -> folio_remove_rmap_pmd()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty
+++ a/mm/huge_memory.c
@@ -2437,7 +2437,7 @@ static void __split_huge_pmd_locked(stru
 			page = pmd_page(old_pmd);
 			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
-				folio_set_dirty(folio);
+				folio_mark_dirty(folio);
 			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
 				folio_set_referenced(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
@@ -3563,7 +3563,7 @@ int set_pmd_migration_entry(struct page_
 	}
 
 	if (pmd_dirty(pmdval))
-		folio_set_dirty(folio);
+		folio_mark_dirty(folio);
 	if (pmd_write(pmdval))
 		entry = make_writable_migration_entry(page_to_pfn(page));
 	else if (anon_exclusive)
_

Patches currently in -mm which might be from david@redhat.com are


