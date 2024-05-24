Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534E3381C6
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 19:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716577489; cv=none; b=FoBJR00sYJmdC/sVaOLy5JwmRLYrJ3ZyegwA8kd+lhnhMugO0xYz3dFL4rB6wJ2oFurdysEtc9ZfVMCLRVrl42OmumULf7W7KLHpuuoc8yBTzqdNePjDidaK5rCsbmEZWpLo0zTRCb6YWIITIiBOvjyZY5Ky2/uwVzPE4lZh1zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716577489; c=relaxed/simple;
	bh=IXje7JLxEza1J4kMxJmpt+P3BiepPpBW2/zVAZZrhsc=;
	h=Date:To:From:Subject:Message-Id; b=dwHjJbWjEQ11up6aJnesdH4kPEpliOYUqPYRv/Mm1YXF5jcuyGL+BabEySEGXjPEmVHA24j82Oc9xanmdk6JrKnJP2F716D8d5nkYsr39Qo7DYqTwxLT6xotBS2CQ3z3Rro5jbCDyOa8yQIcr6/4SRjLgrxvDYYWYLEHuR0LIxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rekksu6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rekksu6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C229FC2BBFC;
	Fri, 24 May 2024 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716577488;
	bh=IXje7JLxEza1J4kMxJmpt+P3BiepPpBW2/zVAZZrhsc=;
	h=Date:To:From:Subject:From;
	b=Rekksu6GyUgw9YfBa1mlgdhtcqN6Jlh8VnJbNa+oLv91TOTK1Sz+DCxueKwqgrC/W
	 LDb9u/cx6ExuDYzfvXkhd3tD627yP27Q0XHuwA0gCxG9DhukWLrpAvnxrScy2N7Ckw
	 rGPLeNrXgfJGMwO0xrPWgvwkmKeXdrTSd/24HI4Y=
Date: Fri, 24 May 2024 12:04:48 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,ebiggers@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_mapping.patch added to mm-unstable branch
Message-Id: <20240524190448.C229FC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_mapping.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_mapping()
Date: Fri, 24 May 2024 19:18:10 +0100

All callers are now converted, delete this compatibility wrapper.  Also
fix up some comments which referred to page_mapping.

Link: https://lkml.kernel.org/r/20240423225552.4113447-7-willy@infradead.org
Link: https://lkml.kernel.org/r/20240524181813.698813-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h   |    2 +-
 arch/arm64/include/asm/cacheflush.h |    2 +-
 arch/mips/mm/cache.c                |    2 +-
 arch/sparc/mm/init_64.c             |    2 +-
 include/linux/buffer_head.h         |    2 +-
 include/linux/page-flags.h          |   23 ++++++++++++-----------
 include/linux/pagemap.h             |    1 -
 mm/folio-compat.c                   |    6 ------
 8 files changed, 17 insertions(+), 23 deletions(-)

