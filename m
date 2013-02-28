From: akpm@linux-foundation.org
Subject: [merged] nfs-idr_destroy-no-longer-needs-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:49 -0800
Message-ID: <20130228201250.1BE3531C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:48440 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab3B1UMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:51 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so245151yen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs: idr_destroy() no longer needs idr_remove_all()
has been removed from the -mm tree.  Its filename was
     nfs-idr_destroy-no-longer-needs-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: nfs: idr_destroy() no longer needs idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop reference to idr_remove_all().  Note that the code
wasn't completely correct before because idr_remove() on all entries
doesn't necessarily release all idr_layers which could lead to memory
leak.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/nfs/client.c~nfs-idr_destroy-no-longer-needs-idr_remove_all fs/nfs/client.c
--- a/fs/nfs/client.c~nfs-idr_destroy-no-longer-needs-idr_remove_all
+++ a/fs/nfs/client.c
@@ -197,7 +197,6 @@ error_0:
 EXPORT_SYMBOL_GPL(nfs_alloc_client);
 
 #if IS_ENABLED(CONFIG_NFS_V4)
-/* idr_remove_all is not needed as all id's are removed by nfs_put_client */
 void nfs_cleanup_cb_ident_idr(struct net *net)
 {
 	struct nfs_net *nn = net_generic(net, nfs_net_id);
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

