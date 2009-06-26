From: akpm@linux-foundation.org
Subject: + memcg-add-comments-explaining-memory-barriers.patch added to -mm tree
Date: Fri, 26 Jun 2009 13:04:16 -0700
Message-ID: <200906262004.n5QK4Guk025628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbZFZUEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 16:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: add comments explaining memory barriers
has been added to the -mm tree.  Its filename is
     memcg-add-comments-explaining-memory-barriers.patch

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
Subject: memcg: add comments explaining memory barriers
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add comments for the reason of smp_wmb() in mem_cgroup_commit_charge().

Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/memcontrol.c~memcg-add-comments-explaining-memory-barriers mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-comments-explaining-memory-barriers
+++ a/mm/memcontrol.c
@@ -1134,6 +1134,13 @@ static void __mem_cgroup_commit_charge(s
 	}
 
 	pc->mem_cgroup = mem;
+	/*
+ 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
+ 	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
+ 	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
+ 	 * before USED bit, we need memory barrier here.
+ 	 * See mem_cgroup_add_lru_list(), etc.
+ 	 */
 	smp_wmb();
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_CACHE:
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

elf-limit-max-map-count-to-safe-value.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers.patch