--- a/arch/arm64/include/asm/cacheflush.h~mm-remove-page_mapping
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -117,7 +117,7 @@ extern void copy_to_user_page(struct vm_
  * flush_dcache_folio is used when the kernel has written to the page
  * cache page at virtual address page->virtual.
  *
- * If this page isn't mapped (ie, page_mapping == NULL), or it might
+ * If this page isn't mapped (ie, folio_mapping == NULL), or it might
  * have userspace mappings, then we _must_ always clean + invalidate
  * the dcache entries associated with the kernel mapping.
  *
--- a/arch/arm/include/asm/cacheflush.h~mm-remove-page_mapping
+++ a/arch/arm/include/asm/cacheflush.h
@@ -283,7 +283,7 @@ void flush_cache_pages(struct vm_area_st
  * flush_dcache_page is used when the kernel has written to the page
  * cache page at virtual address page->virtual.
  *
- * If this page isn't mapped (ie, page_mapping == NULL), or it might
+ * If this page isn't mapped (ie, folio_mapping == NULL), or it might
  * have userspace mappings, then we _must_ always clean + invalidate
  * the dcache entries associated with the kernel mapping.
  *
--- a/arch/mips/mm/cache.c~mm-remove-page_mapping
+++ a/arch/mips/mm/cache.c
@@ -112,7 +112,7 @@ void __flush_dcache_pages(struct page *p
 	}
 
 	/*
-	 * We could delay the flush for the !page_mapping case too.  But that
+	 * We could delay the flush for the !folio_mapping case too.  But that
 	 * case is for exec env/arg pages and those are %99 certainly going to
 	 * get faulted into the tlb (and thus flushed) anyways.
 	 */
--- a/arch/sparc/mm/init_64.c~mm-remove-page_mapping
+++ a/arch/sparc/mm/init_64.c
@@ -490,7 +490,7 @@ void flush_dcache_folio(struct folio *fo
 		}
 		set_dcache_dirty(folio, this_cpu);
 	} else {
-		/* We could delay the flush for the !page_mapping
+		/* We could delay the flush for the !folio_mapping
 		 * case too.  But that case is for exec env/arg
 		 * pages and those are %99 certainly going to get
 		 * faulted into the tlb (and thus flushed) anyways.
--- a/include/linux/buffer_head.h~mm-remove-page_mapping
+++ a/include/linux/buffer_head.h
@@ -53,7 +53,7 @@ typedef void (bh_end_io_t)(struct buffer
  * filesystem and block layers.  Nowadays the basic I/O unit
  * is the bio, and buffer_heads are used for extracting block
  * mappings (via a get_block_t call), for tracking state within
- * a page (via a page_mapping) and for wrapping bio submission
+ * a folio (via a folio_mapping) and for wrapping bio submission
  * for backward compatibility reasons (e.g. submit_bh).
  */
 struct buffer_head {
--- a/include/linux/page-flags.h~mm-remove-page_mapping
+++ a/include/linux/page-flags.h
@@ -655,27 +655,28 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemma
 #endif
 
 /*
- * On an anonymous page mapped into a user virtual memory area,
- * page->mapping points to its anon_vma, not to a struct address_space;
+ * On an anonymous folio mapped into a user virtual memory area,
+ * folio->mapping points to its anon_vma, not to a struct address_space;
  * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
  *
  * On an anonymous page in a VM_MERGEABLE area, if CONFIG_KSM is enabled,
  * the PAGE_MAPPING_MOVABLE bit may be set along with the PAGE_MAPPING_ANON
- * bit; and then page->mapping points, not to an anon_vma, but to a private
+ * bit; and then folio->mapping points, not to an anon_vma, but to a private
  * structure which KSM associates with that merged page.  See ksm.h.
  *
  * PAGE_MAPPING_KSM without PAGE_MAPPING_ANON is used for non-lru movable
- * page and then page->mapping points to a struct movable_operations.
+ * page and then folio->mapping points to a struct movable_operations.
  *
- * Please note that, confusingly, "page_mapping" refers to the inode
- * address_space which maps the page from disk; whereas "page_mapped"
- * refers to user virtual address space into which the page is mapped.
+ * Please note that, confusingly, "folio_mapping" refers to the inode
+ * address_space which maps the folio from disk; whereas "folio_mapped"
+ * refers to user virtual address space into which the folio is mapped.
  *
  * For slab pages, since slab reuses the bits in struct page to store its
- * internal states, the page->mapping does not exist as such, nor do these
- * flags below.  So in order to avoid testing non-existent bits, please
- * make sure that PageSlab(page) actually evaluates to false before calling
- * the following functions (e.g., PageAnon).  See mm/slab.h.
+ * internal states, the folio->mapping does not exist as such, nor do
+ * these flags below.  So in order to avoid testing non-existent bits,
+ * please make sure that folio_test_slab(folio) actually evaluates to
+ * false before calling the following functions (e.g., folio_test_anon).
+ * See mm/slab.h.
  */
 #define PAGE_MAPPING_ANON	0x1
 #define PAGE_MAPPING_MOVABLE	0x2
--- a/include/linux/pagemap.h~mm-remove-page_mapping
+++ a/include/linux/pagemap.h
@@ -401,7 +401,6 @@ static inline void filemap_nr_thps_dec(s
 #endif
 }
 
-struct address_space *page_mapping(struct page *);
 struct address_space *folio_mapping(struct folio *);
 struct address_space *swapcache_mapping(struct folio *);
 
--- a/mm/folio-compat.c~mm-remove-page_mapping
+++ a/mm/folio-compat.c
@@ -10,12 +10,6 @@
 #include <linux/swap.h>
 #include "internal.h"
 
-struct address_space *page_mapping(struct page *page)
-{
-	return folio_mapping(page_folio(page));
-}
-EXPORT_SYMBOL(page_mapping);
-
 void unlock_page(struct page *page)
 {
 	return folio_unlock(page_folio(page));
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-page_mapping.patch

