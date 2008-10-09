From: akpm@linux-foundation.org
Subject: - nfs-bug_on-in-nfs_follow_mountpoint.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:33 -0700
Message-ID: <200810092228.m99MSX4J006090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYJIW2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, Trond.Myklebust@netapp.com, bfields@fieldses.org, mm-commits@vger.kernel.org


The patch titled
     nfs: BUG_ON in nfs_follow_mountpoint
has been removed from the -mm tree.  Its filename was
     nfs-bug_on-in-nfs_follow_mountpoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: BUG_ON in nfs_follow_mountpoint
From: "Denis V. Lunev" <den@openvz.org>

Unfortunately, BUG_ON(IS_ROOT(dentry)) can happen inside
nfs_follow_mountpoint with NFS running Fedora 8 using a specific setup.

See https://bugzilla.redhat.com/show_bug.cgi?id=458622

So the situation should be handled on NFS client gracefully.

(Trond: 

  I'm not convinced that ESTALE is the correct error to return to the
  user.  ESTALE has a very precise meaning in the NFS protocol: it tells
  you that access to the object has been revoked.

  That again means either that either the object has been deleted, or it
  is no longer exported by the server to this client.

  In the case referred to by Denis, the source of the bug is a broken
  server, and so I'd expect that EIO is probably more appropriate.)

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/namespace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/nfs/namespace.c~nfs-bug_on-in-nfs_follow_mountpoint fs/nfs/namespace.c
--- a/fs/nfs/namespace.c~nfs-bug_on-in-nfs_follow_mountpoint
+++ a/fs/nfs/namespace.c
@@ -105,7 +105,10 @@ static void * nfs_follow_mountpoint(stru
 
 	dprintk("--> nfs_follow_mountpoint()\n");
 
-	BUG_ON(IS_ROOT(dentry));
+	err = -ESTALE;
+	if (IS_ROOT(dentry))
+		goto out_err;
+
 	dprintk("%s: enter\n", __func__);
 	dput(nd->path.dentry);
 	nd->path.dentry = dget(dentry);
_

Patches currently in -mm which might be from den@openvz.org are

git-nfs.patch
git-net.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

