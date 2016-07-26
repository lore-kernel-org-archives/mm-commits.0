From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
 removed from -mm tree
Date: Tue, 26 Jul 2016 15:10:46 -0700
Message-ID: <5797dfe6.zRf9pQsC5jDl2XzN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbcGZWKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, ebru.akagunduz@gmail.com, kirill.shutemov@linux.intel.com, riel@redhat.com, sergey.senozhatsky.work@gmail.com, sfr@canb.auug.org.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch

This patch was dropped because it was folded into mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject:  mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix

update comment to match new code

Link: http://lkml.kernel.org/r/1466021202-61880-5-git-send-email-kirill.shutemov@linux.intel.com
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix
+++ a/mm/huge_memory.c
@@ -2493,9 +2493,9 @@ static void collapse_huge_page(struct mm
 	}
 
 	/*
-	 * __collapse_huge_page_swapin always returns with mmap_sem
-	 * locked. If it fails, release mmap_sem and jump directly
-	 * label out. Continuing to collapse causes inconsistency.
+	 * __collapse_huge_page_swapin always returns with mmap_sem locked.
+	 * If it fails, release mmap_sem and jump directly out.
+	 * Continuing to collapse causes inconsistency.
 	 */
 	if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
 		up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch

