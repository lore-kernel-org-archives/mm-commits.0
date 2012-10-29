From: akpm@linux-foundation.org
Subject: + mm-add-comment-on-storage-key-dirty-bit-semantics.patch added to -mm tree
Date: Mon, 29 Oct 2012 14:13:07 -0700
Message-ID: <20121029211308.1966D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:59990 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133Ab2J2VNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 17:13:11 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so345838eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 14:13:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hughd@google.com, mgorman@suse.de, schwidefsky@de.ibm.com


The patch titled
     Subject: mm: add comment on storage key dirty bit semantics
has been added to the -mm tree.  Its filename is
     mm-add-comment-on-storage-key-dirty-bit-semantics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

