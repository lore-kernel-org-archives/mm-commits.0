From: akpm@linux-foundation.org
Subject: + mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment.patch added to -mm tree
Date: Mon, 09 Jul 2012 16:52:19 -0700
Message-ID: <20120709235220.14C455C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36192 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2GIXwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 19:52:22 -0400
Received: by wibhr14 with SMTP id hr14so183098wib.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 16:52:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com


The patch titled
     Subject: mm/memcg: replace inexistence move_lock_page_cgroup() by move_lock_mem_cgroup() in comment
has been added to the -mm tree.  Its filename is
     mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm/memcg: replace inexistence move_lock_page_cgroup() by move_lock_mem_cgroup() in comment

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment
+++ a/mm/memcontrol.c
@@ -1898,7 +1898,7 @@ again:
 		return;
 	/*
 	 * If this memory cgroup is not under account moving, we don't
-	 * need to take move_lock_page_cgroup(). Because we already hold
+	 * need to take move_lock_mem_cgroup(). Because we already hold
 	 * rcu_read_lock(), any calls to move_account will be delayed until
 	 * rcu_read_unlock() if mem_cgroup_stolen() == true.
 	 */
@@ -1920,7 +1920,7 @@ void __mem_cgroup_end_update_page_stat(s
 	/*
 	 * It's guaranteed that pc->mem_cgroup never changes while
 	 * lock is held because a routine modifies pc->mem_cgroup
-	 * should take move_lock_page_cgroup().
+	 * should take move_lock_mem_cgroup().
 	 */
 	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
 }
_
Subject: Subject: mm/memcg: replace inexistence move_lock_page_cgroup() by move_lock_mem_cgroup() in comment

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-remove-unused-lru_all_evictable.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch
mm-memcg-complete-documentation-for-tcp-memcg-files.patch
mm-memcg-mem_cgroup_relize_xxx_limit-can-guarantee-memcg-reslimit-=-memcg-memswlimit.patch
mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment.patch

