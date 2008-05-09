From: akpm@linux-foundation.org
Subject: + memcg-make-global-var-read_mostly.patch added to -mm tree
Date: Fri, 09 May 2008 14:17:21 -0700
Message-ID: <200805092117.m49LHL61026070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602AbYEIVSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com


The patch titled
     memcg: make global var read_mostly
has been added to the -mm tree.  Its filename is
     memcg-make-global-var-read_mostly.patch

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
Subject: memcg: make global var read_mostly
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup_subsys and page_cgroup_cache should be read_mostly and
MEM_CGROUP_RECLAIM_RETRIES can be just a fixed number.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-global-var-read_mostly mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-global-var-read_mostly
+++ a/mm/memcontrol.c
@@ -35,9 +35,9 @@
 
 #include <asm/uaccess.h>
 
-struct cgroup_subsys mem_cgroup_subsys;
-static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
-static struct kmem_cache *page_cgroup_cache;
+struct cgroup_subsys mem_cgroup_subsys __read_mostly;
+static struct kmem_cache *page_cgroup_cache __read_mostly;
+#define MEM_CGROUP_RECLAIM_RETRIES	5
 
 /*
  * Statistics for memory cgroup.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-possible-panic-when-config_mm_owner=y.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
cgroups-fix-documentation.patch
memory-hotplug-memmap_init_zone-called-twice.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch

