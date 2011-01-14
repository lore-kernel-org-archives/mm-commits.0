From: akpm@linux-foundation.org
Subject: [merged] mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:37 -0800
Message-ID: <201101142247.p0EMlRuQ004994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     mm/page-writeback.c: fix __set_page_dirty_no_writeback() return value
has been removed from the -mm tree.  Its filename was
     mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page-writeback.c: fix __set_page_dirty_no_writeback() return value
From: Bob Liu <lliubbo@gmail.com>

__set_page_dirty_no_writeback() should return true if it actually
transitioned the page from a clean to dirty state although it seems nobody
uses its return value at present.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value
+++ a/mm/page-writeback.c
@@ -1103,7 +1103,7 @@ EXPORT_SYMBOL(write_one_page);
 int __set_page_dirty_no_writeback(struct page *page)
 {
 	if (!PageDirty(page))
-		SetPageDirty(page);
+		return !TestSetPageDirty(page);
 	return 0;
 }
 
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch

