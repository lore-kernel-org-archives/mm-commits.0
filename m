From: akpm@linux-foundation.org
Subject: + mm-remove-unused-arg-of-set_page_dirty_balance.patch added to
 -mm tree
Date: Wed, 26 Mar 2014 14:45:21 -0700
Message-ID: <53334a71.tF5mmA24/kaOr+Yx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbaCZVpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 17:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mszeredi@suse.cz

Subject: + mm-remove-unused-arg-of-set_page_dirty_balance.patch added to -mm tree
To: mszeredi@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 14:45:21 -0700


The patch titled
     Subject: mm: remove unused arg of set_page_dirty_balance()
has been added to the -mm tree.  Its filename is
     mm-remove-unused-arg-of-set_page_dirty_balance.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unused-arg-of-set_page_dirty_balance.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unused-arg-of-set_page_dirty_balance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miklos Szeredi <mszeredi@suse.cz>
Subject: mm: remove unused arg of set_page_dirty_balance()

There's only one caller of set_page_dirty_balance() and that will call it
with page_mkwrite == 0.

The page_mkwrite argument was unused since commit b827e496c893 "mm: close
page_mkwrite races".

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 +-
 mm/memory.c               |    2 +-
 mm/page-writeback.c       |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/writeback.h~mm-remove-unused-arg-of-set_page_dirty_balance include/linux/writeback.h
--- a/include/linux/writeback.h~mm-remove-unused-arg-of-set_page_dirty_balance
+++ a/include/linux/writeback.h
@@ -178,7 +178,7 @@ int write_cache_pages(struct address_spa
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
-void set_page_dirty_balance(struct page *page, int page_mkwrite);
+void set_page_dirty_balance(struct page *page);
 void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
diff -puN mm/memory.c~mm-remove-unused-arg-of-set_page_dirty_balance mm/memory.c
--- a/mm/memory.c~mm-remove-unused-arg-of-set_page_dirty_balance
+++ a/mm/memory.c
@@ -2758,7 +2758,7 @@ reuse:
 		 */
 		if (!page_mkwrite) {
 			wait_on_page_locked(dirty_page);
-			set_page_dirty_balance(dirty_page, page_mkwrite);
+			set_page_dirty_balance(dirty_page);
 			/* file_update_time outside page_lock */
 			if (vma->vm_file)
 				file_update_time(vma->vm_file);
diff -puN mm/page-writeback.c~mm-remove-unused-arg-of-set_page_dirty_balance mm/page-writeback.c
--- a/mm/page-writeback.c~mm-remove-unused-arg-of-set_page_dirty_balance
+++ a/mm/page-writeback.c
@@ -1562,9 +1562,9 @@ pause:
 		bdi_start_background_writeback(bdi);
 }
 
-void set_page_dirty_balance(struct page *page, int page_mkwrite)
+void set_page_dirty_balance(struct page *page)
 {
-	if (set_page_dirty(page) || page_mkwrite) {
+	if (set_page_dirty(page)) {
 		struct address_space *mapping = page_mapping(page);
 
 		if (mapping)
_

Patches currently in -mm which might be from mszeredi@suse.cz are

mm-remove-unused-arg-of-set_page_dirty_balance.patch
linux-next.patch

