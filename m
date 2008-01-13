From: akpm@linux-foundation.org
Subject: - nfsv4-give-the-lock-stateid-its-own-sequence-queue.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:27 -0800
Message-ID: <200801131133.m0DBX7D8009817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47371 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbYAMLdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:33:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, mm-commits@vger.kernel.org


The patch titled
     NFSv4: give the lock stateid its own sequence queue
has been removed from the -mm tree.  Its filename was
     nfsv4-give-the-lock-stateid-its-own-sequence-queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NFSv4: give the lock stateid its own sequence queue
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Sharing the open sequence queue causes a deadlock when we try to take both
a lock sequence id and and open sequence id.

This fixes the regression reported by Dimitri Puzin and Jeff Garzik:
See http://bugzilla.kernel.org/show_bug.cgi?id=9712

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4_fs.h   |    1 +
 fs/nfs/nfs4state.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/nfs/nfs4_fs.h~nfsv4-give-the-lock-stateid-its-own-sequence-queue fs/nfs/nfs4_fs.h
--- a/fs/nfs/nfs4_fs.h~nfsv4-give-the-lock-stateid-its-own-sequence-queue
+++ a/fs/nfs/nfs4_fs.h
@@ -115,6 +115,7 @@ struct nfs4_lock_state {
 #define NFS_LOCK_INITIALIZED 1
 	int			ls_flags;
 	struct nfs_seqid_counter	ls_seqid;
+	struct rpc_sequence	ls_sequence;
 	struct nfs_unique_id	ls_id;
 	nfs4_stateid		ls_stateid;
 	atomic_t		ls_count;
diff -puN fs/nfs/nfs4state.c~nfsv4-give-the-lock-stateid-its-own-sequence-queue fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~nfsv4-give-the-lock-stateid-its-own-sequence-queue
+++ a/fs/nfs/nfs4state.c
@@ -509,7 +509,10 @@ static struct nfs4_lock_state *nfs4_allo
 	lsp = kzalloc(sizeof(*lsp), GFP_KERNEL);
 	if (lsp == NULL)
 		return NULL;
-	lsp->ls_seqid.sequence = &state->owner->so_sequence;
+	rpc_init_wait_queue(&lsp->ls_sequence.wait, "lock_seqid_waitqueue");
+	spin_lock_init(&lsp->ls_sequence.lock);
+	INIT_LIST_HEAD(&lsp->ls_sequence.list);
+	lsp->ls_seqid.sequence = &lsp->ls_sequence;
 	atomic_set(&lsp->ls_count, 1);
 	lsp->ls_owner = fl_owner;
 	spin_lock(&clp->cl_lock);
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
git-nfs.patch
