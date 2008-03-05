From: akpm@linux-foundation.org
Subject: + cifs-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:20:36 -0800
Message-ID: <200803052220.m25MKakm024022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbYCEWkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:40:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, sfrench@us.ibm.com


The patch titled
     cifs: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     cifs-replace-remaining-__function__-occurrences.patch

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
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
sh-replace-remaining-__function__-occurences.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
ext4-replace-remaining-__function__-occurrences.patch
nfs-replace-remaining-__function__-occurrences.patch
xfs-replace-remaining-__function__-occurrences.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cifs-replace-remaining-__function__-occurrences.patch
reiserfs-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch

