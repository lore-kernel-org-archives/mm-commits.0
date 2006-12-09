From: akpm@osdl.org
Subject: + file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch added to -mm tree
Date: Fri, 08 Dec 2006 21:54:50 -0800
Message-ID: <200612090554.kB95soja017777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47994 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759033AbWLIFze (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 00:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov


The patch titled
     file capabilities: don't do file caps if MNT_NOSUID
has been added to the -mm tree.  Its filename is
     file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file capabilities: don't do file caps if MNT_NOSUID
From: Serge E. Hallyn <serue@us.ibm.com>

A file system mounted NOSUID is likely a removable filesystem.  Allowing
file capabilities from such an fs is an easy attack vector, so don't honor
file capabilities for a NOSUID filesystem.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/commoncap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN security/commoncap.c~file-capabilities-dont-do-file-caps-if-mnt_nosuid security/commoncap.c
--- a/security/commoncap.c~file-capabilities-dont-do-file-caps-if-mnt_nosuid
+++ a/security/commoncap.c
@@ -23,6 +23,7 @@
 #include <linux/ptrace.h>
 #include <linux/xattr.h>
 #include <linux/hugetlb.h>
+#include <linux/mount.h>
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
@@ -152,6 +153,9 @@ static int set_file_caps(struct linux_bi
 	struct inode *inode;
 	int err;
 
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
+		return 0;
+
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
 	if (!inode->i_op || !inode->i_op->getxattr) {
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch

