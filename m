From: akpm@linux-foundation.org
Subject: + minix-remove-no_truncate-code.patch added to -mm tree
Date: Tue, 06 May 2008 11:36:52 -0700
Message-ID: <200805061836.m46IaqkS021251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347AbYEFShF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     minix: remove !NO_TRUNCATE code
has been added to the -mm tree.  Its filename is
     minix-remove-no_truncate-code.patch

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
Subject: minix: remove !NO_TRUNCATE code
From: Adrian Bunk <bunk@kernel.org>

This patch removes the !NO_TRUNCATE code that anyway required a manual
editing of the code for being used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |    3 ---
 fs/minix/minix.h |    6 ------
 fs/minix/namei.c |   24 ------------------------
 3 files changed, 33 deletions(-)

diff -puN fs/minix/inode.c~minix-remove-no_truncate-code fs/minix/inode.c
--- a/fs/minix/inode.c~minix-remove-no_truncate-code
+++ a/fs/minix/inode.c
@@ -256,9 +256,6 @@ static int minix_fill_super(struct super
 	if (!s->s_root)
 		goto out_iput;
 
-	if (!NO_TRUNCATE)
-		s->s_root->d_op = &minix_dentry_operations;
-
 	if (!(s->s_flags & MS_RDONLY)) {
 		if (sbi->s_version != MINIX_V3) /* s_state is now out from V3 sb */
 			ms->s_state &= ~MINIX_VALID_FS;
diff -puN fs/minix/minix.h~minix-remove-no_truncate-code fs/minix/minix.h
--- a/fs/minix/minix.h~minix-remove-no_truncate-code
+++ a/fs/minix/minix.h
@@ -2,11 +2,6 @@
 #include <linux/pagemap.h>
 #include <linux/minix_fs.h>
 
-/*
- * change the define below to 0 if you want names > info->s_namelen chars to be
- * truncated. Else they will be disallowed (ENAMETOOLONG).
- */
-#define NO_TRUNCATE 1
 #define INODE_VERSION(inode)	minix_sb(inode->i_sb)->s_version
 #define MINIX_V1		0x0001		/* original minix fs */
 #define MINIX_V2		0x0002		/* minix V2 fs */
@@ -83,7 +78,6 @@ extern const struct inode_operations min
 extern const struct inode_operations minix_dir_inode_operations;
 extern const struct file_operations minix_file_operations;
 extern const struct file_operations minix_dir_operations;
-extern struct dentry_operations minix_dentry_operations;
 
 static inline struct minix_sb_info *minix_sb(struct super_block *sb)
 {
diff -puN fs/minix/namei.c~minix-remove-no_truncate-code fs/minix/namei.c
--- a/fs/minix/namei.c~minix-remove-no_truncate-code
+++ a/fs/minix/namei.c
@@ -18,30 +18,6 @@ static int add_nondir(struct dentry *den
 	return err;
 }
 
-static int minix_hash(struct dentry *dentry, struct qstr *qstr)
-{
-	unsigned long hash;
-	int i;
-	const unsigned char *name;
-
-	i = minix_sb(dentry->d_inode->i_sb)->s_namelen;
-	if (i >= qstr->len)
-		return 0;
-	/* Truncate the name in place, avoids having to define a compare
-	   function. */
-	qstr->len = i;
-	name = qstr->name;
-	hash = init_name_hash();
-	while (i--)
-		hash = partial_name_hash(*name++, hash);
-	qstr->hash = end_name_hash(hash);
-	return 0;
-}
-
-struct dentry_operations minix_dentry_operations = {
-	.d_hash		= minix_hash,
-};
-
 static struct dentry *minix_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode * inode = NULL;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

