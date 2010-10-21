From: akpm@linux-foundation.org
Subject: + mm-fix-error-reporting-in-move_pages-syscall.patch added to -mm tree
Date: Thu, 21 Oct 2010 12:14:48 -0700
Message-ID: <201010211914.o9LJEmcQ030515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755772Ab0JUTP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 15:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gleb@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     mm: fix error reporting in move_pages() syscall
has been added to the -mm tree.  Its filename is
     mm-fix-error-reporting-in-move_pages-syscall.patch

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
Subject: mm: fix error reporting in move_pages() syscall
From: Gleb Natapov <gleb@redhat.com>

The vma returned by find_vma does not necessarily include the target
address.  If this happens the code tries to follow a page outside of any
vma and returns ENOENT instead of EFAULT.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-fix-error-reporting-in-move_pages-syscall mm/migrate.c
--- a/mm/migrate.c~mm-fix-error-reporting-in-move_pages-syscall
+++ a/mm/migrate.c
@@ -1037,7 +1037,7 @@ static int do_move_page_to_node_array(st
 
 		err = -EFAULT;
 		vma = find_vma(mm, pp->addr);
-		if (!vma || !vma_migratable(vma))
+		if (!vma || pp->addr < vma->vm_start || !vma_migratable(vma))
 			goto set_status;
 
 		page = follow_page(vma, pp->addr, FOLL_GET);
@@ -1204,7 +1204,7 @@ static void do_pages_stat_array(struct m
 		int err = -EFAULT;
 
 		vma = find_vma(mm, addr);
-		if (!vma)
+		if (!vma || addr < vma->vm_start)
 			goto set_status;
 
 		page = follow_page(vma, addr, 0);
_

Patches currently in -mm which might be from gleb@redhat.com are

linux-next.patch
mm-fix-error-reporting-in-move_pages-syscall.patch

