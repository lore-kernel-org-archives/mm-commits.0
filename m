From: akpm@linux-foundation.org
Subject: + fs-nobh_truncate_page-fix.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:28:47 -0800
Message-ID: <200703060428.l264SlT4011797@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50314 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbXCFEcD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:32:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaggy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au


The patch titled
     fs: nobh_truncate_page() fix
has been added to the -mm tree.  Its filename is
     fs-nobh_truncate_page-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: nobh_truncate_page() fix
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

This fixes a regression caused by 22c8ca78f20724676b6006232bf06cc3e9299539.

nobh_prepare_write() no longer marks the page uptodate, so
nobh_truncate_page() needs to do it.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/buffer.c~fs-nobh_truncate_page-fix fs/buffer.c
--- a/fs/buffer.c~fs-nobh_truncate_page-fix
+++ a/fs/buffer.c
@@ -2365,6 +2365,10 @@ failed:
 }
 EXPORT_SYMBOL(nobh_prepare_write);
 
+/*
+ * Make sure any changes to nobh_commit_write() are reflected in
+ * nobh_truncate_page(), since it doesn't call commit_write().
+ */
 int nobh_commit_write(struct file *file, struct page *page,
 		unsigned from, unsigned to)
 {
@@ -2466,6 +2470,11 @@ int nobh_truncate_page(struct address_sp
 		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
 		flush_dcache_page(page);
 		kunmap_atomic(kaddr, KM_USER0);
+		/*
+		 * It would be more correct to call aops->commit_write()
+		 * here, but this is more efficient.
+		 */
+		SetPageUptodate(page);
 		set_page_dirty(page);
 	}
 	unlock_page(page);
_

Patches currently in -mm which might be from shaggy@linux.vnet.ibm.com are

fs-nobh_truncate_page-fix.patch
