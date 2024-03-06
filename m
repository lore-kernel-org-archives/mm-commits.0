Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D45179B1
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759106; cv=none; b=HtDYOatsaykFTGRQyJisdM+Jfqu2wIwbVoaFf+nR2FrnJn/Lj9y6iCbBKgcoCgoyREHJR03p2QkbA9swP0zB7VQDWuILJQileI/EUugzUV1wDvHs/VmXgDD+S4SQjA86oG88UBde9JySzpqUcTk4zXsWXnXYderTFUg+zDweoN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759106; c=relaxed/simple;
	bh=E99ktMpSvcQnvSG5Rq4Jz6RDuFPZcR76fFbce+PcDFI=;
	h=Date:To:From:Subject:Message-Id; b=Q8uRqvfjkSPg2EWvuINo3L6cHSX4ZxMFkXimf2ZXpStM/OzKaZG+oBW/wZ7vVKbuUqQFf45w+hOR0V7A9Ue94RlpZVgn3WfcqdBT6miYPezm1nXU3h+IrnMLzOlmp+6Y+hz+PnTrq1VeLToEEDOIPiuAE7NIbgp/01rcLr1JHvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OeSdCzNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OeSdCzNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004EEC433C7;
	Wed,  6 Mar 2024 21:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759106;
	bh=E99ktMpSvcQnvSG5Rq4Jz6RDuFPZcR76fFbce+PcDFI=;
	h=Date:To:From:Subject:From;
	b=OeSdCzNICuKakPvRuo1yRxnxDgZG6cr8NX3F26+A5b3juLcT/kEOCYN1jd1vfRS8s
	 KOG8hbSZDPIxTq2EMn8OI2H51N48QI7khBvXA0mZfc6rfCXqVtKMDsYDrn7Gq8iKOH
	 csRgBebW9efqhzYNYoTKgzcJYr+RryJCaL3lOSXE=
Date: Wed, 06 Mar 2024 13:05:05 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-dump_page-take-a-const-argument.patch removed from -mm tree
Message-Id: <20240306210506.004EEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make dump_page() take a const argument
has been removed from the -mm tree.  Its filename was
     mm-make-dump_page-take-a-const-argument.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make dump_page() take a const argument
Date: Tue, 27 Feb 2024 19:23:32 +0000

Now that __dump_page() takes a const argument, we can make dump_page()
take a const struct page too.

Link: https://lkml.kernel.org/r/20240227192337.757313-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    2 +-
 mm/debug.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmdebug.h~mm-make-dump_page-take-a-const-argument
+++ a/include/linux/mmdebug.h
@@ -10,7 +10,7 @@ struct vm_area_struct;
 struct mm_struct;
 struct vma_iterator;
 
-void dump_page(struct page *page, const char *reason);
+void dump_page(const struct page *page, const char *reason);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
 void vma_iter_dump_tree(const struct vma_iterator *vmi);
--- a/mm/debug.c~mm-make-dump_page-take-a-const-argument
+++ a/mm/debug.c
@@ -149,7 +149,7 @@ dump:
 	__dump_folio(foliop, &precise, pfn, idx);
 }
 
-void dump_page(struct page *page, const char *reason)
+void dump_page(const struct page *page, const char *reason)
 {
 	if (PagePoisoned(page))
 		pr_warn("page:%p is uninitialized and poisoned", page);
_

Patches currently in -mm which might be from willy@infradead.org are


