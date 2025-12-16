Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E7BCA6B
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765853367; cv=none; b=XTtBzScvoIOkYczw7cC/cfJZJGzxOM5m2ZEjM63wGL3KWWBLBKyjT7ZTra/IbgmYmt/yjpZDfI/MrjNnWO9QPT1Xm0LNVLj1TrZoEko3kZSn5JWfoT5Mh9FJEGyx9a4GRTnJ9a4ovEIBqy0a0m4BepYEI9bw77AClg11Ios6dNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765853367; c=relaxed/simple;
	bh=biK5zSH+SvI4KvFPCVUpU8t5tnk+w+YE5+aEsqZDq4I=;
	h=Date:To:From:Subject:Message-Id; b=mOWCmKdy4Fdz2OcSy1e97thafoYYJD80eyElTnq8CyOeaoS9ARMulrtZMDDF2rPScIHMHHrirUrEXYJVpc96OtfWFofEpZPPUxI9uMNyM+4drSSbkr8KfSbaqTpWCqAJs4gOzpwuqTAUgghWjbwJC05txAlkZaqidShoT7glPoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9/xc7wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9/xc7wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81C0C4CEF5;
	Tue, 16 Dec 2025 02:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765853366;
	bh=biK5zSH+SvI4KvFPCVUpU8t5tnk+w+YE5+aEsqZDq4I=;
	h=Date:To:From:Subject:From;
	b=Z9/xc7wj3vHe2JB6/8w5x1kYXFqz6ASfEfTOGmyLePYJOkDBx83wHOdlCuSJup1is
	 +se1HGZZ2g6F6s8JuxWcMHj8IaGpPgfJPu1wAnbiiZxUn0Q58uBkhov1MLvLuU08xU
	 0GuMl3nPNdLf6KVDOVPH/6nJTYyag2wzfRfb4wDk=
Date: Mon, 15 Dec 2025 18:49:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-introduce-clear_user_highpages.patch added to mm-new branch
Message-Id: <20251216024926.B81C0C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: highmem: introduce clear_user_highpages()
has been added to the -mm mm-new branch.  Its filename is
     highmem-introduce-clear_user_highpages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-introduce-clear_user_highpages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: highmem: introduce clear_user_highpages()
Date: Mon, 15 Dec 2025 12:49:16 -0800

Define clear_user_highpages() which clears pages sequentially using
clear_user_highpage().

Also add a comment describing clear_user_highpage().

Link: https://lkml.kernel.org/r/20251215204922.475324-3-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/include/linux/highmem.h~highmem-introduce-clear_user_highpages
+++ a/include/linux/highmem.h
@@ -217,7 +217,14 @@ static inline void clear_user_page(void
 }
 #endif
 
-/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
+/**
+ * clear_user_highpage() - clear a page to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ *
+ * With !CONFIG_HIGHMEM this (and the copy_user_highpage() below) will
+ * be plain clear_user_page() (and copy_user_page()).
+ */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
 	void *addr = kmap_local_page(page);
@@ -226,6 +233,25 @@ static inline void clear_user_highpage(s
 }
 #endif /* clear_user_highpage */
 
+/**
+ * clear_user_highpages() - clear a page range to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ * @npages: number of pages
+ *
+ * Assumes that all the pages in the region (@page, +@npages) are valid
+ * so this does no exception handling.
+ */
+static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
+					unsigned int npages)
+{
+	do {
+		clear_user_highpage(page, vaddr);
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+}
+
 #ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

highmem-introduce-clear_user_highpages.patch
mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-do-range-clearing-in-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-support-clearing-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch

