From: akpm@linux-foundation.org
Subject: + vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch added to -mm tree
Date: Wed, 17 Sep 2008 15:51:17 -0700
Message-ID: <200809172251.m8HMpHiE002249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755432AbYIQWwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 18:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org


The patch titled
     memcg: fix handling of shmem migration
has been added to the -mm tree.  Its filename is
     vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix handling of shmem migration
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Before this patch, if migrating shmem/tmpfs pages, newpage would be
charged with PAGE_CGROUP_FLAG_FILE set, while oldpage has been charged
without the flag.

The problem here is mem_cgroup_move_lists doesn't clear(or set) the
PAGE_CGROUP_FLAG_FILE flag, so pc->flags of the newpage remains
PAGE_CGROUP_FLAG_FILE set even when the pc is moved to another lru(anon)
by mem_cgroup_move_lists.  And this leads to incorrect MEM_CGROUP_ZSTAT.

In my test, I see an underflow of MEM_CGROUP_ZSTAT(active_file).  As a
result, mem_cgroup_calc_reclaim returns very huge number and causes soft
lockup on page reclaim.

I'm not sure if mem_cgroup_move_lists should handle PAGE_CGROUP_FLAG_FILE
or not(I suppose it should be used to move between active <-> inactive,
not anon <-> file), I added MEM_CGROUP_CHARGE_TYPE_SHMEM for precharge at
shmem's page migration.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2 mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2
+++ a/mm/memcontrol.c
@@ -178,6 +178,7 @@ enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
+	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 };
 
 /*
@@ -575,8 +576,10 @@ static int mem_cgroup_charge_common(stru
 			pc->flags |= PAGE_CGROUP_FLAG_FILE;
 		else
 			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
-	} else
+	} else if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
 		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
+	else /* MEM_CGROUP_CHARGE_TYPE_SHMEM */
+		pc->flags = PAGE_CGROUP_FLAG_CACHE | PAGE_CGROUP_FLAG_ACTIVE;
 
 	lock_page_cgroup(page);
 	if (unlikely(page_get_page_cgroup(page))) {
@@ -735,8 +738,12 @@ int mem_cgroup_prepare_migration(struct 
 	if (pc) {
 		mem = pc->mem_cgroup;
 		css_get(&mem->css);
-		if (pc->flags & PAGE_CGROUP_FLAG_CACHE)
-			ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
+		if (pc->flags & PAGE_CGROUP_FLAG_CACHE) {
+			if (page_is_file_cache(page))
+				ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
+			else
+				ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+		}
 	}
 	unlock_page_cgroup(page);
 	if (mem) {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

mm-owner-fix-race-between-swap-and-exit-fix-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch
unevictable-lru-infrastructure.patch

