From: akpm@linux-foundation.org
Subject: + vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:44 -0700
Message-ID: <200806090618.m596Ii2k006643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbYFIGTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:19:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     vmscan: downgrade mmap sem while populating mlocked regions
has been added to the -mm tree.  Its filename is
     vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch

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
Subject: vmscan: downgrade mmap sem while populating mlocked regions
From: Rik van Riel <riel@redhat.com>
Return-Path: <riel@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.2.4 (2008-01-01) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=none autolearn=ham
	version=3.2.4
Received: from y.localdomain (y.localdomain [127.0.0.1])
	by y.localdomain (8.14.2/8.14.2) with ESMTP id m56KY9S9006291
	for <akpm@localhost>; Fri, 6 Jun 2008 13:34:24 -0700
Received: from imap1.linux-foundation.org [140.211.169.55]
	by y.localdomain with IMAP (fetchmail-6.3.8)
	for <akpm@localhost> (single-drop); Fri, 06 Jun 2008 13:34:24 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [140.211.169.14])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m56KV41g017810
	for <akpm@imap1.linux-foundation.org>; Fri, 6 Jun 2008 13:31:04 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m56KUTS2007978
	for <akpm@linux-foundation.org>; Fri, 6 Jun 2008 13:30:31 -0700
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m56KTtCZ004026;
	Fri, 6 Jun 2008 16:29:55 -0400
Received: from mail.boston.redhat.com (mail.boston.redhat.com [10.16.255.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56KTsji031780;
	Fri, 6 Jun 2008 16:29:55 -0400
Received: from cuia.bos.redhat.com (cuia.bos.redhat.com [10.16.16.26])
	by mail.boston.redhat.com (8.13.1/8.13.1) with ESMTP id m56KTs4j007532;
	Fri, 6 Jun 2008 16:29:54 -0400
Received: from cuia.bos.redhat.com (localhost.localdomain [127.0.0.1])
	by cuia.bos.redhat.com (8.14.2/8.13.6) with ESMTP id m56KTsnn030649;
	Fri, 6 Jun 2008 16:29:54 -0400
Received: (from riel@localhost)
	by cuia.bos.redhat.com (8.14.2/8.14.2/Submit) id m56KTsFL030648;
	Fri, 6 Jun 2008 16:29:54 -0400
X-Authentication-Warning: cuia.bos.redhat.com: riel set sender to riel@redhat.com using -f
Message-Id: <20080606202859.587467653@redhat.com>
References: <20080606202838.390050172@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:28:56 -0400
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 18/25] Downgrade mmap sem while populating mlocked regions
Content-Disposition: inline; filename=rvr-18-lts-noreclaim-mlocked-page-statistics.patch
X-Scanned-By: MIMEDefang 2.53 on 140.211.169.14
Received-SPF: pass (domain of riel@redhat.com designates 66.187.233.31 as permitted sender)
X-MIMEDefang-Filter: lf$Revision: 1.188 $


Against:  2.6.26-rc2-mm1

We need to hold the mmap_sem for write to initiatate mlock()/munlock()
because we may need to merge/split vmas.  However, this can lead to
very long lock hold times attempting to fault in a large memory region
to mlock it into memory.   This can hold off other faults against the
mm [multithreaded tasks] and other scans of the mm, such as via /proc.
To alleviate this, downgrade the mmap_sem to read mode during the 
population of the region for locking.  This is especially the case 
if we need to reclaim memory to lock down the region.  We [probably?]
don't need to do this for unlocking as all of the pages should be
resident--they're already mlocked.

Now, the caller's of the mlock functions [mlock_fixup() and 
mlock_vma_pages_range()] expect the mmap_sem to be returned in write
mode.  Changing all callers appears to be way too much effort at this
point.  So, restore write mode before returning.  Note that this opens
a window where the mmap list could change in a multithreaded process.
So, at least for mlock_fixup(), where we could be called in a loop over
multiple vmas, we check that a vma still exists at the start address
and that vma still covers the page range [start,end).  If not, we return
an error, -EAGAIN, and let the caller deal with it.

Return -EAGAIN from mlock_vma_pages_range() function and mlock_fixup()
if the vma at 'start' disappears or changes so that the page range
[start,end) is no longer contained in the vma.  Again, let the caller
deal with it.  Looks like only sys_remap_file_pages() [via mmap_region()]
should actually care.

With this patch, I no longer see processes like ps(1) blocked for seconds
or minutes at a time waiting for a large [multiple gigabyte] region to be
locked down.  However, I occassionally see delays while unlocking or
unmapping a large mlocked region.  Should we also downgrade the mmap_sem
for the unlock path?

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

--- 
V2 -> V3:
+ rebase to 23-mm1 atop RvR's split lru series [no change]
+ fix function return types [void -> int] to fix build when
  not configured.

New in V2.

 mm/mlock.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc2-mm1/mm/mlock.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/mlock.c	2008-06-06 16:06:28.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/mlock.c	2008-06-06 16:06:32.000000000 -0400
@@ -309,6 +309,7 @@ static void __munlock_vma_pages_range(st
 int mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int nr_pages = (end - start) / PAGE_SIZE;
 	BUG_ON(!(vma->vm_flags & VM_LOCKED));
 
@@ -323,7 +324,17 @@ int mlock_vma_pages_range(struct vm_area
 			vma == get_gate_vma(current))
 		goto make_present;
 
-	return __mlock_vma_pages_range(vma, start, end);
+	downgrade_write(&mm->mmap_sem);
+	nr_pages = __mlock_vma_pages_range(vma, start, end);
+
+	up_read(&mm->mmap_sem);
+	/* vma can change or disappear */
+	down_write(&mm->mmap_sem);
+	vma = find_vma(mm, start);
+	/* non-NULL vma must contain @start, but need to check @end */
+	if (!vma ||  end > vma->vm_end)
+		return -EAGAIN;
+	return nr_pages;
 
 make_present:
 	/*
@@ -418,13 +429,41 @@ success:
 	vma->vm_flags = newflags;
 
 	if (lock) {
+		/*
+		 * mmap_sem is currently held for write.  Downgrade the write
+		 * lock to a read lock so that other faults, mmap scans, ...
+		 * while we fault in all pages.
+		 */
+		downgrade_write(&mm->mmap_sem);
+
 		ret = __mlock_vma_pages_range(vma, start, end);
 		if (ret > 0) {
 			mm->locked_vm -= ret;
 			ret = 0;
 		}
-	} else
+		/*
+		 * Need to reacquire mmap sem in write mode, as our callers
+		 * expect this.  We have no support for atomically upgrading
+		 * a sem to write, so we need to check for ranges while sem
+		 * is unlocked.
+		 */
+		up_read(&mm->mmap_sem);
+		/* vma can change or disappear */
+		down_write(&mm->mmap_sem);
+		*prev = find_vma(mm, start);
+		/* non-NULL *prev must contain @start, but need to check @end */
+		if (!(*prev) || end > (*prev)->vm_end)
+			ret = -EAGAIN;
+	} else {
+		/*
+		 * TODO:  for unlocking, pages will already be resident, so
+		 * we don't need to wait for allocations/reclaim/pagein, ...
+		 * However, unlocking a very large region can still take a
+		 * while.  Should we downgrade the semaphore for both lock
+		 * AND unlock ?
+		 */
 		__munlock_vma_pages_range(vma, start, end);
+	}
 
 out:
 	*prev = vma;

-- 
All Rights Reversed

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
vmscan-define-page_file_cache-function.patch
vmscan-pageflag-helpers-for-configed-out-flags.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch

