From: akpm@linux-foundation.org
Subject: + s390-remove-struct-page-entries-for-dcss-memory-segments.patch added to -mm tree
Date: Tue, 01 Apr 2008 15:36:28 -0700
Message-ID: <200804012236.m31MaSJh017232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYDAWiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 18:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cotte@de.ibm.com, heiko.carstens@de.ibm.com, jaredeh@gmail.com, npiggin@suse.de, schwidefsky@de.ibm.com


The patch titled
     s390: remove struct page entries for DCSS memory segments
has been added to the -mm tree.  Its filename is
     s390-remove-struct-page-entries-for-dcss-memory-segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: remove struct page entries for DCSS memory segments
From: Carsten Otte <cotte@de.ibm.com>

Remove struct page entries for DCSS segments that are being loaded.  They
can still be accessed correctly, thanks to the struct page-less XIP work of
previous patches.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/vmem.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -puN arch/s390/mm/vmem.c~s390-remove-struct-page-entries-for-dcss-memory-segments arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~s390-remove-struct-page-entries-for-dcss-memory-segments
+++ a/arch/s390/mm/vmem.c
@@ -343,8 +343,6 @@ out:
 int add_shared_memory(unsigned long start, unsigned long size)
 {
 	struct memory_segment *seg;
-	struct page *page;
-	unsigned long pfn, num_pfn, end_pfn;
 	int ret;
 
 	mutex_lock(&vmem_mutex);
@@ -359,24 +357,10 @@ int add_shared_memory(unsigned long star
 	if (ret)
 		goto out_free;
 
-	ret = vmem_add_mem(start, size, 0);
+	ret = vmem_add_range(start, size, 0);
 	if (ret)
 		goto out_remove;
 
-	pfn = PFN_DOWN(start);
-	num_pfn = PFN_DOWN(size);
-	end_pfn = pfn + num_pfn;
-
-	page = pfn_to_page(pfn);
-	memset(page, 0, num_pfn * sizeof(struct page));
-
-	for (; pfn < end_pfn; pfn++) {
-		page = pfn_to_page(pfn);
-		init_page_count(page);
-		reset_page_mapcount(page);
-		SetPageReserved(page);
-		INIT_LIST_HEAD(&page->lru);
-	}
 	goto out;
 
 out_remove:
_

Patches currently in -mm which might be from cotte@de.ibm.com are

git-kvm.patch
git-s390.patch
mm-introduce-vm_mixedmap.patch
mm-introduce-pte_special-pte-bit.patch
mm-add-vm_insert_mixed.patch
return-pfn-from-direct_access-for-xip.patch
xip-support-non-struct-page-backed-memory.patch
s390-implement-pte-special-bit.patch
s390-remove-struct-page-entries-for-dcss-memory-segments.patch
remove-duplicated-unlikely-in-is_err.patch

