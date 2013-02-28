From: akpm@linux-foundation.org
Subject: [merged] nfs4client-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:01 -0800
Message-ID: <20130228201601.E0AD331C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:39524 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3B1UQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:02 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246631yhz.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, Trond.Myklebust@netapp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs4client: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     nfs4client-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: nfs4client: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4client.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/nfs/nfs4client.c~nfs4client-convert-to-idr_alloc fs/nfs/nfs4client.c
--- a/fs/nfs/nfs4client.c~nfs4client-convert-to-idr_alloc
+++ a/fs/nfs/nfs4client.c
@@ -29,15 +29,14 @@ static int nfs_get_cb_ident_idr(struct n
 
 	if (clp->rpc_ops->version != 4 || minorversion != 0)
 		return ret;
-retry:
-	if (!idr_pre_get(&nn->cb_ident_idr, GFP_KERNEL))
-		return -ENOMEM;
+	idr_preload(GFP_KERNEL);
 	spin_lock(&nn->nfs_client_lock);
-	ret = idr_get_new(&nn->cb_ident_idr, clp, &clp->cl_cb_ident);
+	ret = idr_alloc(&nn->cb_ident_idr, clp, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		clp->cl_cb_ident = ret;
 	spin_unlock(&nn->nfs_client_lock);
-	if (ret == -EAGAIN)
-		goto retry;
-	return ret;
+	idr_preload_end();
+	return ret < 0 ? ret : 0;
 }
 
 #ifdef CONFIG_NFS_V4_1
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

