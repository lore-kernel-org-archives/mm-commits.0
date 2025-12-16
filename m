Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5082DCA6B
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765853369; cv=none; b=LmzXYpJqoo/R2mShdghwQln8sLQ3OTxZLCGICbFbuVT3G9bZxufTRbQ+I8QZvPWNRWnN7JcGnMXHr6ouIxVunCvad9xFpQebTRtNUeUr4GF9uZ12LQhChlchnDpF1YedthWF8AebU6wskeppauLn0M56ml1hQsmGEMKhYGTWwew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765853369; c=relaxed/simple;
	bh=osK7u0Z6BmXoKLZAOGh2Z+ohPuZ9gW0+1UsYgCQruG8=;
	h=Date:To:From:Subject:Message-Id; b=CLgBNO5fBYoiyHPB4LEDUqZYUhYGiCX48wMfNv9EhO1fDvsX7o7o434yszFO76aM/lc2rNta9rSURYdcrxJk+T2Ed8RIwryu+Uu2MyTKYpWD5k42Aka+yBlNJRGZu/YPnLXsQ8lqeKb4MB0ERoneh6Wsa4SwvXNSzrt1kER51Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uHzyjZky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uHzyjZky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE15C4CEF5;
	Tue, 16 Dec 2025 02:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765853369;
	bh=osK7u0Z6BmXoKLZAOGh2Z+ohPuZ9gW0+1UsYgCQruG8=;
	h=Date:To:From:Subject:From;
	b=uHzyjZkyQ+FR5224unbtjxG8LZg8PJanSkVzDhCJ+c0PzFIh6FhEkYLJFPPluqIZ0
	 PtfjhJqZ2snYjQTG9ZujjN0WuM3s0csRXmavlbSOkEGZsOCyDfApcUkCmWwhS4Lx1L
	 pJf87Sd+G35qIS+S/r/0ZZQJZLwib2N9iBLIF1Co=
Date: Mon, 15 Dec 2025 18:49:28 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-clear_pages-and-clear_user_pages.patch added to mm-new branch
Message-Id: <20251216024928.DDE15C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce clear_pages() and clear_user_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-clear_pages-and-clear_user_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-clear_pages-and-clear_user_pages.patch

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
Subject: mm: introduce clear_pages() and clear_user_pages()
Date: Mon, 15 Dec 2025 12:49:17 -0800

Introduce clear_pages(), to be overridden by architectures that support
more efficient clearing of consecutive pages.

Also introduce clear_user_pages(), however, we will not expect this
function to be overridden anytime soon.

As we do for clear_user_page().  define clear_user_pages() only if the
architecture does not define clear_user_highpage().

That is because if the architecture does define clear_user_highpage(),
then it likely needs some flushing magic when clearing user pages or
highpages.  This means we can get away without defining
clear_user_pages(), since, much like its single page sibling, its only
potential user is the generic clear_user_highpages() which should instead
be using clear_user_highpage().

Link: https://lkml.kernel.org/r/20251215204922.475324-4-ankur.a.arora@oracle.com
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

 include/linux/highmem.h |   33 +++++++++++++++++++++++++++++++++
 include/linux/mm.h      |   20 ++++++++++++++++++++
 2 files changed, 53 insertions(+)

--- a/include/linux/highmem.h~mm-introduce-clear_pages-and-clear_user_pages
+++ a/include/linux/highmem.h
@@ -218,6 +218,39 @@ static inline void clear_user_page(void
 #endif
 
 /**
+ * clear_user_pages() - clear a page range to be mapped to user space
+ * @addr: start address
+ * @vaddr: start address of the user mapping
+ * @page: start page
+ * @npages: number of pages
+ *
+ * Assumes that the region (@addr, +@npages) has been validated
+ * already so this does no exception handling.
+ *
+ * If the architecture provides a clear_user_page(), use that;
+ * otherwise, we can safely use clear_pages().
+ */
+static inline void clear_user_pages(void *addr, unsigned long vaddr,
+		struct page *page, unsigned int npages)
+{
+
+#ifdef clear_user_page
+	do {
+		clear_user_page(addr, vaddr, page);
+		addr += PAGE_SIZE;
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+#else
+	/*
+	 * Prefer clear_pages() to allow for architectural optimizations
+	 * when operating on contiguous page ranges.
+	 */
+	clear_pages(addr, npages);
+#endif
+}
+
+/**
  * clear_user_highpage() - clear a page to be mapped to user space
  * @page: start page
  * @vaddr: start address of the user mapping
--- a/include/linux/mm.h~mm-introduce-clear_pages-and-clear_user_pages
+++ a/include/linux/mm.h
@@ -4236,6 +4236,26 @@ static inline void clear_page_guard(stru
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef clear_pages
+/**
+ * clear_pages() - clear a page range for kernel-internal use.
+ * @addr: start address
+ * @npages: number of pages
+ *
+ * Use clear_user_pages() instead when clearing a page range to be
+ * mapped to user space.
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_pages(void *addr, unsigned int npages)
+{
+	do {
+		clear_page(addr);
+		addr += PAGE_SIZE;
+	} while (--npages);
+}
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

highmem-introduce-clear_user_highpages.patch
mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-do-range-clearing-in-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-support-clearing-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch

