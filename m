From: akpm@linux-foundation.org
Subject: [merged]
 page_writeback-put-account_page_redirty-after-set_page_dirty.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:37:37 -0800
Message-ID: <54dd0101.ZYJ8QETxF5QeQ9Dh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbBLThi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: page_writeback: put account_page_redirty() after set_page_dirty()
has been removed from the -mm tree.  Its filename was
     page_writeback-put-account_page_redirty-after-set_page_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
Subject: page_writeback: put account_page_redirty() after set_page_dirty()

Helper account_page_redirty() fixes dirty pages counter for redirtied
pages.  This patch puts it after dirtying and prevents temporary
underflows of dirtied pages counters on zone/bdi and current->nr_dirtied.

Signed-off-by: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_io.c |    2 +-
 mm/page-writeback.c  |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/btrfs/extent_io.c~page_writeback-put-account_page_redirty-after-set_page_dirty fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~page_writeback-put-account_page_redirty-after-set_page_dirty
+++ a/fs/btrfs/extent_io.c
@@ -1407,8 +1407,8 @@ int extent_range_redirty_for_io(struct i
 	while (index <= end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		BUG_ON(!page); /* Pages should be in the extent_io_tree */
-		account_page_redirty(page);
 		__set_page_dirty_nobuffers(page);
+		account_page_redirty(page);
 		page_cache_release(page);
 		index++;
 	}
diff -puN mm/page-writeback.c~page_writeback-put-account_page_redirty-after-set_page_dirty mm/page-writeback.c
--- a/mm/page-writeback.c~page_writeback-put-account_page_redirty-after-set_page_dirty
+++ a/mm/page-writeback.c
@@ -2168,9 +2168,12 @@ EXPORT_SYMBOL(account_page_redirty);
  */
 int redirty_page_for_writepage(struct writeback_control *wbc, struct page *page)
 {
+	int ret;
+
 	wbc->pages_skipped++;
+	ret = __set_page_dirty_nobuffers(page);
 	account_page_redirty(page);
-	return __set_page_dirty_nobuffers(page);
+	return ret;
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

origin.patch
linux-next.patch

