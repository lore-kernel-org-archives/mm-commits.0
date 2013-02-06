From: akpm@linux-foundation.org
Subject: [to-be-updated] cgroup-dont-use-idr_remove_all.patch removed from -mm tree
Date: Wed, 06 Feb 2013 14:01:12 -0800
Message-ID: <20130206220112.A677531C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52213 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab3BFWBN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:01:13 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so93287yhr.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:01:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, lizefan@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     cgroup-dont-use-idr_remove_all.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cgroup: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/cgroup.c~cgroup-dont-use-idr_remove_all kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-dont-use-idr_remove_all
+++ a/kernel/cgroup.c
@@ -4582,10 +4582,8 @@ void cgroup_unload_subsys(struct cgroup_
 	offline_css(ss, dummytop);
 	ss->active = 0;
 
-	if (ss->use_id) {
-		idr_remove_all(&ss->idr);
+	if (ss->use_id)
 		idr_destroy(&ss->idr);
-	}
 
 	/* deassign the subsys_id */
 	subsys[ss->subsys_id] = NULL;
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-deprecate-idr_remove_all.patch

