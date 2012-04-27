From: akpm@linux-foundation.org
Subject: [merged] mm-fix-null-ptr-dereference-in-move_pages.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:34 -0700
Message-ID: <20120427193534.948DAA02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41549 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761334Ab2D0Tfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:36 -0400
Received: by mail-bk0-f74.google.com with SMTP id j5so54044bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, cl@linux.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix NULL ptr dereference in move_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-null-ptr-dereference-in-move_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: mm: fix NULL ptr dereference in move_pages

Commit 3268c63 ("mm: fix move/migrate_pages() race on task struct") has
added an odd construct where 'mm' is checked for being NULL, and if it is,
it would get dereferenced anyways by mput()ing it.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/migrate.c~mm-fix-null-ptr-dereference-in-move_pages mm/migrate.c
--- a/mm/migrate.c~mm-fix-null-ptr-dereference-in-move_pages
+++ a/mm/migrate.c
@@ -1388,14 +1388,14 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, 
 	mm = get_task_mm(task);
 	put_task_struct(task);
 
-	if (mm) {
-		if (nodes)
-			err = do_pages_move(mm, task_nodes, nr_pages, pages,
-					    nodes, status, flags);
-		else
-			err = do_pages_stat(mm, nr_pages, pages, status);
-	} else
-		err = -EINVAL;
+	if (!mm)
+		return -EINVAL;
+
+	if (nodes)
+		err = do_pages_move(mm, task_nodes, nr_pages, pages,
+				    nodes, status, flags);
+	else
+		err = do_pages_stat(mm, nr_pages, pages, status);
 
 	mmput(mm);
 	return err;
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
linux-next.patch
brlocks-lglocks-cleanups.patch

