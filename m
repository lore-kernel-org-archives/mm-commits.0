From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch added to -mm tree
Date: Fri, 12 Nov 2010 11:46:50 -0800
Message-ID: <201011121946.oACJkoa6028150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735Ab0KLTrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:47:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, fengguang.wu@intel.com


The patch titled
     mm/page-writeback.c: fix __set_page_dirty_no_writeback() return value
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch

