From: akpm@linux-foundation.org
Subject: + affs-mount-option-to-avoid-filename-truncates.patch added to
 -mm tree
Date: Tue, 11 Mar 2014 11:42:56 -0700
Message-ID: <531f5930.pA32BG5ww1lZKPzE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaCKSm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 14:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + affs-mount-option-to-avoid-filename-truncates.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 11:42:56 -0700


The patch titled
     Subject: affs: add mount option to avoid filename truncates
has been added to the -mm tree.  Its filename is
     affs-mount-option-to-avoid-filename-truncates.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/affs-mount-option-to-avoid-filename-truncates.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/affs-mount-option-to-avoid-filename-truncates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: affs: add mount option to avoid filename truncates

Normal behavior for filenames exceeding specific filesystem limits is to
refuse operation.

AFFS standard name length being only 30 characters against 255 for usual
Linux filesystems, original implementation does filename truncate by
default with a define value AFFS_NO_TRUNCATE which can be enabled but
needs module compilation.

This patch adds 'nofilenametruncate' mount option so that user can easily
activate that feature and avoid a lot of problems (eg overwrite files ...)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/affs.txt |    9 +++++--
 fs/affs/affs.h                     |   20 ++++++----------
 fs/affs/amigaffs.c                 |   23 ++++++++++++-------
 fs/affs/namei.c                    |   32 +++++++++++++++++++--------
 fs/affs/super.c                    |    6 ++++-
 5 files changed, 57 insertions(+), 33 deletions(-)

diff -puN Documentation/filesystems/affs.txt~affs-mount-option-to-avoid-filename-truncates Documentation/filesystems/affs.txt
--- a/Documentation/filesystems/affs.txt~affs-mount-option-to-avoid-filename-truncates
+++ a/Documentation/filesystems/affs.txt
@@ -49,6 +49,10 @@ mode=mode	Sets the mode flags to the giv
 		This is useful since most of the plain AmigaOS files
 		will map to 600.
 
+nofilenametruncate
+		The file system will return an error when filename exceeds
+		standard maximum filename length (30 characters).
+
 reserved=num	Sets the number of reserved blocks at the start of the
 		partition to num. You should never need this option.
 		Default is 2.
@@ -181,9 +185,8 @@ tested, though several hundred MB have b
 this fs. For a most up-to-date list of bugs please consult
 fs/affs/Changes.
 
-Filenames are truncated to 30 characters without warning (this
-can be changed by setting the compile-time option AFFS_NO_TRUNCATE
-in include/linux/amigaffs.h).
+By default, filenames are truncated to 30 characters without warning.
+'nofilenametruncate' mount option can change that behavior.
 
 Case is ignored by the affs in filename matching, but Linux shells
 do care about the case. Example (with /wb being an affs mounted fs):
diff -puN fs/affs/affs.h~affs-mount-option-to-avoid-filename-truncates fs/affs/affs.h
--- a/fs/affs/affs.h~affs-mount-option-to-avoid-filename-truncates
+++ a/fs/affs/affs.h
@@ -5,14 +5,6 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 
-/* AmigaOS allows file names with up to 30 characters length.
- * Names longer than that will be silently truncated. If you
- * want to disallow this, comment out the following #define.
- * Creating filesystem objects with longer names will then
- * result in an error (ENAMETOOLONG).
- */
-/*#define AFFS_NO_TRUNCATE */
-
 /* Ugly macros make the code more pretty. */
 
 #define GET_END_PTR(st,p,sz)		 ((st *)((char *)(p)+((sz)-sizeof(st))))
@@ -28,7 +20,6 @@
 
 #define AFFS_CACHE_SIZE		PAGE_SIZE
 
-#define AFFS_MAX_PREALLOC	32
 #define AFFS_LC_SIZE		(AFFS_CACHE_SIZE/sizeof(u32)/2)
 #define AFFS_AC_SIZE		(AFFS_CACHE_SIZE/sizeof(struct affs_ext_key)/2)
 #define AFFS_AC_MASK		(AFFS_AC_SIZE-1)
