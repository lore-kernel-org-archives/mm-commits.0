From: akpm@linux-foundation.org
Subject: - file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:54:38 -0800
Message-ID: <200703060054.l260shM8006827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43595 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbXCFA4h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:56:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     file capabilities: don't do file caps if MNT_NOSUID
has been removed from the -mm tree.  Its filename was
     file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

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
file-capabilities-honor-secure_noroot.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
integrity-service-api-and-dummy-provider-fix.patch
