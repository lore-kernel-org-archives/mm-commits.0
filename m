Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A0288535
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966043; cv=none; b=Ap6EW7DChw+VFwSLvhihgy7O+CK0lK7Ow+b1sB58VzfosX/95pV3nAqdLALlKsufbKXuFK01veqgZJGcZDcVA748G1/c2Z8FOXLPOD+wNhQNbercWhFkvpb+bY0dQMpPXd1KrLJtx52TRRFFC7z8JABDq5ewDzsc7CvJV+Xu2ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966043; c=relaxed/simple;
	bh=/eoHKTR9vbBI06Z8gN+hNbDqXa1j+zK7CNhsVG8RRg8=;
	h=Date:To:From:Subject:Message-Id; b=Iea1URH0zmh0ytLGG2S+IQ7xFtKZtOAKud2EtOfkoVjrL5SW8gsUgCWKtZgI0+BwWB+9xxhHZLfxD0X2nbyLb8fxKS2DbQugit4NGiTvP9ktFKg5rZ3qme76ckLpR4posW221f8vhl7me4XKmqpg+G3My8Qhz17iiLBuhIHGQNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4N3/epL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4N3/epL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7324CC16AAE;
	Wed, 21 Jan 2026 03:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966043;
	bh=/eoHKTR9vbBI06Z8gN+hNbDqXa1j+zK7CNhsVG8RRg8=;
	h=Date:To:From:Subject:From;
	b=V4N3/epLrskQ4HJDItPMJkZkgedkFD2rnR4AgWtBNSwKTVl0axIgb/q4zJDDRMlGC
	 IjA0TL0LtVquGnVcAeSGXA3SWWFnydqW0aZ2Ole09rgqE/WKBgkF/4mtRbWnqfMY7O
	 2qwhn0G/ZEoSEobaO6Xw4dhJ4G8ikRQ4RGnBeIUo=
Date: Tue, 20 Jan 2026 19:27:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] highmem-introduce-clear_user_highpages.patch removed from -mm tree
Message-Id: <20260121032723.7324CC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: highmem: introduce clear_user_highpages()
has been removed from the -mm tree.  Its filename was
     highmem-introduce-clear_user_highpages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


