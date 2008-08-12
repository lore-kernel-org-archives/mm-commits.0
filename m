From: akpm@linux-foundation.org
Subject: + nfs-bug_on-in-nfs_follow_mountpoint.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:22:17 -0700
Message-ID: <200808120022.m7C0MHXX029981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbYHLAWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, Trond.Myklebust@netapp.com, bfields@fieldses.org


The patch titled
     nfs: BUG_ON in nfs_follow_mountpoint
has been added to the -mm tree.  Its filename is
     nfs-bug_on-in-nfs_follow_mountpoint.patch

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
Subject: nfs: BUG_ON in nfs_follow_mountpoint
From: "Denis V. Lunev" <den@openvz.org>

Unfortunately, BUG_ON(IS_ROOT(dentry)) can happen inside
nfs_follow_mountpoint with NFS running Fedora 8 using a specific setup.

See https://bugzilla.redhat.com/show_bug.cgi?id=458622

So the situation should be handled on NFS client gracefully.

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

nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch
sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
nfs-bug_on-in-nfs_follow_mountpoint.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

