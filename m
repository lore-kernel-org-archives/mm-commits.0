From: akpm@linux-foundation.org
Subject: [folded-merged]
 futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:33:53 -0800
Message-ID: <56982251.umEDp5wbBTJ8wmRX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbcANWdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:33:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, artem.savkov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: futex-thp-remove-special-case-for-thp-in-get_futex_key-fix
has been removed from the -mm tree.  Its filename was
     futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch

This patch was dropped because it was folded into futex-thp-remove-special-case-for-thp-in-get_futex_key.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: futex-thp-remove-special-case-for-thp-in-get_futex_key-fix

fix oops caused by treating tail page as a head page

Reported-by: Artem Savkov <artem.savkov@gmail.com>
Tested-by: Artem Savkov <artem.savkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/futex.c~futex-thp-remove-special-case-for-thp-in-get_futex_key-fix kernel/futex.c
--- a/kernel/futex.c~futex-thp-remove-special-case-for-thp-in-get_futex_key-fix
+++ a/kernel/futex.c
@@ -470,6 +470,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page;
+	struct address_space *mapping;
 	int err, ro = 0;
 
 	/*
@@ -535,7 +536,8 @@ again:
 	 * shmem_writepage move it from filecache to swapcache beneath us:
 	 * an unlikely race, but we do need to retry for page->mapping.
 	 */
-	if (!page->mapping) {
+	mapping = compound_head(page)->mapping;
+	if (!mapping) {
 		int shmem_swizzled = PageSwapCache(page);
 		unlock_page(page);
 		put_page(page);
@@ -566,7 +568,7 @@ again:
 		key->private.address = address;
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = page->mapping->host;
+		key->shared.inode = mapping->host;
 		key->shared.pgoff = basepage_index(page);
 	}
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
thp-reintroduce-split_huge_page-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
thp-increase-split_huge_page-success-rate-fix.patch
mm-add-page_check_address_transhuge-helper-fix-fix.patch

