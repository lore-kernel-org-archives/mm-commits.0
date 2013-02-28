From: akpm@linux-foundation.org
Subject: [merged] remoteproc-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:41 -0800
Message-ID: <20130228201242.1CAE45A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55077 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab3B1UMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:43 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so244912ggi.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ohad@wizery.com, mm-commits@vger.kernel.org


The patch titled
     Subject: remoteproc: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     remoteproc-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: remoteproc: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/remoteproc/remoteproc_core.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/remoteproc/remoteproc_core.c~remoteproc-dont-use-idr_remove_all drivers/remoteproc/remoteproc_core.c
--- a/drivers/remoteproc/remoteproc_core.c~remoteproc-dont-use-idr_remove_all
+++ a/drivers/remoteproc/remoteproc_core.c
@@ -1180,7 +1180,6 @@ static void rproc_type_release(struct de
 
 	rproc_delete_debug_dir(rproc);
 
-	idr_remove_all(&rproc->notifyids);
 	idr_destroy(&rproc->notifyids);
 
 	if (rproc->index >= 0)
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

