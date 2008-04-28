From: akpm@linux-foundation.org
Subject: - ncpfs-fix-sparse-warnings-in-ioctlc.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:09 -0700
Message-ID: <200804282155.m3SLt9pY018080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935058AbYD1VzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, VANDROVE@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     ncpfs: fix sparse warnings in ioctl.c
has been removed from the -mm tree.  Its filename was
     ncpfs-fix-sparse-warnings-in-ioctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN fs/ncpfs/ioctl.c~ncpfs-fix-sparse-warnings-in-ioctlc fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-fix-sparse-warnings-in-ioctlc
+++ a/fs/ncpfs/ioctl.c
@@ -389,11 +389,11 @@ static int __ncp_ioctl(struct inode *ino
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
@@ -439,12 +439,12 @@ static int __ncp_ioctl(struct inode *ino
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
@@ -519,7 +519,6 @@ static int __ncp_ioctl(struct inode *ino
 		}
 		{
 			struct ncp_lock_ioctl	 rqdata;
-			int result;
 
 			if (copy_from_user(&rqdata, argp, sizeof(rqdata)))
 				return -EFAULT;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

