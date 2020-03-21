From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-make-page_evictable-inline-fix.patch added to
 -mm tree
Date: Fri, 20 Mar 2020 19:13:36 -0700
Message-ID: <20200321021336.UTUBgbrUw%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgCUCNi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 22:13:38 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org, shakeelb@google.com, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-swap-make-page_evictable-inline-fix
has been added to the -mm tree.  Its filename is
     mm-swap-make-page_evictable-inline-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-make-page_evictable-inline-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-make-page_evictable-inline-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-make-page_evictable-inline-fix

move page_evictable() to internal.h

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   23 -----------------------
 mm/internal.h           |   23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

--- a/include/linux/pagemap.h~mm-swap-make-page_evictable-inline-fix
+++ a/include/linux/pagemap.h
@@ -116,29 +116,6 @@ static inline void mapping_set_gfp_mask(
 	m->gfp_mask = mask;
 }
 
-/**
- * page_evictable - test whether a page is evictable
- * @page: the page to test
- *
- * Test whether page is evictable--i.e., should be placed on active/inactive
- * lists vs unevictable list.
- *
- * Reasons page might not be evictable:
- * (1) page's mapping marked unevictable
- * (2) page is part of an mlocked VMA
- *
- */
-static inline bool page_evictable(struct page *page)
-{
-	bool ret;
-
-	/* Prevent address_space of inode and swap cache from being freed */
-	rcu_read_lock();
-	ret = !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
-	rcu_read_unlock();
-	return ret;
-}
-
 void release_pages(struct page **pages, int nr);
 
 /*
--- a/mm/internal.h~mm-swap-make-page_evictable-inline-fix
+++ a/mm/internal.h
@@ -63,6 +63,29 @@ static inline unsigned long ra_submit(st
 					ra->start, ra->size, ra->async_size);
 }
 
+/**
+ * page_evictable - test whether a page is evictable
+ * @page: the page to test
+ *
+ * Test whether page is evictable--i.e., should be placed on active/inactive
+ * lists vs unevictable list.
+ *
+ * Reasons page might not be evictable:
+ * (1) page's mapping marked unevictable
+ * (2) page is part of an mlocked VMA
+ *
+ */
+static inline bool page_evictable(struct page *page)
+{
+	bool ret;
+
+	/* Prevent address_space of inode and swap cache from being freed */
+	rcu_read_lock();
+	ret = !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
+	rcu_read_unlock();
+	return ret;
+}
+
 /*
  * Turn a non-refcounted page (->_refcount == 0) into refcounted with
  * a count of one.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_event-fix.patch
mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
