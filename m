From: akpm@linux-foundation.org
Subject: +
 page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch added to -mm tree
Date: Tue, 25 Jun 2013 16:54:28 -0700
Message-ID: <51ca2db4.dkj2h3dJAJvN8zT7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3FYXy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 19:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com

Subject: + page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch added to -mm tree
To: tangchen@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 16:54:28 -0700


The patch titled
     Subject: page migration: fix wrong comment in address_space_operations.migratepage()
has been added to the -mm tree.  Its filename is
     page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: page migration: fix wrong comment in address_space_operations.migratepage()

There is no parameter "sync" in address_space_operations->migratepage(). 
It should be mograte_mode.  And the comment is for MIGRATE_ASYNC.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/fs.h~page-migration-fix-wrong-comment-in-address_space_operationsmigratepage include/linux/fs.h
--- a/include/linux/fs.h~page-migration-fix-wrong-comment-in-address_space_operationsmigratepage
+++ a/include/linux/fs.h
@@ -374,8 +374,8 @@ struct address_space_operations {
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/*
-	 * migrate the contents of a page to the specified target. If sync
-	 * is false, it must not block.
+	 * migrate the contents of a page to the specified target. If
+	 * migrate_mode is MIGRATE_ASYNC, it must not block.
 	 */
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

linux-next.patch
mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
mm-arm64-kill-poison_init_mem.patch
mm-x86-use-free_reserved_area-to-simplify-code.patch
mm-tile-use-common-help-functions-to-free-reserved-pages.patch
mm-fix-some-trivial-typos-in-comments.patch
mm-use-managed_pages-to-calculate-default-zonelist-order.patch
mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
mm-correctly-update-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch
mm-report-available-pages-as-memtotal-for-each-numa-node.patch
mm-hotplug-prepare-for-removing-num_physpages.patch
mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ia64-prepare-for-killing-free_all_bootmem_node.patch
mm-sh-prepare-for-killing-free_all_bootmem_node.patch
page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch
mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch
aio-fix-wrong-comment-in-aio_complete.patch
mm-memory_hotplugc-fix-a-comment-typo-in-register_page_bootmem_info_node.patch

