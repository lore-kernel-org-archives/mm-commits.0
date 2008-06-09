From: akpm@linux-foundation.org
Subject: + memcg-handle-swap-cache-fix.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:13:11 -0700
Message-ID: <200806090613.m596DBpw006441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbYFIGNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, ebiederm@xmission.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujtsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg-handle-swap-cache fix
has been added to the -mm tree.  Its filename is
     memcg-handle-swap-cache-fix.patch

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
Subject: memcg-handle-swap-cache fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now (-mm queue), SwapCache is handled by memcg.
But Handling migration of swap-cache was wrong.

Fix to call uncharge() after ClearPageSwapCache() as
__delete_from_swap_cache()(swap_state.c) does.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtsu.com>
Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN mm/migrate.c~memcg-handle-swap-cache-fix mm/migrate.c
--- a/mm/migrate.c~memcg-handle-swap-cache-fix
+++ a/mm/migrate.c
@@ -358,10 +358,8 @@ static int migrate_page_move_mapping(str
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
 
 	write_unlock_irq(&mapping->tree_lock);
-	if (!PageSwapCache(newpage)) {
+	if (!PageSwapCache(newpage))
 		mem_cgroup_uncharge_cache_page(page);
-	} else
-		mem_cgroup_uncharge_page(page);
 
 	return 0;
 }
@@ -399,7 +397,15 @@ static void migrate_page_copy(struct pag
  	}
 
 #ifdef CONFIG_SWAP
-	ClearPageSwapCache(page);
+	if (PageSwapCache(page)) {
+		ClearPageSwapCache(page);
+		/*
+		 * SwapCache is removed implicitly. Uncharge against swapcache
+		 * should be called after ClearPageSwapCache() because
+		 * mem_cgroup_uncharge_page checks the flag.
+		 */
+		mem_cgroup_uncharge_page(page);
+	}
 #endif
 	ClearPageActive(page);
 	ClearPagePrivate(page);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch

