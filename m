From: akpm@linux-foundation.org
Subject: + nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch added to -mm tree
Date: Tue, 05 Aug 2008 14:42:50 -0700
Message-ID: <200808052142.m75LgoOx024975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610AbYHEVng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 17:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     nfs: ERR_PTR is expected on failure from nfs_do_clone_mount
has been added to the -mm tree.  Its filename is
     nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: ERR_PTR is expected on failure from nfs_do_clone_mount
From: "Denis V. Lunev" <den@openvz.org>

Replace NULL with ERR_PTR(-EINVAL).

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/namespace.c~nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount fs/nfs/namespace.c
--- a/fs/nfs/namespace.c~nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount
+++ a/fs/nfs/namespace.c
@@ -189,7 +189,7 @@ static struct vfsmount *nfs_do_clone_mou
 					   struct nfs_clone_mount *mountdata)
 {
 #ifdef CONFIG_NFS_V4
-	struct vfsmount *mnt = NULL;
+	struct vfsmount *mnt = ERR_PTR(-EINVAL);
 	switch (server->nfs_client->rpc_ops->version) {
 		case 2:
 		case 3:
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
linux-next.patch
nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch
sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

