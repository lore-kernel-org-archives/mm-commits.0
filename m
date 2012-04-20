From: akpm@linux-foundation.org
Subject: + mm-fix-null-ptr-dereference-in-move_pages.patch added to -mm tree
Date: Fri, 20 Apr 2012 14:59:35 -0700
Message-ID: <20120420215935.440B0A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51620 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab2DTV7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 17:59:36 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so1159781qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 14:59:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, cl@linux.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: mm: fix NULL ptr dereference in move_pages
has been added to the -mm tree.  Its filename is
     mm-fix-null-ptr-dereference-in-move_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: fix NULL ptr dereference in move_pages

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
mm-fix-null-ptr-dereference-in-migrate_pages.patch
mm-fix-null-ptr-dereference-in-move_pages.patch
brlocks-lglocks-cleanups.patch

