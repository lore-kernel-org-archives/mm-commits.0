From: akpm@linux-foundation.org
Subject: [merged] page-writeback-fix-the-calculation-of-the-oldest_jif-in-wb_kupdate.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:12 -0700
Message-ID: <200905261935.n4QJZCcE006109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964AbZEZTgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.okajima@jp.fujitsu.com, adobriyan@gmail.com, nickpiggin@yahoo.com.au, peterz@infradead.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     page-writeback: fix the calculation of the oldest_jif in wb_kupdate()
has been removed from the -mm tree.  Its filename was
     page-writeback-fix-the-calculation-of-the-oldest_jif-in-wb_kupdate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-writeback: fix the calculation of the oldest_jif in wb_kupdate()
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

wb_kupdate() function has a bug on linux-2.6.30-rc5.  This bug causes
generic_sync_sb_inodes() to start to write inodes back much earlier than
our expectations because it miscalculates oldest_jif in wb_kupdate().

Fixes a whoops added in:

: Author:     Alexey Dobriyan <adobriyan@gmail.com>
: AuthorDate: Tue Mar 31 15:23:18 2009 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Wed Apr 1 08:59:13 2009 -0700
: 
:     mm: fix proc_dointvec_userhz_jiffies "breakage"

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page-writeback.c~page-writeback-fix-the-calculation-of-the-oldest_jif-in-wb_kupdate mm/page-writeback.c
--- a/mm/page-writeback.c~page-writeback-fix-the-calculation-of-the-oldest_jif-in-wb_kupdate
+++ a/mm/page-writeback.c
@@ -94,12 +94,12 @@ unsigned long vm_dirty_bytes;
 /*
  * The interval between `kupdate'-style writebacks
  */
-unsigned int dirty_writeback_interval = 5 * 100; /* sentiseconds */
+unsigned int dirty_writeback_interval = 5 * 100; /* centiseconds */
 
 /*
  * The longest time for which data is allowed to remain dirty
  */
-unsigned int dirty_expire_interval = 30 * 100; /* sentiseconds */
+unsigned int dirty_expire_interval = 30 * 100; /* centiseconds */
 
 /*
  * Flag that makes the machine dump writes/reads and block dirtyings.
@@ -770,7 +770,7 @@ static void wb_kupdate(unsigned long arg
 
 	sync_supers();
 
-	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval);
+	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
 	start_jif = jiffies;
 	next_jif = start_jif + msecs_to_jiffies(dirty_writeback_interval * 10);
 	nr_to_write = global_page_state(NR_FILE_DIRTY) +
_

Patches currently in -mm which might be from toshi.okajima@jp.fujitsu.com are


