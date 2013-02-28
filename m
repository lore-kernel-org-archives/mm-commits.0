From: akpm@linux-foundation.org
Subject: [merged] cgroup-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:53 -0800
Message-ID: <20130228201254.1C3AD31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45443 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab3B1UMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:54 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246252yhz.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, lizefan@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     cgroup-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cgroup: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/cgroup.c~cgroup-dont-use-idr_remove_all kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-dont-use-idr_remove_all
+++ a/kernel/cgroup.c
@@ -4618,10 +4618,8 @@ void cgroup_unload_subsys(struct cgroup_
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

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

