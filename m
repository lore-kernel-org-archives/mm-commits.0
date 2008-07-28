From: akpm@linux-foundation.org
Subject: + memcg-remove-redundant-check-in-move_task.patch added to -mm tree
Date: Sun, 27 Jul 2008 20:24:11 -0700
Message-ID: <200807280324.m6S3OBYG017793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbYG1DYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 23:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     memcg: remove redundant check in move_task()
has been added to the -mm tree.  Its filename is
     memcg-remove-redundant-check-in-move_task.patch

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
Subject: memcg: remove redundant check in move_task()
From: Li Zefan <lizf@cn.fujitsu.com>

It's guaranteed by cgroup that old_cgrp != cgrp.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-check-in-move_task mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-check-in-move_task
+++ a/mm/memcontrol.c
@@ -1168,9 +1168,6 @@ static void mem_cgroup_move_task(struct 
 	mem = mem_cgroup_from_cont(cont);
 	old_mem = mem_cgroup_from_cont(old_cont);
 
-	if (mem == old_mem)
-		goto out;
-
 	/*
 	 * Only thread group leaders are allowed to migrate, the mm_struct is
 	 * in effect owned by the leader
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cgroup-fix-possible-memory-leak.patch
cgroup-remove-duplicate-code-in-allocate_cg_link.patch
cgroup-uninline-cgroup_has_css_refs.patch
memcg-remove-redundant-check-in-move_task.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch

