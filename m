From: akpm@linux-foundation.org
Subject: + ntfs-logging-clean-up.patch added to -mm tree
Date: Fri, 21 Mar 2014 12:41:29 -0700
Message-ID: <532c95e9.rNjYMpr5WLnfL8mM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaCUTla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Mar 2014 15:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, anton@tuxera.com, fabf@skynet.be

Subject: + ntfs-logging-clean-up.patch added to -mm tree
To: fabf@skynet.be,anton@tuxera.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Fri, 21 Mar 2014 12:41:29 -0700


The patch titled
     Subject: ntfs: logging clean-up
has been added to the -mm tree.  Its filename is
     ntfs-logging-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntfs-logging-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntfs-logging-clean-up.patch

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
Subject: ntfs: logging clean-up

- Convert spinlock/static array to va_format (inspired by Joe Perches
  help on previous logging patches).

- Convert printk(KERN_ERR to pr_warn in __ntfs_warning.

- Convert printk(KERN_ERR to pr_err in __ntfs_error.

- Convert printk(KERN_DEBUG to pr_debug in __ntfs_debug.  (Note that
  __ntfs_debug is still guarded by #if DEBUG)

- Improve !DEBUG to parse all arguments (Joe Perches).

- Sparse pr_foo() conversions in super.c

NTFS, NTFS-fs prefixes as well as 'warning' and 'error' were removed :
pr_foo() automatically adds module name and error level is already
specified.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/debug.c |   58 +++++++++++++++++++---------------------------
 fs/ntfs/debug.h |    7 ++++-
 fs/ntfs/super.c |   28 +++++++++-------------
 3 files changed, 42 insertions(+), 51 deletions(-)

diff -puN fs/ntfs/debug.c~ntfs-logging-clean-up fs/ntfs/debug.c
--- a/fs/ntfs/debug.c~ntfs-logging-clean-up
+++ a/fs/ntfs/debug.c
@@ -18,16 +18,9 @@
  * distribution in the file COPYING); if not, write to the Free Software
  * Foundation,Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include "debug.h"
 
-/*
- * A static buffer to hold the error string being displayed and a spinlock
- * to protect concurrent accesses to it.
- */
-static char err_buf[1024];
-static DEFINE_SPINLOCK(err_buf_lock);
-
 /**
  * __ntfs_warning - output a warning to the syslog
  * @function:	name of function outputting the warning
@@ -50,6 +43,7 @@ static DEFINE_SPINLOCK(err_buf_lock);
 void __ntfs_warning(const char *function, const struct super_block *sb,
 		const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 	int flen = 0;
 
@@ -59,17 +53,15 @@ void __ntfs_warning(const char *function
 #endif
 	if (function)
 		flen = strlen(function);
-	spin_lock(&err_buf_lock);
 	va_start(args, fmt);
-	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
-	va_end(args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	if (sb)
-		printk(KERN_ERR "NTFS-fs warning (device %s): %s(): %s\n",
-				sb->s_id, flen ? function : "", err_buf);
+		pr_warn("(device %s): %s(): %pV\n",
+			sb->s_id, flen ? function : "", &vaf);
 	else
-		printk(KERN_ERR "NTFS-fs warning: %s(): %s\n",
-				flen ? function : "", err_buf);
-	spin_unlock(&err_buf_lock);
+		pr_warn("%s(): %pV\n", flen ? function : "", &vaf);
+	va_end(args);
 }
 
 /**
@@ -94,6 +86,7 @@ void __ntfs_warning(const char *function
 void __ntfs_error(const char *function, const struct super_block *sb,
 		const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 	int flen = 0;
 
@@ -103,17 +96,15 @@ void __ntfs_error(const char *function,
 #endif
 	if (function)
 		flen = strlen(function);
-	spin_lock(&err_buf_lock);
 	va_start(args, fmt);
-	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
-	va_end(args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	if (sb)
-		printk(KERN_ERR "NTFS-fs error (device %s): %s(): %s\n",
-				sb->s_id, flen ? function : "", err_buf);
+		pr_err("(device %s): %s(): %pV\n",
+		       sb->s_id, flen ? function : "", &vaf);
 	else
-		printk(KERN_ERR "NTFS-fs error: %s(): %s\n",
-				flen ? function : "", err_buf);
-	spin_unlock(&err_buf_lock);
+		pr_err("%s(): %pV\n", flen ? function : "", &vaf);
+	va_end(args);
 }
 
 #ifdef DEBUG
@@ -124,6 +115,7 @@ int debug_msgs = 0;
 void __ntfs_debug (const char *file, int line, const char *function,
 		const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 	int flen = 0;
 
@@ -131,13 +123,11 @@ void __ntfs_debug (const char *file, int
 		return;
 	if (function)
 		flen = strlen(function);
-	spin_lock(&err_buf_lock);
 	va_start(args, fmt);
-	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_debug("(%s, %d): %s(): %pV", file, line, flen ? function : "", &vaf);
 	va_end(args);
-	printk(KERN_DEBUG "NTFS-fs DEBUG (%s, %d): %s(): %s\n", file, line,
-			flen ? function : "", err_buf);
-	spin_unlock(&err_buf_lock);
 }
 
 /* Dump a runlist. Caller has to provide synchronisation for @rl. */
@@ -149,12 +139,12 @@ void ntfs_debug_dump_runlist(const runli
 
 	if (!debug_msgs)
 		return;
-	printk(KERN_DEBUG "NTFS-fs DEBUG: Dumping runlist (values in hex):\n");
+	pr_debug("Dumping runlist (values in hex):\n");
 	if (!rl) {
-		printk(KERN_DEBUG "Run list not present.\n");
+		pr_debug("Run list not present.\n");
 		return;
 	}
-	printk(KERN_DEBUG "VCN              LCN               Run length\n");
+	pr_debug("VCN              LCN               Run length\n");
 	for (i = 0; ; i++) {
 		LCN lcn = (rl + i)->lcn;
 
@@ -163,13 +153,13 @@ void ntfs_debug_dump_runlist(const runli
 
 			if (index > -LCN_ENOENT - 1)
 				index = 3;
-			printk(KERN_DEBUG "%-16Lx %s %-16Lx%s\n",
+			pr_debug("%-16Lx %s %-16Lx%s\n",
 					(long long)(rl + i)->vcn, lcn_str[index],
 					(long long)(rl + i)->length,
 					(rl + i)->length ? "" :
 						" (runlist end)");
 		} else
-			printk(KERN_DEBUG "%-16Lx %-16Lx  %-16Lx%s\n",
+			pr_debug("%-16Lx %-16Lx  %-16Lx%s\n",
 					(long long)(rl + i)->vcn,
 					(long long)(rl + i)->lcn,
 					(long long)(rl + i)->length,
diff -puN fs/ntfs/debug.h~ntfs-logging-clean-up fs/ntfs/debug.h
--- a/fs/ntfs/debug.h~ntfs-logging-clean-up
+++ a/fs/ntfs/debug.h
@@ -48,7 +48,12 @@ extern void ntfs_debug_dump_runlist(cons
 
 #else	/* !DEBUG */
 
-#define ntfs_debug(f, a...)		do {} while (0)
+#define ntfs_debug(fmt, ...)						\
+do {									\
+	if (0)								\
+		no_printk(fmt, ##__VA_ARGS__);				\
+} while (0)
+
 #define ntfs_debug_dump_runlist(rl)	do {} while (0)
 
 #endif	/* !DEBUG */
diff -puN fs/ntfs/super.c~ntfs-logging-clean-up fs/ntfs/super.c
--- a/fs/ntfs/super.c~ntfs-logging-clean-up
+++ a/fs/ntfs/super.c
@@ -19,6 +19,7 @@
  * distribution in the file COPYING); if not, write to the Free Software
  * Foundation,Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/stddef.h>
 #include <linux/init.h>
@@ -1894,7 +1895,7 @@ get_ctx_vol_failed:
 	vol->minor_ver = vi->minor_ver;
 	ntfs_attr_put_search_ctx(ctx);
 	unmap_mft_record(NTFS_I(vol->vol_ino));
-	printk(KERN_INFO "NTFS volume version %i.%i.\n", vol->major_ver,
+	pr_info("volume version %i.%i.\n", vol->major_ver,
 			vol->minor_ver);
 	if (vol->major_ver < 3 && NVolSparseEnabled(vol)) {
 		ntfs_warning(vol->sb, "Disabling sparse support due to NTFS "
@@ -3093,7 +3094,7 @@ static int __init init_ntfs_fs(void)
 	int err = 0;
 
 	/* This may be ugly but it results in pretty output so who cares. (-8 */
-	printk(KERN_INFO "NTFS driver " NTFS_VERSION " [Flags: R/"
+	pr_info("driver " NTFS_VERSION " [Flags: R/"
 #ifdef NTFS_RW
 			"W"
 #else
@@ -3113,16 +3114,15 @@ static int __init init_ntfs_fs(void)
 			sizeof(ntfs_index_context), 0 /* offset */,
 			SLAB_HWCACHE_ALIGN, NULL /* ctor */);
 	if (!ntfs_index_ctx_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_index_ctx_cache_name);
+		pr_crit("Failed to create %s!\n", ntfs_index_ctx_cache_name);
 		goto ictx_err_out;
 	}
 	ntfs_attr_ctx_cache = kmem_cache_create(ntfs_attr_ctx_cache_name,
 			sizeof(ntfs_attr_search_ctx), 0 /* offset */,
 			SLAB_HWCACHE_ALIGN, NULL /* ctor */);
 	if (!ntfs_attr_ctx_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_attr_ctx_cache_name);
+		pr_crit("NTFS: Failed to create %s!\n",
+			ntfs_attr_ctx_cache_name);
 		goto actx_err_out;
 	}
 
@@ -3130,8 +3130,7 @@ static int __init init_ntfs_fs(void)
 			(NTFS_MAX_NAME_LEN+1) * sizeof(ntfschar), 0,
 			SLAB_HWCACHE_ALIGN, NULL);
 	if (!ntfs_name_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_name_cache_name);
+		pr_crit("Failed to create %s!\n", ntfs_name_cache_name);
 		goto name_err_out;
 	}
 
@@ -3139,8 +3138,7 @@ static int __init init_ntfs_fs(void)
 			sizeof(ntfs_inode), 0,
 			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
 	if (!ntfs_inode_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_inode_cache_name);
+		pr_crit("Failed to create %s!\n", ntfs_inode_cache_name);
 		goto inode_err_out;
 	}
 
@@ -3149,15 +3147,14 @@ static int __init init_ntfs_fs(void)
 			SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
 			ntfs_big_inode_init_once);
 	if (!ntfs_big_inode_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_big_inode_cache_name);
+		pr_crit("Failed to create %s!\n", ntfs_big_inode_cache_name);
 		goto big_inode_err_out;
 	}
 
 	/* Register the ntfs sysctls. */
 	err = ntfs_sysctl(1);
 	if (err) {
-		printk(KERN_CRIT "NTFS: Failed to register NTFS sysctls!\n");
+		pr_crit("Failed to register NTFS sysctls!\n");
 		goto sysctl_err_out;
 	}
 
@@ -3166,7 +3163,7 @@ static int __init init_ntfs_fs(void)
 		ntfs_debug("NTFS driver registered successfully.");
 		return 0; /* Success! */
 	}
-	printk(KERN_CRIT "NTFS: Failed to register NTFS filesystem driver!\n");
+	pr_crit("Failed to register NTFS filesystem driver!\n");
 
 	/* Unregister the ntfs sysctls. */
 	ntfs_sysctl(0);
@@ -3182,8 +3179,7 @@ actx_err_out:
 	kmem_cache_destroy(ntfs_index_ctx_cache);
 ictx_err_out:
 	if (!err) {
-		printk(KERN_CRIT "NTFS: Aborting NTFS filesystem driver "
-				"registration...\n");
+		pr_crit("Aborting NTFS filesystem driver registration...\n");
 		err = -ENOMEM;
 	}
 	return err;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-freevxfs-vxfs_lookupc-update-function-comment.patch
ntfs-logging-clean-up.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
coda-add-__init-to-init_inodecache.patch
hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
affs-mount-option-to-avoid-filename-truncates.patch
fs-bfs-inodec-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch

