From: akpm@linux-foundation.org
Subject: + mm-filemap_fault-unique-path-for-locking-page.patch added to -mm tree
Date: Tue, 05 Oct 2010 13:15:22 -0700
Message-ID: <201010052015.o95KFMaG017421__19976.8529892483$1286309793$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab0JEUQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 16:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au, riel@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yinghan@google.com


The patch titled
     mm: filemap_fault: unique path for locking page
has been added to the -mm tree.  Its filename is
     mm-filemap_fault-unique-path-for-locking-page.patch

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
Subject: mm: filemap_fault: unique path for locking page
From: Michel Lespinasse <walken@google.com>

Introduce a single location where filemap_fault() locks the desired page. 
There used to be two such places, depending if the initial find_get_page()
was successful or not.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/filemap.c~mm-filemap_fault-unique-path-for-locking-page mm/filemap.c
--- a/mm/filemap.c~mm-filemap_fault-unique-path-for-locking-page
+++ a/mm/filemap.c
@@ -1550,25 +1550,27 @@ int filemap_fault(struct vm_area_struct 
 		 * waiting for the lock.
 		 */
 		do_async_mmap_readahead(vma, ra, file, page, offset);
-		lock_page(page);
-
-		/* Did it get truncated? */
-		if (unlikely(page->mapping != mapping)) {
-			unlock_page(page);
-			put_page(page);
-			goto no_cached_page;
-		}
 	} else {
 		/* No page in the page cache at all */
 		do_sync_mmap_readahead(vma, ra, file, offset);
 		count_vm_event(PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
 retry_find:
-		page = find_lock_page(mapping, offset);
+		page = find_get_page(mapping, offset);
 		if (!page)
 			goto no_cached_page;
 	}
 
+	lock_page(page);
+
+	/* Did it get truncated? */
+	if (unlikely(page->mapping != mapping)) {
+		unlock_page(page);
+		put_page(page);
+		goto retry_find;
+	}
+	VM_BUG_ON(page->index != offset);
+
 	/*
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
_

Patches currently in -mm which might be from walken@google.com are

mm-filemap_fault-unique-path-for-locking-page.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
x86-access_error-api-cleanup.patch

