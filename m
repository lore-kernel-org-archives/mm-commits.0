From: akpm@linux-foundation.org
Subject: +
 futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch added to
 -mm tree
Date: Thu, 22 Oct 2015 12:39:18 -0700
Message-ID: <56293b66.6oc3ybZNo2kVKlf3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354AbbJVTjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Oct 2015 15:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, artem.savkov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: futex-thp-remove-special-case-for-thp-in-get_futex_key-fix
has been added to the -mm tree.  Its filename is
     futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -461,6 +461,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page;
+	struct address_space *mapping;
 	int err, ro = 0;
 
 	/*
@@ -526,7 +527,8 @@ again:
 	 * shmem_writepage move it from filecache to swapcache beneath us:
 	 * an unlikely race, but we do need to retry for page->mapping.
 	 */
-	if (!page->mapping) {
+	mapping = compound_head(page)->mapping;
+	if (!mapping) {
 		int shmem_swizzled = PageSwapCache(page);
 		unlock_page(page);
 		put_page(page);
@@ -557,7 +559,7 @@ again:
 		key->private.address = address;
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = page->mapping->host;
+		key->shared.inode = mapping->host;
 		key->shared.pgoff = basepage_index(page);
 	}
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
thp-reintroduce-split_huge_page-fix-2.patch

