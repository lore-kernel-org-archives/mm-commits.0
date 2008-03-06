From: akpm@linux-foundation.org
Subject: - security-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:57 -0800
Message-ID: <200803062223.m26MNvr1020931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756488AbYCFWf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:35:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     security: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     security-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c           |    4 ++--
 security/keys/internal.h       |    8 ++++----
 security/root_plug.c           |    2 +-
 security/security.c            |    8 ++++----
 security/selinux/hooks.c       |   16 ++++++++--------
 security/selinux/netlink.c     |    2 +-
 security/selinux/selinuxfs.c   |    8 ++++----
 security/selinux/ss/services.c |    4 ++--
 8 files changed, 26 insertions(+), 26 deletions(-)

diff -puN security/commoncap.c~security-replace-remaining-__function__-occurences security/commoncap.c
--- a/security/commoncap.c~security-replace-remaining-__function__-occurences
+++ a/security/commoncap.c
@@ -264,7 +264,7 @@ static int get_file_caps(struct linux_bi
 	rc = cap_from_disk(&vcaps, bprm, rc);
 	if (rc)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
-			__FUNCTION__, rc, bprm->filename);
+			__func__, rc, bprm->filename);
 
 out:
 	dput(dentry);
@@ -299,7 +299,7 @@ int cap_bprm_set_security (struct linux_
 	ret = get_file_caps(bprm);
 	if (ret)
 		printk(KERN_NOTICE "%s: get_file_caps returned %d for %s\n",
-			__FUNCTION__, ret, bprm->filename);
+			__func__, ret, bprm->filename);
 
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
diff -puN security/keys/internal.h~security-replace-remaining-__function__-occurences security/keys/internal.h
--- a/security/keys/internal.h~security-replace-remaining-__function__-occurences
+++ a/security/keys/internal.h
@@ -22,16 +22,16 @@ void no_printk(const char *fmt, ...)
 
 #ifdef __KDEBUG
 #define kenter(FMT, ...) \
-	printk(KERN_DEBUG "==> %s("FMT")\n", __FUNCTION__, ##__VA_ARGS__)
+	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
 #define kleave(FMT, ...) \
-	printk(KERN_DEBUG "<== %s()"FMT"\n", __FUNCTION__, ##__VA_ARGS__)
+	printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
 #define kdebug(FMT, ...) \
 	printk(KERN_DEBUG "xxx" FMT"yyy\n", ##__VA_ARGS__)
 #else
 #define kenter(FMT, ...) \
-	no_printk(KERN_DEBUG "==> %s("FMT")\n", __FUNCTION__, ##__VA_ARGS__)
+	no_printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
 #define kleave(FMT, ...) \
-	no_printk(KERN_DEBUG "<== %s()"FMT"\n", __FUNCTION__, ##__VA_ARGS__)
+	no_printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
 #define kdebug(FMT, ...) \
 	no_printk(KERN_DEBUG FMT"\n", ##__VA_ARGS__)
 #endif
diff -puN security/root_plug.c~security-replace-remaining-__function__-occurences security/root_plug.c
--- a/security/root_plug.c~security-replace-remaining-__function__-occurences
+++ a/security/root_plug.c
@@ -49,7 +49,7 @@ module_param(debug, bool, 0600);
 	do {							\
 		if (debug)					\
 			printk(KERN_DEBUG "%s: %s: " fmt ,	\
-				MY_NAME , __FUNCTION__ , 	\
+				MY_NAME , __func__ , 	\
 				## arg);			\
 	} while (0)
 
diff -puN security/security.c~security-replace-remaining-__function__-occurences security/security.c
--- a/security/security.c~security-replace-remaining-__function__-occurences
+++ a/security/security.c
@@ -57,7 +57,7 @@ int __init security_init(void)
 
 	if (verify(&dummy_security_ops)) {
 		printk(KERN_ERR "%s could not verify "
-		       "dummy_security_ops structure.\n", __FUNCTION__);
+		       "dummy_security_ops structure.\n", __func__);
 		return -EIO;
 	}
 
@@ -82,7 +82,7 @@ int register_security(struct security_op
 {
 	if (verify(ops)) {
 		printk(KERN_DEBUG "%s could not verify "
-		       "security_operations structure.\n", __FUNCTION__);
+		       "security_operations structure.\n", __func__);
 		return -EINVAL;
 	}
 
@@ -110,13 +110,13 @@ int mod_reg_security(const char *name, s
 {
 	if (verify(ops)) {
 		printk(KERN_INFO "%s could not verify "
-		       "security operations.\n", __FUNCTION__);
+		       "security operations.\n", __func__);
 		return -EINVAL;
 	}
 
 	if (ops == security_ops) {
 		printk(KERN_INFO "%s security operations "
-		       "already registered.\n", __FUNCTION__);
+		       "already registered.\n", __func__);
 		return -EINVAL;
 	}
 
diff -puN security/selinux/hooks.c~security-replace-remaining-__function__-occurences security/selinux/hooks.c
--- a/security/selinux/hooks.c~security-replace-remaining-__function__-occurences
+++ a/security/selinux/hooks.c
@@ -661,7 +661,7 @@ static int selinux_set_mnt_opts(struct s
 	rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
 	if (rc) {
 		printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
-		       __FUNCTION__, sb->s_type->name, rc);
+		       __func__, sb->s_type->name, rc);
 		goto out;
 	}
 
@@ -1117,7 +1117,7 @@ static int inode_doinit_with_dentry(stru
 		}
 		if (!dentry) {
 			printk(KERN_WARNING "%s:  no dentry for dev=%s "
-			       "ino=%ld\n", __FUNCTION__, inode->i_sb->s_id,
+			       "ino=%ld\n", __func__, inode->i_sb->s_id,
 			       inode->i_ino);
 			goto out_unlock;
 		}
@@ -1155,7 +1155,7 @@ static int inode_doinit_with_dentry(stru
 		if (rc < 0) {
 			if (rc != -ENODATA) {
 				printk(KERN_WARNING "%s:  getxattr returned "
-				       "%d for dev=%s ino=%ld\n", __FUNCTION__,
+				       "%d for dev=%s ino=%ld\n", __func__,
 				       -rc, inode->i_sb->s_id, inode->i_ino);
 				kfree(context);
 				goto out_unlock;
@@ -1169,7 +1169,7 @@ static int inode_doinit_with_dentry(stru
 			if (rc) {
 				printk(KERN_WARNING "%s:  context_to_sid(%s) "
 				       "returned %d for dev=%s ino=%ld\n",
-				       __FUNCTION__, context, -rc,
+				       __func__, context, -rc,
 				       inode->i_sb->s_id, inode->i_ino);
 				kfree(context);
 				/* Leave with the unlabeled SID */
@@ -2419,7 +2419,7 @@ static int selinux_inode_init_security(s
 			printk(KERN_WARNING "%s:  "
 			       "security_transition_sid failed, rc=%d (dev=%s "
 			       "ino=%ld)\n",
-			       __FUNCTION__,
+			       __func__,
 			       -rc, inode->i_sb->s_id, inode->i_ino);
 			return rc;
 		}
@@ -2653,7 +2653,7 @@ static void selinux_inode_post_setxattr(
 	rc = security_context_to_sid(value, size, &newsid);
 	if (rc) {
 		printk(KERN_WARNING "%s:  unable to obtain SID for context "
-		       "%s, rc=%d\n", __FUNCTION__, (char*)value, -rc);
+		       "%s, rc=%d\n", __func__, (char*)value, -rc);
 		return;
 	}
 
@@ -5010,14 +5010,14 @@ static int selinux_register_security (co
 {
 	if (secondary_ops != original_ops) {
 		printk(KERN_ERR "%s:  There is already a secondary security "
-		       "module registered.\n", __FUNCTION__);
+		       "module registered.\n", __func__);
 		return -EINVAL;
  	}
 
 	secondary_ops = ops;
 
 	printk(KERN_INFO "%s:  Registering secondary module %s\n",
-	       __FUNCTION__,
+	       __func__,
 	       name);
 
 	return 0;
diff -puN security/selinux/netlink.c~security-replace-remaining-__function__-occurences security/selinux/netlink.c
--- a/security/selinux/netlink.c~security-replace-remaining-__function__-occurences
+++ a/security/selinux/netlink.c
@@ -89,7 +89,7 @@ out:
 nlmsg_failure:
 	kfree_skb(skb);
 oom:
-	printk(KERN_ERR "SELinux:  OOM in %s\n", __FUNCTION__);
+	printk(KERN_ERR "SELinux:  OOM in %s\n", __func__);
 	goto out;
 }
 
diff -puN security/selinux/selinuxfs.c~security-replace-remaining-__function__-occurences security/selinux/selinuxfs.c
--- a/security/selinux/selinuxfs.c~security-replace-remaining-__function__-occurences
+++ a/security/selinux/selinuxfs.c
@@ -391,7 +391,7 @@ static ssize_t sel_write_context(struct 
 
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
 		printk(KERN_ERR "%s:  context size (%u) exceeds payload "
-		       "max\n", __FUNCTION__, len);
+		       "max\n", __func__, len);
 		length = -ERANGE;
 		goto out;
 	}
@@ -644,7 +644,7 @@ static ssize_t sel_write_create(struct f
 
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
 		printk(KERN_ERR "%s:  context size (%u) exceeds payload "
-		       "max\n", __FUNCTION__, len);
+		       "max\n", __func__, len);
 		length = -ERANGE;
 		goto out3;
 	}
@@ -821,7 +821,7 @@ static ssize_t sel_write_member(struct f
 
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
 		printk(KERN_ERR "%s:  context size (%u) exceeds payload "
-		       "max\n", __FUNCTION__, len);
+		       "max\n", __func__, len);
 		length = -ERANGE;
 		goto out3;
 	}
@@ -1760,7 +1760,7 @@ static int sel_fill_super(struct super_b
 out:
 	return ret;
 err:
-	printk(KERN_ERR "%s:  failed while creating inodes\n", __FUNCTION__);
+	printk(KERN_ERR "%s:  failed while creating inodes\n", __func__);
 	goto out;
 }
 
diff -puN security/selinux/ss/services.c~security-replace-remaining-__function__-occurences security/selinux/ss/services.c
--- a/security/selinux/ss/services.c~security-replace-remaining-__function__-occurences
+++ a/security/selinux/ss/services.c
@@ -414,7 +414,7 @@ static int context_struct_compute_av(str
 	return 0;
 
 inval_class:
-	printk(KERN_ERR "%s:  unrecognized class %d\n", __FUNCTION__, tclass);
+	printk(KERN_ERR "%s:  unrecognized class %d\n", __func__, tclass);
 	return -EINVAL;
 }
 
@@ -2205,7 +2205,7 @@ int security_get_permissions(char *class
 	match = hashtab_search(policydb.p_classes.table, class);
 	if (!match) {
 		printk(KERN_ERR "%s:  unrecognized class %s\n",
-			__FUNCTION__, class);
+			__func__, class);
 		rc = -EINVAL;
 		goto out;
 	}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
acpi-replace-remaining-__function__-occurrences.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-arm-master.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
ata-replace-remaining-__function__-occurrences.patch
pata_amd-fix-sparse-warning.patch
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
git-sh.patch
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
iop-admac-replace-remaining-__function__-occurrences.patch
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

