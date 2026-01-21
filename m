Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45693357716
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966042; cv=none; b=a4Q1LalG3OuYGFXk1zVIAl7Rb21KlO3TOJNJmhMrQ351xQyqEVoBE6yQmWxVD7qAfgjrLzequuKE497wArP5nER8s1s1tG9N+KEhq1sp5sCpNoZX4PTSvRKl5gxKtIAXVHV0AuKiEHR03K/N4f8Wackq/UzPAEC76yM9wtrUvmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966042; c=relaxed/simple;
	bh=ufrqgIS/iBUWu14agkht0jJuEbRTKI1T5yI9sMN8oR4=;
	h=Date:To:From:Subject:Message-Id; b=TDhksP4ImsDaP9Bq+JflJ7rPBeObAMsfTBNsTN+2+D+ChxAIemBFoWtmups8XOj43Wpu4I0Jv25j69Bt4YgyNc9sdXf4SG91uwBuBWVVjIu3xFJytTGHwuY0/HyHbik7vT8ZjoI/N8PYyIDQFppk+6mBq3qxHkBXpbPKN7YwqGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QiZzCkOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QiZzCkOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CE5C16AAE;
	Wed, 21 Jan 2026 03:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966041;
	bh=ufrqgIS/iBUWu14agkht0jJuEbRTKI1T5yI9sMN8oR4=;
	h=Date:To:From:Subject:From;
	b=QiZzCkOgfiOSeZlHpRE/3usSZ6JzgTHhF0eGrAmE2qA30/GRbq/W8IwzetO/MrYNR
	 WWWyW/o/T6QTRTQu2J5g7EipxlCyrZsKGXxtie8i8kjk3otg8xRlL+yE5r/Koa6z2h
	 pOZJxvtOy8NNuUmy77YNEMC3M+rZ43nkV7ePxUJY=
Date: Tue, 20 Jan 2026 19:27:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-clear_pages-and-clear_user_pages.patch removed from -mm tree
Message-Id: <20260121032721.B8CE5C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce clear_pages() and clear_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-introduce-clear_pages-and-clear_user_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
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
@@ -4198,6 +4198,26 @@ static inline void clear_page_guard(stru
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


