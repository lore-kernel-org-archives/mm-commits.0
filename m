Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A0C7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103990; cv=none; b=OII0kJ6VZsYKuXuEL0dT7C3UCM7n+A8IfpeBVGB2opGDE6CTSYNq9aScvOmI8zt6n/JfnIJ/XszJlslG6UUEbuE0jqa60XmkcHwBsDGb+pHEpmtMacKLwsCwpqLuSKniIarTVc0ah5I6W/Uhb2fta1H0UxMl04dvwPsUO74rvFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103990; c=relaxed/simple;
	bh=C2hTT8QJPiSS/fgq5TSxcKHPHYcRpAXA9agbXnXG1iE=;
	h=Date:To:From:Subject:Message-Id; b=Thqzn/Hbf0fU9gK+NlMeFM+AlmYsfIMeAJ/GRzGCxc+UtT1JhimgmBPcG2KiGYoGChEHzk88lR7NEUWi7h3x3oBDLuY2zCGO5kdbSstUUtX9FVxZ2E4NIqOvbE7fxwCTFSCondnfbl0qm42CyM/CFwx43rbQLap01jNN47xDrFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jzHTmJMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jzHTmJMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F440C113CD;
	Fri, 26 Apr 2024 03:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103990;
	bh=C2hTT8QJPiSS/fgq5TSxcKHPHYcRpAXA9agbXnXG1iE=;
	h=Date:To:From:Subject:From;
	b=jzHTmJMkrEUhgpKglAuSBIzqishgdQ2N5zslHbqrUQfkB/UrD6qw6P84xxZgAixN9
	 OQDOq+AQcoJGEaHfmvOeOTw4OY/lJuXtevR+u8Ocr5yPtACGUh8de9/Z3nlXjd/sgZ
	 ZUWXu8zEoLndFnlo0AaOwMzr3lLrMOeMQp7rvQUY=
Date: Thu, 25 Apr 2024 20:59:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-clean-up-hugetlb-exclusion-code.patch removed from -mm tree
Message-Id: <20240426035950.8F440C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: clean up hugetlb exclusion code
has been removed from the -mm tree.  Its filename was
     mm-filemap-clean-up-hugetlb-exclusion-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/filemap: clean up hugetlb exclusion code
Date: Tue, 16 Apr 2024 01:18:54 +0800

__filemap_add_folio only has two callers, one never passes hugetlb folio
and one always passes in hugetlb folio.  So move the hugetlb related
cgroup charging out of it to make the code cleaner.

Link: https://lkml.kernel.org/r/20240415171857.19244-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/mm/filemap.c~mm-filemap-clean-up-hugetlb-exclusion-code
+++ a/mm/filemap.c
@@ -853,20 +853,12 @@ noinline int __filemap_add_folio(struct
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	bool huge = folio_test_hugetlb(folio);
-	bool charged = false;
-	long nr = 1;
+	long nr;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_swapbacked(folio), folio);
 	mapping_set_update(&xas, mapping);
 
-	if (!huge) {
-		int error = mem_cgroup_charge(folio, NULL, gfp);
-		if (error)
-			return error;
-		charged = true;
-	}
-
 	VM_BUG_ON_FOLIO(index & (folio_nr_pages(folio) - 1), folio);
 	xas_set_order(&xas, index, folio_order(folio));
 	nr = folio_nr_pages(folio);
@@ -931,8 +923,6 @@ unlock:
 	trace_mm_filemap_add_to_page_cache(folio);
 	return 0;
 error:
-	if (charged)
-		mem_cgroup_uncharge(folio);
 	folio->mapping = NULL;
 	/* Leave page->index set: truncation relies upon it */
 	folio_put_refs(folio, nr);
@@ -946,11 +936,16 @@ int filemap_add_folio(struct address_spa
 	void *shadow = NULL;
 	int ret;
 
+	ret = mem_cgroup_charge(folio, NULL, gfp);
+	if (ret)
+		return ret;
+
 	__folio_set_locked(folio);
 	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		mem_cgroup_uncharge(folio);
 		__folio_clear_locked(folio);
-	else {
+	} else {
 		/*
 		 * The folio might have been evicted from cache only
 		 * recently, in which case it should be activated like
_

Patches currently in -mm which might be from kasong@tencent.com are


