From: akpm@linux-foundation.org
Subject: + ncpfs-fix-sparse-warnings-in-ioctlc.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:25:44 -0800
Message-ID: <200802152125.m1FLPic8024744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760808AbYBOV0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:26:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, VANDROVE@vc.cvut.cz


The patch titled
     ncpfs: fix sparse warnings in ioctl.c
has been added to the -mm tree.  Its filename is
     ncpfs-fix-sparse-warnings-in-ioctlc.patch

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
Subject: ncpfs: fix sparse warnings in ioctl.c
From: Harvey Harrison <harvey.harrison@gmail.com>

In both cases, these inode variables arebeing used to test the
server's root inode against NULL.  Change them to s_inode.
fs/ncpfs/ioctl.c:391:18: warning: symbol 'inode' shadows an earlier one
fs/ncpfs/ioctl.c:264:28: originally declared here
fs/ncpfs/ioctl.c:441:17: warning: symbol 'inode' shadows an earlier one
fs/ncpfs/ioctl.c:264:28: originally declared here

In this case, we are about to return anyway, just reuse result.
fs/ncpfs/ioctl.c:521:8: warning: symbol 'result' shadows an earlier one
fs/ncpfs/ioctl.c:268:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN fs/ncpfs/ioctl.c~ncpfs-fix-sparse-warnings-in-ioctlc fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-fix-sparse-warnings-in-ioctlc
+++ a/fs/ncpfs/ioctl.c
@@ -388,11 +388,11 @@ int ncp_ioctl(struct inode *inode, struc
 				struct dentry* dentry = inode->i_sb->s_root;
 
 				if (dentry) {
-					struct inode* inode = dentry->d_inode;
+					struct inode* s_inode = dentry->d_inode;
 				
-					if (inode) {
-						sr.volNumber = NCP_FINFO(inode)->volNumber;
-						sr.dirEntNum = NCP_FINFO(inode)->dirEntNum;
+					if (s_inode) {
+						sr.volNumber = NCP_FINFO(s_inode)->volNumber;
+						sr.dirEntNum = NCP_FINFO(s_inode)->dirEntNum;
 						sr.namespace = server->name_space[sr.volNumber];
 					} else
 						DPRINTK("ncpfs: s_root->d_inode==NULL\n");
@@ -438,12 +438,12 @@ int ncp_ioctl(struct inode *inode, struc
 			dentry = inode->i_sb->s_root;
 			server->root_setuped = 1;
 			if (dentry) {
-				struct inode* inode = dentry->d_inode;
+				struct inode* s_inode = dentry->d_inode;
 				
 				if (inode) {
-					NCP_FINFO(inode)->volNumber = vnum;
-					NCP_FINFO(inode)->dirEntNum = de;
-					NCP_FINFO(inode)->DosDirNum = dosde;
+					NCP_FINFO(s_inode)->volNumber = vnum;
+					NCP_FINFO(s_inode)->dirEntNum = de;
+					NCP_FINFO(s_inode)->DosDirNum = dosde;
 				} else
 					DPRINTK("ncpfs: s_root->d_inode==NULL\n");
 			} else
@@ -518,7 +518,6 @@ int ncp_ioctl(struct inode *inode, struc
 		}
 		{
 			struct ncp_lock_ioctl	 rqdata;
-			int result;
 
 			if (copy_from_user(&rqdata, argp, sizeof(rqdata)))
 				return -EFAULT;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
