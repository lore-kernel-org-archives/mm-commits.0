From: akpm@linux-foundation.org
Subject: [to-be-updated] nfs-idr_destroy-no-longer-needs-idr_remove_all.patch removed from -mm tree
Date: Wed, 06 Feb 2013 14:01:06 -0800
Message-ID: <20130206220106.A9E0D31C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:41618 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3BFWBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:01:07 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so93488ggn.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:01:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs: idr_destroy() no longer needs idr_remove_all()
has been removed from the -mm tree.  Its filename was
     nfs-idr_destroy-no-longer-needs-idr_remove_all.patch

This patch was dropped because an updated version will be merged

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
Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>
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
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch

