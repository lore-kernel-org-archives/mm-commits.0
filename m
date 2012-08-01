From: akpm@linux-foundation.org
Subject: [merged] mm-add-support-for-direct_io-to-highmem-pages.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:15 -0700
Message-ID: <20120801201716.0ECFE1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2HAURR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:17 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add support for direct_IO to highmem pages
has been removed from the -mm tree.  Its filename was
     mm-add-support-for-direct_io-to-highmem-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: add support for direct_IO to highmem pages

The patch "mm: add support for a filesystem to activate swap files and use
direct_IO for writing swap pages" added support for using direct_IO to
write swap pages but it is insufficient for highmem pages.

To support highmem pages, this patch kmaps() the page before calling the
direct_IO() handler.  As direct_IO deals with virtual addresses an
additional helper is necessary for get_kernel_pages() to lookup the struct
page for a kmap virtual address.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    7 +++++++
 mm/highmem.c            |   12 ++++++++++++
 mm/page_io.c            |    3 ++-
 mm/swap.c               |    3 +--
 4 files changed, 22 insertions(+), 3 deletions(-)

diff -puN include/linux/highmem.h~mm-add-support-for-direct_io-to-highmem-pages include/linux/highmem.h
--- a/include/linux/highmem.h~mm-add-support-for-direct_io-to-highmem-pages
+++ a/include/linux/highmem.h
@@ -39,10 +39,17 @@ extern unsigned long totalhigh_pages;
 
 void kmap_flush_unused(void);
 
+struct page *kmap_to_page(void *addr);
+
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
 
+static inline struct page *kmap_to_page(void *addr)
+{
+	return virt_to_page(addr);
+}
+
 #define totalhigh_pages 0UL
 
 #ifndef ARCH_HAS_KMAP
diff -puN mm/highmem.c~mm-add-support-for-direct_io-to-highmem-pages mm/highmem.c
--- a/mm/highmem.c~mm-add-support-for-direct_io-to-highmem-pages
+++ a/mm/highmem.c
@@ -94,6 +94,18 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map
 		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
 #endif
 
+struct page *kmap_to_page(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+		return pte_page(pkmap_page_table[i]);
+	}
+
+	return virt_to_page(addr);
+}
+
 static void flush_all_zero_pkmaps(void)
 {
 	int i;
diff -puN mm/page_io.c~mm-add-support-for-direct_io-to-highmem-pages mm/page_io.c
--- a/mm/page_io.c~mm-add-support-for-direct_io-to-highmem-pages
+++ a/mm/page_io.c
@@ -205,7 +205,7 @@ int swap_writepage(struct page *page, st
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 		struct iovec iov = {
-			.iov_base = page_address(page),
+			.iov_base = kmap(page),
 			.iov_len  = PAGE_SIZE,
 		};
 
@@ -218,6 +218,7 @@ int swap_writepage(struct page *page, st
 		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
 						&kiocb, &iov,
 						kiocb.ki_pos, 1);
+		kunmap(page);
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
diff -puN mm/swap.c~mm-add-support-for-direct_io-to-highmem-pages mm/swap.c
--- a/mm/swap.c~mm-add-support-for-direct_io-to-highmem-pages
+++ a/mm/swap.c
@@ -258,8 +258,7 @@ int get_kernel_pages(const struct kvec *
 		if (WARN_ON(kiov[seg].iov_len != PAGE_SIZE))
 			return seg;
 
-		/* virt_to_page sanity checks the PFN */
-		pages[seg] = virt_to_page(kiov[seg].iov_base);
+		pages[seg] = kmap_to_page(kiov[seg].iov_base);
 		page_cache_get(pages[seg]);
 	}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

