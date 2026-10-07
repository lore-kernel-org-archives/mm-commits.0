Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E6A2F8EA6
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334238; cv=none; b=QMWQD3PW0dddMXabF4SjZoifqFxXGHF/Fkzc/T6fwTUhib1aY3OFXLG3AkoarGbRJV7roqE13MFpK9R484aX0weV2oH2B0OQlIoj/Gu80HH5I3arJ54BY7WAdwOfZen2ydpKQRLPLmo2CbabGaFyveCBV2+9Iip74Yva2qRxCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334238; c=relaxed/simple;
	bh=CiNABWUIGm+ScklZpjQ9XLSJQ5afoVSbhnhrPy+zj4o=;
	h=Date:To:From:Subject:Message-Id; b=WMz6nI9ESShK6y4MhUtlA9x0wFVK1pyYQrdfA+egHdb4m3QUI5epWkjQ45VVDZj+DUlDJUo8jQwpu7Kol5FaY57FIAiK3M2JD2zbR+NVjYubAZNNispGt4vt5Gam7Un4Cw3FVY4YOFdO9W5qmEJF6hA9C4JBNS72rVknW5LmUME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=19PohPAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="19PohPAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BFD1F0089B;
	Wed,  7 Oct 2026 00:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334237;
	bh=uVqhM5IMdu9Ui88+zTM8FAXs72TpBnBixY4t65T/Fgs=;
	h=Date:To:From:Subject;
	b=19PohPATJ1/7whYrSjAp2gBk/xxYFUwTtfYuRfSmXt55uIJQvgkHXSKKkyV0QXy08
	 OB9GY/ztfacXZLRjLsrlX7unrRhBKVAYKAaUup2Fk+hBZZ+VEd074GzQ/gIUWbMYwI
	 HufQlxA3P9v/F9Fjf6L9NY5XZTmmOt9lE0NVi49U=
Date: Tue, 06 Oct 2026 17:50:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,thnkslprpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-simplify-error-handling-in-insert_pages.patch removed from -mm tree
Message-Id: <20261007005037.61BFD1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: simplify error handling in insert_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory-simplify-error-handling-in-insert_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Avi Weiss <thnkslprpt@gmail.com>
Subject: mm/memory: simplify error handling in insert_pages()
Date: Sat, 29 Aug 2026 20:11:12 +0300

Patch series "mm/memory: improve insert_pages() error handling", v3.

Improve insert_pages() error handling.

The first patch simplifies error handling by initializing the error status
to zero and assigning error codes at their respective failure sites.

The second patch returns -ENOMEM when walk_to_pmd() fails.  A NULL return
from walk_to_pmd() indicates failure to allocate an upper page-table
level, so -ENOMEM is more appropriate than -EFAULT and is consistent with
the subsequent pte_alloc() failure.


This patch (of 2):

Initialize error return status to zero and then set it as needed at each
point of failure.

Assign -ENOMEM explicitly when pte_alloc() fails as the pte_alloc() macro
returns a boolean.

Link: https://lore.kernel.org/cover.1788022178.git.thnkslprpt@gmail.com
Link: https://lore.kernel.org/dd3a672c858b38c7525541b19a919e120c4e5a0e.1788022178.git.thnkslprpt@gmail.com
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/memory.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-memory-simplify-error-handling-in-insert_pages
+++ a/mm/memory.c
@@ -2565,20 +2565,22 @@ static int insert_pages(struct vm_area_s
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
 	unsigned long pages_to_write_in_pmd;
-	int ret;
+	int err = 0;
 more:
-	ret = -EFAULT;
 	pmd = walk_to_pmd(mm, addr);
-	if (!pmd)
+	if (!pmd) {
+		err = -EFAULT;
 		goto out;
+	}
 
 	pages_to_write_in_pmd = min_t(unsigned long,
 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
 
 	/* Allocate the PTE if necessary; takes PMD lock once only. */
-	ret = -ENOMEM;
-	if (pte_alloc(mm, pmd))
+	if (pte_alloc(mm, pmd)) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	while (pages_to_write_in_pmd) {
 		int pte_idx = 0;
@@ -2586,15 +2588,14 @@ more:
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
 		if (!start_pte) {
-			ret = -EFAULT;
+			err = -EFAULT;
 			goto out;
 		}
 		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
-			int err = insert_page_in_batch_locked(vma, pte,
-				addr, pages[curr_page_idx], prot);
+			err = insert_page_in_batch_locked(vma, pte, addr,
+							  pages[curr_page_idx], prot);
 			if (unlikely(err)) {
 				pte_unmap_unlock(start_pte, pte_lock);
-				ret = err;
 				remaining_pages_total -= pte_idx;
 				goto out;
 			}
@@ -2607,10 +2608,9 @@ more:
 	}
 	if (remaining_pages_total)
 		goto more;
-	ret = 0;
 out:
 	*num = remaining_pages_total;
-	return ret;
+	return err;
 }
 
 /**
_

Patches currently in -mm which might be from thnkslprpt@gmail.com are


