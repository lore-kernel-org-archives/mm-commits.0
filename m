From: akpm@linux-foundation.org
Subject: + set_page_refcounted-vm_bug_on-fix.patch added to -mm tree
Date: Fri, 21 Dec 2007 00:25:23 -0800
Message-ID: <200712210825.lBL8PNhW004729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbXLUI1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 03:27:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiyong@fc-cn.com, clameter@sgi.com


The patch titled
     set_page_refcounted() VM_BUG_ON fix
has been added to the -mm tree.  Its filename is
     set_page_refcounted-vm_bug_on-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

skip-writing-data-pages-when-inode-is-under-i_sync.patch
set_page_refcounted-vm_bug_on-fix.patch
kill-an-unused-ptr_err-in-bdev_cache_init.patch