@@ -118,6 +109,7 @@ struct affs_sb_info {
 #define SF_OFS		0x0200		/* Old filesystem */
 #define SF_PREFIX	0x0400		/* Buffer for prefix is allocated */
 #define SF_VERBOSE	0x0800		/* Talk about fs when mounting */
+#define SF_NO_TRUNCATE	0x1000		/* Don't truncate filenames */
 
 /* short cut to get to the affs specific sb data */
 static inline struct affs_sb_info *AFFS_SB(struct super_block *sb)
@@ -137,9 +129,13 @@ extern void	affs_fix_checksum(struct sup
 extern void	secs_to_datestamp(time_t secs, struct affs_date *ds);
 extern umode_t	prot_to_mode(u32 prot);
 extern void	mode_to_prot(struct inode *inode);
-extern void	affs_error(struct super_block *sb, const char *function, const char *fmt, ...);
-extern void	affs_warning(struct super_block *sb, const char *function, const char *fmt, ...);
-extern int	affs_check_name(const unsigned char *name, int len);
+extern void	affs_error(struct super_block *sb, const char *function,
+			   const char *fmt, ...);
+extern void	affs_warning(struct super_block *sb, const char *function,
+			     const char *fmt, ...);
+extern bool	affs_nofilenametruncate(const struct dentry *dentry);
+extern int	affs_check_name(const unsigned char *name, int len,
+				bool notruncate);
 extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
 
 /* bitmap. c */
diff -puN fs/affs/amigaffs.c~affs-mount-option-to-avoid-filename-truncates fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~affs-mount-option-to-avoid-filename-truncates
+++ a/fs/affs/amigaffs.c
@@ -471,20 +471,27 @@ affs_warning(struct super_block *sb, con
 		function,ErrorBuffer);
 }
 
+bool
+affs_nofilenametruncate(const struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	return AFFS_SB(inode->i_sb)->s_flags & SF_NO_TRUNCATE;
+
+}
+
 /* Check if the name is valid for a affs object. */
 
 int
-affs_check_name(const unsigned char *name, int len)
+affs_check_name(const unsigned char *name, int len, bool notruncate)
 {
 	int	 i;
 
-	if (len > 30)
-#ifdef AFFS_NO_TRUNCATE
-		return -ENAMETOOLONG;
-#else
-		len = 30;
-#endif
-
+	if (len > 30) {
+		if (notruncate)
+			return -ENAMETOOLONG;
+		else
+			len = 30;
+	}
 	for (i = 0; i < len; i++) {
 		if (name[i] < ' ' || name[i] == ':'
 		    || (name[i] > 0x7e && name[i] < 0xa0))
diff -puN fs/affs/namei.c~affs-mount-option-to-avoid-filename-truncates fs/affs/namei.c
--- a/fs/affs/namei.c~affs-mount-option-to-avoid-filename-truncates
+++ a/fs/affs/namei.c
@@ -60,13 +60,13 @@ affs_get_toupper(struct super_block *sb)
  * Note: the dentry argument is the parent dentry.
  */
 static inline int
-__affs_hash_dentry(struct qstr *qstr, toupper_t toupper)
+__affs_hash_dentry(struct qstr *qstr, toupper_t toupper, bool notruncate)
 {
 	const u8 *name = qstr->name;
 	unsigned long hash;
 	int i;
 
-	i = affs_check_name(qstr->name, qstr->len);
+	i = affs_check_name(qstr->name, qstr->len, notruncate);
 	if (i)
 		return i;
 
@@ -82,16 +82,22 @@ __affs_hash_dentry(struct qstr *qstr, to
 static int
 affs_hash_dentry(const struct dentry *dentry, struct qstr *qstr)
 {
-	return __affs_hash_dentry(qstr, affs_toupper);
+	return __affs_hash_dentry(qstr, affs_toupper,
+				  affs_nofilenametruncate(dentry));
+
 }
+
 static int
 affs_intl_hash_dentry(const struct dentry *dentry, struct qstr *qstr)
 {
-	return __affs_hash_dentry(qstr, affs_intl_toupper);
+	return __affs_hash_dentry(qstr, affs_intl_toupper,
+				  affs_nofilenametruncate(dentry));
+
 }
 
 static inline int __affs_compare_dentry(unsigned int len,
-		const char *str, const struct qstr *name, toupper_t toupper)
+		const char *str, const struct qstr *name, toupper_t toupper,
+		bool notruncate)
 {
 	const u8 *aname = str;
 	const u8 *bname = name->name;
@@ -101,7 +107,7 @@ static inline int __affs_compare_dentry(
 	 * must be valid. 'name' must be validated first.
 	 */
 
-	if (affs_check_name(name->name, name->len))
+	if (affs_check_name(name->name, name->len, notruncate))
 		return 1;
 
 	/*
@@ -126,13 +132,18 @@ static int
 affs_compare_dentry(const struct dentry *parent, const struct dentry *dentry,
 		unsigned int len, const char *str, const struct qstr *name)
 {
-	return __affs_compare_dentry(len, str, name, affs_toupper);
+
+	return __affs_compare_dentry(len, str, name, affs_toupper,
+				     affs_nofilenametruncate(parent));
 }
+
 static int
 affs_intl_compare_dentry(const struct dentry *parent, const struct dentry *dentry,
 		unsigned int len, const char *str, const struct qstr *name)
 {
-	return __affs_compare_dentry(len, str, name, affs_intl_toupper);
+	return __affs_compare_dentry(len, str, name, affs_intl_toupper,
+				     affs_nofilenametruncate(parent));
+
 }
 
 /*
@@ -411,7 +422,10 @@ affs_rename(struct inode *old_dir, struc
 		 (u32)old_dir->i_ino, (int)old_dentry->d_name.len, old_dentry->d_name.name,
 		 (u32)new_dir->i_ino, (int)new_dentry->d_name.len, new_dentry->d_name.name);
 
-	retval = affs_check_name(new_dentry->d_name.name,new_dentry->d_name.len);
+	retval = affs_check_name(new_dentry->d_name.name,
+				 new_dentry->d_name.len,
+				 affs_nofilenametruncate(old_dentry));
+
 	if (retval)
 		return retval;
 
diff -puN fs/affs/super.c~affs-mount-option-to-avoid-filename-truncates fs/affs/super.c
--- a/fs/affs/super.c~affs-mount-option-to-avoid-filename-truncates
+++ a/fs/affs/super.c
@@ -163,7 +163,7 @@ static const struct super_operations aff
 };
 
 enum {
-	Opt_bs, Opt_mode, Opt_mufs, Opt_prefix, Opt_protect,
+	Opt_bs, Opt_mode, Opt_mufs, Opt_notruncate, Opt_prefix, Opt_protect,
 	Opt_reserved, Opt_root, Opt_setgid, Opt_setuid,
 	Opt_verbose, Opt_volume, Opt_ignore, Opt_err,
 };
@@ -172,6 +172,7 @@ static const match_table_t tokens = {
 	{Opt_bs, "bs=%u"},
 	{Opt_mode, "mode=%o"},
 	{Opt_mufs, "mufs"},
+	{Opt_notruncate, "nofilenametruncate"},
 	{Opt_prefix, "prefix=%s"},
 	{Opt_protect, "protect"},
 	{Opt_reserved, "reserved=%u"},
@@ -233,6 +234,9 @@ parse_options(char *options, kuid_t *uid
 		case Opt_mufs:
 			*mount_opts |= SF_MUFS;
 			break;
+		case Opt_notruncate:
+			*mount_opts |= SF_NO_TRUNCATE;
+			break;
 		case Opt_prefix:
 			*prefix = match_strdup(&args[0]);
 			if (!*prefix)
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
fs-isofs-inodec-add-__init-to-init_inodecache.patch
coda-add-__init-to-init_inodecache.patch
hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
affs-mount-option-to-avoid-filename-truncates.patch
fs-bfs-inodec-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

