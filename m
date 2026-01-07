Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71BD2A1BB
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 18:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809436; cv=none; b=uHH69Re0gW5g8vkRKrUE7jDWLapXBZGoQerPmGF8WQNW8r/HKCslcbgQDb5o7s5cumsgOAJ1gMHdATPbo/GKv3GJX0hXA7dvOZQ3Q7N9fsbRfQLgX8upCM2uGt/qJ8fnMyYxFp9be3J3wkk3mEV4nS4Cvf1mO4F1TEQVViZLYQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809436; c=relaxed/simple;
	bh=H1visipVRR+y2+aV/29TOinP0Px0DAeNQ6y/+S++2IA=;
	h=Date:To:From:Subject:Message-Id; b=EW+y4I5mI1SmxjlUAB0l0QspWJKt5duQruBOJeoz7x0QsCB4o1Jxca+Mn4VRyxy84rXIB5Gha6BZ0O/2b9Jv9IeRaPg+JtTrxzrqy56ucmMpGIQeVLX/E93i0ZYpX2BSuvKPoxG9rdKejTDM6npwaOy8Hv8vsFow7GZzILYqGCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xM0usuk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xM0usuk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3956AC4CEF1;
	Wed,  7 Jan 2026 18:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809436;
	bh=H1visipVRR+y2+aV/29TOinP0Px0DAeNQ6y/+S++2IA=;
	h=Date:To:From:Subject:From;
	b=xM0usuk9iGakFzcr+biVMSzz3QS6tRjc3gcAv+NMUCX0lhZ7SLa5I5fE5aiW8cWXF
	 /cePtoKecJEnS+7Dg/L7qmx/2oCmtNShWxZ9SrG7KXty/fsGVIDjNu8CWNKql17pTq
	 ogjWnnEEI0i7PEoRSkBpk0eW/FeZEUCq/K69oIng=
Date: Wed, 07 Jan 2026 10:10:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-clear_pages-and-clear_user_pages.patch added to mm-unstable branch
Message-Id: <20260107181036.3956AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce clear_pages() and clear_user_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-clear_pages-and-clear_user_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-clear_pages-and-clear_user_pages.patch

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
Subject: mm: introduce clear_pages() and clear_user_pages()
Date: Tue, 6 Jan 2026 23:20:03 -0800

Introduce clear_pages(), to be overridden by architectures that support
more efficient clearing of consecutive pages.

Also introduce clear_user_pages(), however, we will not expect this
function to be overridden anytime soon.

As we do for clear_user_page(), define clear_user_pages() only if the
architecture does not define clear_user_highpage().

That is because if the architecture does define clear_user_highpage(),
then it likely needs some flushing magic when clearing user pages or
highpages.  This means we can get away without defining
clear_user_pages(), since, much like its single page sibling, its only
potential user is the generic clear_user_highpages() which should instead
be using clear_user_highpage().

Link: https://lkml.kernel.org/r/20260107072009.1615991-3-ankur.a.arora@oracle.com
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

 include/linux/highmem.h |   33 +++++++++++++++++++++++++++++++++
 include/linux/mm.h      |   20 ++++++++++++++++++++
 2 files changed, 53 insertions(+)

--- a/include/linux/highmem.h~mm-introduce-clear_pages-and-clear_user_pages
+++ a/include/linux/highmem.h
@@ -218,6 +218,39 @@ static inline void clear_user_page(void
 }
 #endif
 
+/**
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
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
--- a/include/linux/mm.h~mm-introduce-clear_pages-and-clear_user_pages
+++ a/include/linux/mm.h
@@ -4194,6 +4194,26 @@ static inline void clear_page_guard(stru
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

mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-introduce-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-clear-pages-sequentially.patch
mm-folio_zero_user-clear-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch

