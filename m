From: akpm@linux-foundation.org
Subject: + memcg-add-mem_cgroup_disabled-fix.patch added to -mm tree
Date: Fri, 14 Nov 2008 20:41:41 -0800
Message-ID: <200811150441.mAF4ffjg014928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbYKOEl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 23:41:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, xemul@openvz.org


The patch titled
     memcg-add-mem_cgroup_disabled-fix
has been added to the -mm tree.  Its filename is
     memcg-add-mem_cgroup_disabled-fix.patch

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
Subject: memcg-add-mem_cgroup_disabled-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A fix for memcg-add-mem_cgroup_disabled-fix.patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-mem_cgroup_disabled-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup_disabled-fix
+++ a/include/linux/memcontrol.h
@@ -19,7 +19,7 @@
 
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
-
+#include <linux/cgroup.h>
 struct mem_cgroup;
 struct page_cgroup;
 struct page;
diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_disabled-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_disabled-fix
+++ a/mm/memcontrol.c
@@ -301,7 +301,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
 
-	if (mem_cgroup_diabled())
+	if (mem_cgroup_disabled())
 		return;
 
 	pc = lookup_page_cgroup(page);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
migration-fix-writepage-error.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-swap-cgroup-for-remembering-usage-fix.patch
memcg-memswap-controller-core.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch

