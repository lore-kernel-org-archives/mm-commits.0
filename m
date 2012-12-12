From: akpm@linux-foundation.org
Subject: [merged] mm-add-comment-on-storage-key-dirty-bit-semantics.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:14 -0800
Message-ID: <20121212195814.B336082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:57526 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:15 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so117835ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hughd@google.com, mgorman@suse.de, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add comment on storage key dirty bit semantics
has been removed from the -mm tree.  Its filename was
     mm-add-comment-on-storage-key-dirty-bit-semantics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: add comment on storage key dirty bit semantics

Add comments that dirty bit in storage key gets set whenever page content
is changed.  Hopefully if someone will use this function, he'll have a
look at one of the two places where we comment on this.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/page.h |    3 +++
 mm/rmap.c                    |    8 +++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/s390/include/asm/page.h~mm-add-comment-on-storage-key-dirty-bit-semantics arch/s390/include/asm/page.h
--- a/arch/s390/include/asm/page.h~mm-add-comment-on-storage-key-dirty-bit-semantics
+++ a/arch/s390/include/asm/page.h
@@ -158,6 +158,9 @@ static inline int page_reset_referenced(
  * race against modification of the referenced bit. This function
  * should therefore only be called if it is not mapped in any
  * address space.
+ *
+ * Note that the bit gets set whenever page content is changed. That means
+ * also when the page is modified by DMA or from inside the kernel.
  */
 #define __HAVE_ARCH_PAGE_TEST_AND_CLEAR_DIRTY
 static inline int page_test_and_clear_dirty(unsigned long pfn, int mapped)
diff -puN mm/rmap.c~mm-add-comment-on-storage-key-dirty-bit-semantics mm/rmap.c
--- a/mm/rmap.c~mm-add-comment-on-storage-key-dirty-bit-semantics
+++ a/mm/rmap.c
@@ -1151,9 +1151,11 @@ void page_remove_rmap(struct page *page)
 	 * containing the swap entry, but page not yet written to swap.
 	 *
 	 * And we can skip it on file pages, so long as the filesystem
-	 * participates in dirty tracking; but need to catch shm and tmpfs
-	 * and ramfs pages which have been modified since creation by read
-	 * fault.
+	 * participates in dirty tracking (note that this is not only an
+	 * optimization but also solves problems caused by dirty flag in
+	 * storage key getting set by a write from inside kernel); but need to
+	 * catch shm and tmpfs and ramfs pages which have been modified since
+	 * creation by read fault.
 	 *
 	 * Note that mapping must be decided above, before decrementing
 	 * mapcount (which luckily provides a barrier): once page is unmapped,
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
maintainers-remove-include-linux-ext3.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
fat-provide-option-for-setting-timezone-offset.patch
fat-fix-mount-option-parsing.patch

