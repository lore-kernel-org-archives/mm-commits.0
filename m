From: akpm@linux-foundation.org
Subject: + hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch added to -mm tree
Date: Thu, 01 Mar 2012 14:10:22 -0800
Message-ID: <20120301221022.C024AA0313@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:37831 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab2CAWKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 17:10:25 -0500
Received: by faaa19 with SMTP id a19so42725faa.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 14:10:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: hugetlbfs: avoid taking i_mutex from hugetlbfs_read()
has been added to the -mm tree.  Its filename is
     hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlbfs: avoid taking i_mutex from hugetlbfs_read()

Taking i_mutex in hugetlbfs_read() can result in deadlock with mmap as
explained below

 Thread A:
  read() on hugetlbfs
   hugetlbfs_read() called
    i_mutex grabbed
     hugetlbfs_read_actor() called
      __copy_to_user() called
       page fault is triggered
 Thread B, sharing address space with A:
  mmap() the same file
   ->mmap_sem is grabbed on task_B->mm->mmap_sem
    hugetlbfs_file_mmap() is called
     attempt to grab ->i_mutex and block waiting for A to give it up
 Thread A:
  pagefault handled blocked on attempt to grab task_A->mm->mmap_sem,
 which happens to be the same thing as task_B->mm->mmap_sem.  Block waiting
 for B to give it up.

AFAIU the i_mutex locking was added to hugetlbfs_read() as per
http://lkml.indiana.edu/hypermail/linux/kernel/0707.2/3066.html to take
care of the race between truncate and read.  This patch fixes this by
looking at page->mapping under lock_page() (find_lock_page()) to ensure
that the inode didn't get truncated in the range during a parallel read.

Ideally we can extend the patch to make sure we don't increase i_size in
mmap.  But that will break userspace, because applications will now have
to use truncate(2) to increase i_size in hugetlbfs.

Based on the original patch from Hillf Danton.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>				
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read
+++ a/fs/hugetlbfs/inode.c
@@ -245,17 +245,10 @@ static ssize_t hugetlbfs_read(struct fil
 	loff_t isize;
 	ssize_t retval = 0;
 
-	mutex_lock(&inode->i_mutex);
-
 	/* validate length */
 	if (len == 0)
 		goto out;
 
-	isize = i_size_read(inode);
-	if (!isize)
-		goto out;
-
-	end_index = (isize - 1) >> huge_page_shift(h);
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
@@ -263,18 +256,21 @@ static ssize_t hugetlbfs_read(struct fil
 
 		/* nr is the maximum number of bytes to copy from this page */
 		nr = huge_page_size(h);
+		isize = i_size_read(inode);
+		if (!isize)
+			goto out;
+		end_index = (isize - 1) >> huge_page_shift(h);
 		if (index >= end_index) {
 			if (index > end_index)
 				goto out;
 			nr = ((isize - 1) & ~huge_page_mask(h)) + 1;
-			if (nr <= offset) {
+			if (nr <= offset)
 				goto out;
-			}
 		}
 		nr = nr - offset;
 
 		/* Find the page */
-		page = find_get_page(mapping, index);
+		page = find_lock_page(mapping, index);
 		if (unlikely(page == NULL)) {
 			/*
 			 * We have a HOLE, zero out the user-buffer for the
@@ -286,17 +282,18 @@ static ssize_t hugetlbfs_read(struct fil
 			else
 				ra = 0;
 		} else {
+			unlock_page(page);
+
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
 			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
 			ret = ra;
+			page_cache_release(page);
 		}
 		if (ra < 0) {
 			if (retval == 0)
 				retval = ra;
-			if (page)
-				page_cache_release(page);
 			goto out;
 		}
 
@@ -306,16 +303,12 @@ static ssize_t hugetlbfs_read(struct fil
 		index += offset >> huge_page_shift(h);
 		offset &= ~huge_page_mask(h);
 
-		if (page)
-			page_cache_release(page);
