From: akpm@linux-foundation.org
Subject: - fs-nfs-nfs4procc-make-nfs4_map_errors-static.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:07 -0800
Message-ID: <200901050641.n056f7Nh005141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbZAEGl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangcong@zeuux.org, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     fs/nfs/nfs4proc.c: make nfs4_map_errors() static
has been removed from the -mm tree.  Its filename was
     fs-nfs-nfs4procc-make-nfs4_map_errors-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/nfs/nfs4proc.c: make nfs4_map_errors() static
From: WANG Cong <wangcong@zeuux.org>

nfs4_map_errors() can become static.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4_fs.h  |    1 -
 fs/nfs/nfs4proc.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/nfs/nfs4_fs.h~fs-nfs-nfs4procc-make-nfs4_map_errors-static fs/nfs/nfs4_fs.h
--- a/fs/nfs/nfs4_fs.h~fs-nfs-nfs4procc-make-nfs4_map_errors-static
+++ a/fs/nfs/nfs4_fs.h
@@ -174,7 +174,6 @@ extern ssize_t nfs4_listxattr(struct den
 
 
 /* nfs4proc.c */
-extern int nfs4_map_errors(int err);
 extern int nfs4_proc_setclientid(struct nfs_client *, u32, unsigned short, struct rpc_cred *);
 extern int nfs4_proc_setclientid_confirm(struct nfs_client *, struct rpc_cred *);
 extern int nfs4_proc_async_renew(struct nfs_client *, struct rpc_cred *);
diff -puN fs/nfs/nfs4proc.c~fs-nfs-nfs4procc-make-nfs4_map_errors-static fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~fs-nfs-nfs4procc-make-nfs4_map_errors-static
+++ a/fs/nfs/nfs4proc.c
@@ -69,7 +69,7 @@ static int _nfs4_proc_lookup(struct inod
 static int _nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle, struct nfs_fattr *fattr);
 
 /* Prevent leaks of NFSv4 errors into userland */
-int nfs4_map_errors(int err)
+static int nfs4_map_errors(int err)
 {
 	if (err < -1000) {
 		dprintk("%s could not handle NFSv4 error %d\n",
_

Patches currently in -mm which might be from wangcong@zeuux.org are

origin.patch
fs-execc-make-do_coredump-void.patch
fs-execc-make-do_coredump-void-checkpatch-fixes.patch
ipc-clean-up-ipc-shmc.patch
ipc-do-not-goto-to-the-next-line.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

