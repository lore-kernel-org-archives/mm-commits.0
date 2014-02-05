From: akpm@linux-foundation.org
Subject: +
 mm-__set_page_dirty-uses-spin_lock_irqsave-instead-of-spin_lock_irq.patch
 added to -mm tree
Date: Wed, 05 Feb 2014 13:37:52 -0800
Message-ID: <52f2af30./IPP8H8hgNgBXmIN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaBEVhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 16:37:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com

Subject: + mm-__set_page_dirty-uses-spin_lock_irqsave-instead-of-spin_lock_irq.patch added to -mm tree
To: kosaki.motohiro@jp.fujitsu.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 13:37:52 -0800


The patch titled
     Subject: mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq
has been added to the -mm tree.  Its filename is
     mm-__set_page_dirty-uses-spin_lock_irqsave-instead-of-spin_lock_irq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-__set_page_dirty-uses-spin_lock_irqsave-instead-of-spin_lock_irq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-__set_page_dirty-uses-spin_lock_irqsave-instead-of-spin_lock_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

To use spin_{un}lock_irq is dangerous if caller disabled interrupt. 
During aio buffer migration, we have a possibility to see the following
call stack.

aio_migratepage  [disable interrupt]
  migrate_page_copy
    clear_page_dirty_for_io
      set_page_dirty
        __set_page_dirty_buffers
          __set_page_dirty
            spin_lock_irq

This mean, current aio migration is a deadlockable.  spin_lock_irqsave is
a safer alternative and we should use it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: David Rientjes rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/buffer.c~mm-__set_page_dirty-uses-spin_lock_irqsave-instead-of-spin_lock_irq fs/buffer.c
--- a/fs/buffer.c~mm-__set_page_dirty-uses-spin_lock_irqsave-instead-of-spin_lock_irq
+++ a/fs/buffer.c
@@ -654,14 +654,16 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
 static void __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
-	spin_lock_irq(&mapping->tree_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&mapping->tree_lock, flags);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
-	spin_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-__set_page_dirty_nobuffers-uses-spin_lock_irqseve-instead-of-spin_lock_irq.patch
mm-__set_page_dirty-uses-spin_lock_irqsave-instead-of-spin_lock_irq.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch

