From: akpm@linux-foundation.org
Subject: - set_page_refcounted-vm_bug_on-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:16 -0800
Message-ID: <200802052231.m15MVvAV012201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762315AbYBEWlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiyong@fc-cn.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     set_page_refcounted() VM_BUG_ON fix
has been removed from the -mm tree.  Its filename was
     set_page_refcounted-vm_bug_on-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: set_page_refcounted() VM_BUG_ON fix
From: Qi Yong <qiyong@fc-cn.com>

The current PageTail semantic is that a PageTail page is first a
PageCompound page.  So remove the redundant PageCompound test in
set_page_refcounted().

Signed-off-by: Qi Yong <qiyong@fc-cn.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/internal.h~set_page_refcounted-vm_bug_on-fix mm/internal.h
--- a/mm/internal.h~set_page_refcounted-vm_bug_on-fix
+++ a/mm/internal.h
@@ -24,7 +24,7 @@ static inline void set_page_count(struct
  */
 static inline void set_page_refcounted(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page) && PageTail(page));
+	VM_BUG_ON(PageTail(page));
 	VM_BUG_ON(atomic_read(&page->_count));
 	set_page_count(page, 1);
 }
_

Patches currently in -mm which might be from qiyong@fc-cn.com are

origin.patch
kill-an-unused-ptr_err-in-bdev_cache_init.patch
