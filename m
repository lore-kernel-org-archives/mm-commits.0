From: akpm@linux-foundation.org
Subject: - nfs-dont-clear-pg_writeback-until-after-weve-processed-unstable-writes.patch removed from -mm tree
Date: Sat, 21 Apr 2007 21:11:52 -0700
Message-ID: <200704220411.l3M4BqQ2019254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbXDVELy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 00:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, mm-commits@vger.kernel.org


The patch titled
     NFS: Don't clear PG_writeback until after we've processed unstable writes
has been removed from the -mm tree.  Its filename was
     nfs-dont-clear-pg_writeback-until-after-weve-processed-unstable-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NFS: Don't clear PG_writeback until after we've processed unstable writes
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Ensure that we don't release the PG_writeback lock until after the page has
either been redirtied, or queued on the nfs_inode 'commit' list.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nfs/write.c~nfs-dont-clear-pg_writeback-until-after-weve-processed-unstable-writes fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-dont-clear-pg_writeback-until-after-weve-processed-unstable-writes
+++ a/fs/nfs/write.c
@@ -920,8 +920,8 @@ out_bad:
 		list_del(&data->pages);
 		nfs_writedata_release(data);
 	}
-	nfs_end_page_writeback(req->wb_page);
 	nfs_redirty_request(req);
+	nfs_end_page_writeback(req->wb_page);
 	nfs_clear_page_writeback(req);
 	return -ENOMEM;
 }
@@ -966,8 +966,8 @@ static int nfs_flush_one(struct inode *i
 	while (!list_empty(head)) {
 		struct nfs_page *req = nfs_list_entry(head->next);
 		nfs_list_remove_request(req);
-		nfs_end_page_writeback(req->wb_page);
 		nfs_redirty_request(req);
+		nfs_end_page_writeback(req->wb_page);
 		nfs_clear_page_writeback(req);
 	}
 	return -ENOMEM;
@@ -1002,8 +1002,8 @@ out_err:
 	while (!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		nfs_list_remove_request(req);
-		nfs_end_page_writeback(req->wb_page);
 		nfs_redirty_request(req);
+		nfs_end_page_writeback(req->wb_page);
 		nfs_clear_page_writeback(req);
 	}
 	return error;
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
