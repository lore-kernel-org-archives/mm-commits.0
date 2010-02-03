From: akpm@linux-foundation.org
Subject: [merged] cgroups-fix-to-return-errno-in-a-failure-path.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:55:01 -0800
Message-ID: <201002031755.o13Ht1Ns008944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806Ab0BCR7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:59:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix to return errno in a failure path
has been removed from the -mm tree.  Its filename was
     cgroups-fix-to-return-errno-in-a-failure-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix to return errno in a failure path
From: Li Zefan <lizf@cn.fujitsu.com>

In cgroup_create(), if alloc_css_id() returns failure, the errno is not
propagated to userspace, so mkdir will fail silently.

To trigger this bug, we mount blkio (or memory subsystem), and create more
then 65534 cgroups.  (The number of cgroups is limited to 65535 if a
subsystem has use_id == 1)

 # mount -t cgroup -o blkio xxx /mnt
 # for ((i = 0; i < 65534; i++)); do mkdir /mnt/$i; done
 # mkdir /mnt/65534
 (should return ENOSPC)
 #

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-to-return-errno-in-a-failure-path kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-to-return-errno-in-a-failure-path
+++ a/kernel/cgroup.c
@@ -2936,14 +2936,17 @@ static long cgroup_create(struct cgroup 
 
 	for_each_subsys(root, ss) {
 		struct cgroup_subsys_state *css = ss->create(ss, cgrp);
+
 		if (IS_ERR(css)) {
 			err = PTR_ERR(css);
 			goto err_destroy;
 		}
 		init_cgroup_css(css, ss, cgrp);
-		if (ss->use_id)
-			if (alloc_css_id(ss, parent, cgrp))
+		if (ss->use_id) {
+			err = alloc_css_id(ss, parent, cgrp);
+			if (err)
 				goto err_destroy;
+		}
 		/* At error, ->destroy() callback has to free assigned ID. */
 	}
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
lib-stringc-simplify-strnstr.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch

