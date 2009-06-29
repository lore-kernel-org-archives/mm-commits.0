From: akpm@linux-foundation.org
Subject: + memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:03:14 -0700
Message-ID: <200906291903.n5TJ3Elw010037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbZF2TD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2
has been added to the -mm tree.  Its filename is
     memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch

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
Subject: memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Fix an incorrect condition in memcg lru manipulation

The PageAcctLRU bit itself does not mean a lot without checking
if the mem cgroup is the same as the root cgroup. This patch
fixes a left over from the previous versions.

Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2
+++ a/mm/memcontrol.c
@@ -414,7 +414,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	 */
 	smp_rmb();
 	/* unused or root page is not rotated. */
-	if (!PageCgroupUsed(pc) || PageCgroupAcctLRU(pc))
+	if (!PageCgroupUsed(pc) || mem_cgroup_is_root(pc->mem_cgroup))
 		return;
 	mz = page_cgroup_zoneinfo(pc);
 	list_move(&pc->lru, &mz->lists[lru]);
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch

