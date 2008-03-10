From: akpm@linux-foundation.org
Subject: - cifs-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 10 Mar 2008 11:05:19 -0700
Message-ID: <200803101805.m2AI5Jp9030080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbYCJSLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 14:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     cifs-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifs_dfs_ref.c |   18 +++++++++---------
 fs/cifs/cifsproto.h    |    4 ++--
 fs/cifs/dns_resolve.c  |    8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff -puN fs/cifs/cifs_dfs_ref.c~cifs-replace-remaining-__function__-occurrences fs/cifs/cifs_dfs_ref.c
--- a/fs/cifs/cifs_dfs_ref.c~cifs-replace-remaining-__function__-occurrences
+++ a/fs/cifs/cifs_dfs_ref.c
@@ -74,7 +74,7 @@ static char *cifs_get_share_name(const c
 	pSep = memchr(UNC+2, '\\', len-2);
 	if (!pSep) {
 		cERROR(1, ("%s: no server name end in node name: %s",
-			__FUNCTION__, node_name));
+			__func__, node_name));
 		kfree(UNC);
 		return NULL;
 	}
@@ -84,7 +84,7 @@ static char *cifs_get_share_name(const c
 	pSep = memchr(UNC+(pSep-UNC), '\\', len-(pSep-UNC));
 	if (!pSep) {
 		cERROR(1, ("%s:2 cant find share name in node name: %s",
-			__FUNCTION__, node_name));
+			__func__, node_name));
 		kfree(UNC);
 		return NULL;
 	}
@@ -127,7 +127,7 @@ static char *compose_mount_options(const
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc != 0) {
 		cERROR(1, ("%s: Failed to resolve server part of %s to IP",
-			  __FUNCTION__, *devname));
+			  __func__, *devname));
 		mountdata = ERR_PTR(rc);
 		goto compose_mount_options_out;
 	}
@@ -181,8 +181,8 @@ static char *compose_mount_options(const
 		}
 	}
 
-	/*cFYI(1,("%s: parent mountdata: %s", __FUNCTION__,sb_mountdata));*/
-	/*cFYI(1, ("%s: submount mountdata: %s", __FUNCTION__, mountdata ));*/
+	/*cFYI(1,("%s: parent mountdata: %s", __func__,sb_mountdata));*/
+	/*cFYI(1, ("%s: submount mountdata: %s", __func__, mountdata ));*/
 
 compose_mount_options_out:
 	kfree(srvIP);
@@ -302,7 +302,7 @@ cifs_dfs_follow_mountpoint(struct dentry
 	int rc = 0;
 	struct vfsmount *mnt = ERR_PTR(-ENOENT);
 
-	cFYI(1, ("in %s", __FUNCTION__));
+	cFYI(1, ("in %s", __func__));
 	BUG_ON(IS_ROOT(dentry));
 
 	xid = GetXid();
@@ -336,7 +336,7 @@ cifs_dfs_follow_mountpoint(struct dentry
 			len = strlen(referrals[i].node_name);
 			if (len < 2) {
 				cERROR(1, ("%s: Net Address path too short: %s",
-					__FUNCTION__, referrals[i].node_name));
+					__func__, referrals[i].node_name));
 				rc = -EINVAL;
 				goto out_err;
 			}
@@ -344,7 +344,7 @@ cifs_dfs_follow_mountpoint(struct dentry
 						nd->path.dentry,
 						referrals[i].node_name);
 			cFYI(1, ("%s: cifs_dfs_do_refmount:%s , mnt:%p",
-					 __FUNCTION__,
+					 __func__,
 					referrals[i].node_name, mnt));
 
 			/* complete mount procedure if we accured submount */
@@ -365,7 +365,7 @@ out:
 	FreeXid(xid);
 	free_dfs_info_array(referrals, num_referrals);
 	kfree(full_path);
-	cFYI(1, ("leaving %s" , __FUNCTION__));
+	cFYI(1, ("leaving %s" , __func__));
 	return ERR_PTR(rc);
 out_err:
 	path_put(&nd->path);
diff -puN fs/cifs/cifsproto.h~cifs-replace-remaining-__function__-occurrences fs/cifs/cifsproto.h
--- a/fs/cifs/cifsproto.h~cifs-replace-remaining-__function__-occurrences
+++ a/fs/cifs/cifsproto.h
@@ -39,8 +39,8 @@ extern int smb_send(struct socket *, str
 			unsigned int /* length */ , struct sockaddr *);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
-#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__FUNCTION__, xid,current->fsuid));
-#define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__FUNCTION__,curr_xid,(int)rc));}
+#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__func__, xid,current->fsuid));
+#define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__func__,curr_xid,(int)rc));}
 extern char *build_path_from_dentry(struct dentry *);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
diff -puN fs/cifs/dns_resolve.c~cifs-replace-remaining-__function__-occurrences fs/cifs/dns_resolve.c
--- a/fs/cifs/dns_resolve.c~cifs-replace-remaining-__function__-occurrences
+++ a/fs/cifs/dns_resolve.c
@@ -77,14 +77,14 @@ dns_resolve_server_name_to_ip(const char
 	/* search for server name delimiter */
 	len = strlen(unc);
 	if (len < 3) {
-		cFYI(1, ("%s: unc is too short: %s", __FUNCTION__, unc));
+		cFYI(1, ("%s: unc is too short: %s", __func__, unc));
 		return -EINVAL;
 	}
 	len -= 2;
 	name = memchr(unc+2, '\\', len);
 	if (!name) {
 		cFYI(1, ("%s: probably server name is whole unc: %s",
-					__FUNCTION__, unc));
+					__func__, unc));
 	} else {
 		len = (name - unc) - 2/* leading // */;
 	}
@@ -104,7 +104,7 @@ dns_resolve_server_name_to_ip(const char
 		if (*ip_addr) {
 			memcpy(*ip_addr, rkey->payload.data, len);
 			(*ip_addr)[len] = '\0';
-			cFYI(1, ("%s: resolved: %s to %s", __FUNCTION__,
+			cFYI(1, ("%s: resolved: %s to %s", __func__,
 					rkey->description,
 					*ip_addr
 				));
@@ -114,7 +114,7 @@ dns_resolve_server_name_to_ip(const char
 		}
 		key_put(rkey);
 	} else {
-		cERROR(1, ("%s: unable to resolve: %s", __FUNCTION__, name));
+		cERROR(1, ("%s: unable to resolve: %s", __func__, name));
 	}
 
 	kfree(name);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
acpi-replace-remaining-__function__-occurrences.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-arm-master.patch
git-cifs.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
ata-replace-remaining-__function__-occurrences.patch
pata_amd-fix-sparse-warning.patch
git-md-accel.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

