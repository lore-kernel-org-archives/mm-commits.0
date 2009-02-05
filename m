From: akpm@linux-foundation.org
Subject: + memcg-use-__gfp_nowarn-in-page-cgroup-allocation.patch added to -mm tree
Date: Thu, 05 Feb 2009 12:23:52 -0800
Message-ID: <200902052023.n15KNqQR008249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbZBEU1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 15:27:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, penberg@cs.helsinki.fi


The patch titled
     memcg: use __GFP_NOWARN in page cgroup allocation
has been added to the -mm tree.  Its filename is
     memcg-use-__gfp_nowarn-in-page-cgroup-allocation.patch

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
Subject: memcg: use __GFP_NOWARN in page cgroup allocation
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

page_cgroup's page allocation at init/memory hotplug uses kmalloc() and
vmalloc(). If kmalloc() failes, vmalloc() is used.

This is because vmalloc() is very limited resource on 32bit systems.
We want to use kmalloc() first.

But in this kind of call, __GFP_NOWARN should be specified.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_cgroup.c~memcg-use-__gfp_nowarn-in-page-cgroup-allocation mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-use-__gfp_nowarn-in-page-cgroup-allocation
+++ a/mm/page_cgroup.c
@@ -114,7 +114,8 @@ static int __init_refok init_section_pag
 		nid = page_to_nid(pfn_to_page(pfn));
 		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
 		if (slab_is_available()) {
-			base = kmalloc_node(table_size, GFP_KERNEL, nid);
+			base = kmalloc_node(table_size,
+					GFP_KERNEL | __GFP_NOWARN, nid);
 			if (!base)
 				base = vmalloc_node(table_size, nid);
 		} else {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-use-__gfp_nowarn-in-page-cgroup-allocation.patch
linux-next.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch

