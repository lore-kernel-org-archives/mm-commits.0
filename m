From: akpm@linux-foundation.org
Subject: + dio-use-get_user_pages_fast.patch added to -mm tree
Date: Mon, 02 Jun 2008 16:57:45 -0700
Message-ID: <200806022357.m52NvjuN006437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbYFBX6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 19:58:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, andi@firstfloor.org, apw@shadowen.org, jens.axboe@oracle.com, mingo@elte.hu, pbadari@us.ibm.com, shaggy@austin.ibm.com, tglx@linutronix.de, zach.brown@oracle.com


The patch titled
     dio: use get_user_pages_fast
has been added to the -mm tree.  Its filename is
     dio-use-get_user_pages_fast.patch

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
Subject: dio: use get_user_pages_fast
From: Nick Piggin <npiggin@suse.de>

Use get_user_pages_fast in the common/generic block and fs direct IO paths.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c       |    8 ++------
 fs/direct-io.c |   10 ++--------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff -puN fs/bio.c~dio-use-get_user_pages_fast fs/bio.c
--- a/fs/bio.c~dio-use-get_user_pages_fast
+++ a/fs/bio.c
@@ -713,12 +713,8 @@ static struct bio *__bio_map_user_iov(st
 		const int local_nr_pages = end - start;
 		const int page_limit = cur_page + local_nr_pages;
 		
-		down_read(&current->mm->mmap_sem);
-		ret = get_user_pages(current, current->mm, uaddr,
-				     local_nr_pages,
-				     write_to_vm, 0, &pages[cur_page], NULL);
-		up_read(&current->mm->mmap_sem);
-
+		ret = get_user_pages_fast(uaddr, local_nr_pages,
+				write_to_vm, &pages[cur_page]);
 		if (ret < local_nr_pages) {
 			ret = -EFAULT;
 			goto out_unmap;
diff -puN fs/direct-io.c~dio-use-get_user_pages_fast fs/direct-io.c
--- a/fs/direct-io.c~dio-use-get_user_pages_fast
+++ a/fs/direct-io.c
@@ -150,17 +150,11 @@ static int dio_refill_pages(struct dio *
 	int nr_pages;
 
 	nr_pages = min(dio->total_pages - dio->curr_page, DIO_PAGES);
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(
-		current,			/* Task for fault acounting */
-		current->mm,			/* whose pages? */
+	ret = get_user_pages_fast(
 		dio->curr_user_address,		/* Where from? */
 		nr_pages,			/* How many pages? */
 		dio->rw == READ,		/* Write to memory? */
-		0,				/* force (?) */
-		&dio->pages[0],
-		NULL);				/* vmas */
-	up_read(&current->mm->mmap_sem);
+		&dio->pages[0]);		/* Put results here */
 
 	if (ret < 0 && dio->blocks_available && (dio->rw & WRITE)) {
 		struct page *page = ZERO_PAGE(0);
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

