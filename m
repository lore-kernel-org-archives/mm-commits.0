From: akpm@linux-foundation.org
Subject: +
 fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch added to -mm tree
Date: Tue, 24 Jun 2014 14:31:36 -0700
Message-ID: <53a9ee38.ek4608oMNoYkH/A+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaFXVbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:31:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs/xattr.c: fix blank line missing after declarations
has been added to the -mm tree.  Its filename is
     fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch

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
Subject: fs/reiserfs/xattr.c: fix blank line missing after declarations

Fix checkpatch warning:

"WARNING: Missing a blank line after declarations"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN fs/reiserfs/xattr.c~fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations
+++ a/fs/reiserfs/xattr.c
@@ -84,6 +84,7 @@ static int xattr_mkdir(struct inode *dir
 static int xattr_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int error;
+
 	BUG_ON(!mutex_is_locked(&dir->i_mutex));
 
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
@@ -98,6 +99,7 @@ static int xattr_unlink(struct inode *di
 static int xattr_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int error;
+
 	BUG_ON(!mutex_is_locked(&dir->i_mutex));
 
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
@@ -117,6 +119,7 @@ static struct dentry *open_xa_root(struc
 {
 	struct dentry *privroot = REISERFS_SB(sb)->priv_root;
 	struct dentry *xaroot;
+
 	if (!privroot->d_inode)
 		return ERR_PTR(-ENODATA);
 
@@ -127,6 +130,7 @@ static struct dentry *open_xa_root(struc
 		xaroot = ERR_PTR(-ENODATA);
 	else if (!xaroot->d_inode) {
 		int err = -ENODATA;
+
 		if (xattr_may_create(flags))
 			err = xattr_mkdir(privroot->d_inode, xaroot, 0700);
 		if (err) {
@@ -157,6 +161,7 @@ static struct dentry *open_xa_dir(const
 	xadir = lookup_one_len(namebuf, xaroot, strlen(namebuf));
 	if (!IS_ERR(xadir) && !xadir->d_inode) {
 		int err = -ENODATA;
+
 		if (xattr_may_create(flags))
 			err = xattr_mkdir(xaroot->d_inode, xadir, 0700);
 		if (err) {
@@ -188,6 +193,7 @@ fill_with_dentries(void *buf, const char
 {
 	struct reiserfs_dentry_buf *dbuf = buf;
 	struct dentry *dentry;
+
 	WARN_ON_ONCE(!mutex_is_locked(&dbuf->xadir->d_inode->i_mutex));
 
 	if (dbuf->count == ARRAY_SIZE(dbuf->dentries))
@@ -218,6 +224,7 @@ static void
 cleanup_dentry_buf(struct reiserfs_dentry_buf *buf)
 {
 	int i;
+
 	for (i = 0; i < buf->count; i++)
 		if (buf->dentries[i])
 			dput(buf->dentries[i]);
@@ -283,11 +290,13 @@ static int reiserfs_for_each_xattr(struc
 		int blocks = JOURNAL_PER_BALANCE_CNT * 2 + 2 +
 			     4 * REISERFS_QUOTA_TRANS_BLOCKS(inode->i_sb);
 		struct reiserfs_transaction_handle th;
+
 		reiserfs_write_lock(inode->i_sb);
 		err = journal_begin(&th, inode->i_sb, blocks);
 		reiserfs_write_unlock(inode->i_sb);
 		if (!err) {
 			int jerror;
+
 			mutex_lock_nested(&dir->d_parent->d_inode->i_mutex,
 					  I_MUTEX_XATTR);
 			err = action(dir, data);
@@ -340,6 +349,7 @@ static int chown_one_xattr(struct dentry
 int reiserfs_delete_xattrs(struct inode *inode)
 {
 	int err = reiserfs_for_each_xattr(inode, delete_one_xattr, NULL);
+
 	if (err)
 		reiserfs_warning(inode->i_sb, "jdm-20004",
 				 "Couldn't delete all xattrs (%d)\n", err);
@@ -350,6 +360,7 @@ int reiserfs_delete_xattrs(struct inode
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs)
 {
 	int err = reiserfs_for_each_xattr(inode, chown_one_xattr, attrs);
+
 	if (err)
 		reiserfs_warning(inode->i_sb, "jdm-20007",
 				 "Couldn't chown all xattrs (%d)\n", err);
@@ -439,6 +450,7 @@ int reiserfs_commit_write(struct file *f
 static void update_ctime(struct inode *inode)
 {
 	struct timespec now = current_fs_time(inode->i_sb);
+
 	if (inode_unhashed(inode) || !inode->i_nlink ||
 	    timespec_equal(&inode->i_ctime, &now))
 		return;
@@ -514,6 +526,7 @@ reiserfs_xattr_set_handle(struct reiserf
 		size_t chunk;
 		size_t skip = 0;
 		size_t page_offset = (file_pos & (PAGE_CACHE_SIZE - 1));
+
 		if (buffer_size - buffer_pos > PAGE_CACHE_SIZE)
 			chunk = PAGE_CACHE_SIZE;
 		else
@@ -530,6 +543,7 @@ reiserfs_xattr_set_handle(struct reiserf
 
 		if (file_pos == 0) {
 			struct reiserfs_xattr_header *rxh;
+
 			skip = file_pos = sizeof(struct reiserfs_xattr_header);
 			if (chunk + skip > PAGE_CACHE_SIZE)
 				chunk = PAGE_CACHE_SIZE - skip;
@@ -659,6 +673,7 @@ reiserfs_xattr_get(struct inode *inode,
 		size_t chunk;
 		char *data;
 		size_t skip = 0;
+
 		if (isize - file_pos > PAGE_CACHE_SIZE)
 			chunk = PAGE_CACHE_SIZE;
 		else
@@ -792,6 +807,7 @@ reiserfs_setxattr(struct dentry *dentry,
 int reiserfs_removexattr(struct dentry *dentry, const char *name)
 {
 	const struct xattr_handler *handler;
+
 	handler = find_xattr_handler_prefix(dentry->d_sb->s_xattr, name);
 
 	if (!handler || get_inode_sd_version(dentry->d_inode) == STAT_DATA_V1)
@@ -813,9 +829,11 @@ static int listxattr_filler(void *buf, c
 {
 	struct listxattr_buf *b = (struct listxattr_buf *)buf;
 	size_t size;
+
 	if (name[0] != '.' ||
 	    (namelen != 1 && (name[1] != '.' || namelen != 2))) {
 		const struct xattr_handler *handler;
+
 		handler = find_xattr_handler_prefix(b->dentry->d_sb->s_xattr,
 						    name);
 		if (!handler)	/* Unsupported xattr name */
@@ -885,6 +903,7 @@ static int create_privroot(struct dentry
 {
 	int err;
 	struct inode *inode = dentry->d_parent->d_inode;
+
 	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
 
 	err = xattr_mkdir(inode, dentry, 0700);
@@ -1015,6 +1034,7 @@ int reiserfs_xattr_init(struct super_blo
 		mutex_lock(&privroot->d_inode->i_mutex);
 		if (!REISERFS_SB(s)->xattr_root) {
 			struct dentry *dentry;
+
 			dentry = lookup_one_len(XAROOT_NAME, privroot,
 						strlen(XAROOT_NAME));
 			if (!IS_ERR(dentry))
_

Patches currently in -mm which might be from fabf@skynet.be are

revert-block-add-__init-to-blkcg_policy_register.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

