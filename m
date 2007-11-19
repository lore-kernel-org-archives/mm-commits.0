From: akpm@linux-foundation.org
Subject: + embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix.patch added to -mm tree
Date: Mon, 19 Nov 2007 15:44:30 -0800
Message-ID: <200711192344.lAJNiUn7002884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbXKSXpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:45:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bfields@fieldses.org, just.for.lkml@googlemail.com, trond.myklebust@fys.uio.no


The patch titled
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix
has been added to the -mm tree.  Its filename is
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix
From: Jan Blunck <jblunck@suse.de>

I accidently break NFSv4. Here is the original report by Torsten Kaiser:

 > > Breaks nfsv4 in a rather funny way:
 > >
 > > treogen ~ # cd /usr/portage/x
 > > treogen x # touch bla
 > > touch: cannot touch `bla': File exists
 > > treogen x # mkdir bla
 > > treogen x # touch bla/bla
 > > touch: cannot touch `bla/bla': File exists
 > > treogen x # ls -lad *
 > > drwxr-xr-x 2 root root 6 Nov 14 20:03 bla
 > > treogen x # ls -la *
 > > total 0
 > > drwxr-xr-x 2 root root  6 Nov 14 20:03 .
 > > drwxr-xr-x 3 root root 16 Nov 14 20:03 ..
 > > treogen x #

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4proc.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN fs/nfs/nfs4proc.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix
+++ a/fs/nfs/nfs4proc.c
@@ -1375,8 +1375,11 @@ out_close:
 struct dentry *
 nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
+	struct path path = {
+		.mnt = nd->path.mnt,
+		.dentry = dentry,
+	};
 	struct dentry *parent;
-	struct path path = nd->path;
 	struct iattr attr;
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
@@ -1420,7 +1423,10 @@ nfs4_atomic_open(struct inode *dir, stru
 int
 nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct nameidata *nd)
 {
-	struct path path = nd->path;
+	struct path path = {
+		.mnt = nd->path.mnt,
+		.dentry = dentry,
+	};
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
 
@@ -1869,7 +1875,10 @@ static int
 nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
                  int flags, struct nameidata *nd)
 {
-	struct path path = nd->path;
+	struct path path = {
+		.mnt = nd->path.mnt,
+		.dentry = dentry,
+	};
 	struct nfs4_state *state;
 	struct rpc_cred *cred;
 	int status = 0;
_

Patches currently in -mm which might be from jblunck@suse.de are

dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
one-less-parameter-to-__d_path.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
