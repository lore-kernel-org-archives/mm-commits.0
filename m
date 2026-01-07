Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464842A1BB
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809439; cv=none; b=cWWQuDhTHa7Wej7kBqtBx1xDf1fJWJN9lyff5VtbZFyQZC3zR9slPuwK0yYtyCm+ka3SNr6+WauHK9bVuo8Wj1l/I/FCzyIS2N/j7ZdtXBWghf5Ye6LNl0EDYmJNSQPqYqxXXkySVsa5H3kmKeCXGgwhuR3xSNGTKK/I4xoutRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809439; c=relaxed/simple;
	bh=0w1ViFBDHPVYOfX9zT+QwUYrbvUYOGAdozPJMtyAPJ4=;
	h=Date:To:From:Subject:Message-Id; b=FYHU7SrCqrR8azQcyCJRK9jjudz9LWbGcv+lrBldpmu0AH+1KxereHiY6WfkMvI4eb/GzC4peIEb8uTEspGLIIgiAnfLOnJKvalJLcELc+3B/aa0MS6fVPMwKzndqTBg/3o9QtfmM4CsOLA5lzQAPI30PAee8UeQz7a6+EYpp0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KcI5FN4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KcI5FN4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D49C4CEF1;
	Wed,  7 Jan 2026 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809439;
	bh=0w1ViFBDHPVYOfX9zT+QwUYrbvUYOGAdozPJMtyAPJ4=;
	h=Date:To:From:Subject:From;
	b=KcI5FN4YbqIFrv+kxD5UBAQ/yE7Ccp0YGfKIB/2ZDus95S8/xqJjc+v1J4B3OvyoP
	 8iLw7KHC7JwB3br9e/QFLuTmTL9VfpgbQczslpTU7M0MWFpc4yEEW0eEsgvtSTpqfn
	 nov7abrmv0VwLOEjictceIh+cIJXplwFwefRtJLI=
Date: Wed, 07 Jan 2026 10:10:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-introduce-clear_user_highpages.patch added to mm-unstable branch
Message-Id: <20260107181039.07D49C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: highmem: introduce clear_user_highpages()
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-introduce-clear_user_highpages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-introduce-clear_user_highpages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: highmem: introduce clear_user_highpages()
Date: Tue, 6 Jan 2026 23:20:04 -0800

Define clear_user_highpages() which uses the range clearing primitive,
clear_user_pages().  We can safely use this when CONFIG_HIGHMEM is
disabled and if the architecture does not have clear_user_highpage.

The first is needed to ensure that contiguous page ranges stay contiguous
which precludes intermediate maps via HIGMEM.  The second, because if the
architecture has clear_user_highpage(), it likely needs flushing magic
when clearing the page, magic that we aren't privy to.

For both of those cases, just fallback to a loop around
clear_user_highpage().

Link: https://lkml.kernel.org/r/20260107072009.1615991-4-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   45 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

--- a/include/linux/highmem.h~highmem-introduce-clear_user_highpages
+++ a/include/linux/highmem.h
@@ -251,7 +251,14 @@ static inline void clear_user_pages(void
 #endif
 }
 
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
@@ -260,6 +267,42 @@ static inline void clear_user_highpage(s
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
+
+#if defined(clear_user_highpage) || defined(CONFIG_HIGHMEM)
+	/*
+	 * An architecture defined clear_user_highpage() implies special
+	 * handling is needed.
+	 *
+	 * So we use that or, the generic variant if CONFIG_HIGHMEM is
+	 * enabled.
+	 */
+	do {
+		clear_user_highpage(page, vaddr);
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+#else
+
+	/*
+	 * Prefer clear_user_pages() to allow for architectural optimizations
+	 * when operating on contiguous page ranges.
+	 */
+	clear_user_pages(page_address(page), vaddr, page, npages);
+#endif
+}
+
 #ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-introduce-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-clear-pages-sequentially.patch
mm-folio_zero_user-clear-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch

