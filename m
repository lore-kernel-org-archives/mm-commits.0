From: akpm@linux-foundation.org
Subject: + mm-no-get_user-put_user-while-holding-mmap_sem-in-do_pages_stat.patch added to -mm tree
Date: Mon, 08 Dec 2008 15:57:39 -0800
Message-ID: <200812082357.mB8NvdZQ026953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYLHX6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 18:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Brice.Goglin@inria.fr, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, npiggin@suse.de


The patch titled
     mm: no get_user/put_user while holding mmap_sem in do_pages_stat?
has been added to the -mm tree.  Its filename is
     mm-no-get_user-put_user-while-holding-mmap_sem-in-do_pages_stat.patch

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
Subject: mm: no get_user/put_user while holding mmap_sem in do_pages_stat?
From: Brice Goglin <Brice.Goglin@inria.fr>

Since commit 2f007e74bb85b9fc4eab28524052161703300f1a, do_pages_stat()
gets the page address from user-space and puts the corresponding status
back while holding the mmap_sem for read.  There is no need to hold
mmap_sem there while some page-faults may occur.

This patch adds a temporary address and status buffer so as to only
hold mmap_sem while working on these kernel buffers.  This is
implemented by extracting do_pages_stat_array() out of do_pages_stat().

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   59 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 13 deletions(-)

diff -puN mm/migrate.c~mm-no-get_user-put_user-while-holding-mmap_sem-in-do_pages_stat mm/migrate.c
--- a/mm/migrate.c~mm-no-get_user-put_user-while-holding-mmap_sem-in-do_pages_stat
+++ a/mm/migrate.c
@@ -987,25 +987,18 @@ out:
 /*
  * Determine the nodes of an array of pages and store it in an array of status.
  */
-static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
-			 const void __user * __user *pages,
-			 int __user *status)
+static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
+				const void __user **pages, int *status)
 {
 	unsigned long i;
-	int err;
 
 	down_read(&mm->mmap_sem);
 
 	for (i = 0; i < nr_pages; i++) {
-		const void __user *p;
-		unsigned long addr;
+		unsigned long addr = (unsigned long)(*pages);
 		struct vm_area_struct *vma;
 		struct page *page;
-
-		err = -EFAULT;
-		if (get_user(p, pages+i))
-			goto out;
-		addr = (unsigned long) p;
+		int err;
 
 		vma = find_vma(mm, addr);
 		if (!vma)
@@ -1024,12 +1017,52 @@ static int do_pages_stat(struct mm_struc
 
 		err = page_to_nid(page);
 set_status:
-		put_user(err, status+i);
+		*status = err;
+
+		pages++;
+		status++;
+	}
+
+	up_read(&mm->mmap_sem);
+}
+
+/*
+ * Determine the nodes of a user array of pages and store it in
+ * a user array of status.
+ */
+static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
+			 const void __user * __user *pages,
+			 int __user *status)
+{
+#define DO_PAGES_STAT_CHUNK_NR 16
+	const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];
+	int chunk_status[DO_PAGES_STAT_CHUNK_NR];
+	unsigned long i, chunk_nr = DO_PAGES_STAT_CHUNK_NR;
+	int err;
+
+	for (i = 0; i < nr_pages; i += chunk_nr) {
+		if (chunk_nr + i > nr_pages)
+			chunk_nr = nr_pages - i;
+
+		err = copy_from_user(chunk_pages, &pages[i],
+				     chunk_nr * sizeof(*chunk_pages));
+		if (err) {
+			err = -EFAULT;
+			goto out;
+		}
+
+		do_pages_stat_array(mm, chunk_nr, chunk_pages, chunk_status);
+
+		err = copy_to_user(&status[i], chunk_status,
+				   chunk_nr * sizeof(*chunk_status));
+		if (err) {
+			err = -EFAULT;
+			goto out;
+		}
 	}
 	err = 0;
 
 out:
-	up_read(&mm->mmap_sem);
 	return err;
 }
 
_

Patches currently in -mm which might be from Brice.Goglin@inria.fr are

mm-no-get_user-put_user-while-holding-mmap_sem-in-do_pages_stat.patch
mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch
mm-rework-do_pages_move-to-work-on-page_sized-chunks-update.patch
mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch

