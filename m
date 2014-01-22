From: akpm@linux-foundation.org
Subject: [merged] posix_acl-uninlining.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:05 -0800
Message-ID: <52e02615.N2r+PpFr+7QPgign%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, bhalevy@primarydata.com, bhalevy@panasas.com, bfields@fieldses.org, agruen@suse.de, Trond.Myklebust@netapp.com, akpm@linux-foundation.org

Subject: [merged] posix_acl-uninlining.patch removed from -mm tree
To: akpm@linux-foundation.org,Trond.Myklebust@netapp.com,agruen@suse.de,bfields@fieldses.org,bhalevy@panasas.com,bhalevy@primarydata.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:05 -0800


The patch titled
     Subject: posix_acl: uninlining
has been removed from the -mm tree.  Its filename was
     posix_acl-uninlining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: posix_acl: uninlining

Uninline vast tracts of nested inline functions in
include/linux/posix_acl.h.

This reduces the text+data+bss size of x86_64 allyesconfig vmlinux by 8026
bytes.

The patch also regularises the positioning of the EXPORT_SYMBOLs in
posix_acl.c.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Benny Halevy <bhalevy@primarydata.com>
Cc: Benny Halevy <bhalevy@panasas.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/posix_acl.c            |   84 +++++++++++++++++++++++++++++++++---
 include/linux/posix_acl.h |   78 ++-------------------------------
 2 files changed, 85 insertions(+), 77 deletions(-)

diff -puN fs/posix_acl.c~posix_acl-uninlining fs/posix_acl.c
--- a/fs/posix_acl.c~posix_acl-uninlining
+++ a/fs/posix_acl.c
@@ -22,11 +22,80 @@
 
 #include <linux/errno.h>
 
-EXPORT_SYMBOL(posix_acl_init);
-EXPORT_SYMBOL(posix_acl_alloc);
-EXPORT_SYMBOL(posix_acl_valid);
-EXPORT_SYMBOL(posix_acl_equiv_mode);
-EXPORT_SYMBOL(posix_acl_from_mode);
+struct posix_acl **acl_by_type(struct inode *inode, int type)
+{
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		return &inode->i_acl;
+	case ACL_TYPE_DEFAULT:
+		return &inode->i_default_acl;
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL(acl_by_type);
+
+struct posix_acl *get_cached_acl(struct inode *inode, int type)
+{
+	struct posix_acl **p = acl_by_type(inode, type);
+	struct posix_acl *acl = ACCESS_ONCE(*p);
+	if (acl) {
+		spin_lock(&inode->i_lock);
+		acl = *p;
+		if (acl != ACL_NOT_CACHED)
+			acl = posix_acl_dup(acl);
+		spin_unlock(&inode->i_lock);
+	}
+	return acl;
+}
+EXPORT_SYMBOL(get_cached_acl);
+
+struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
+{
+	return rcu_dereference(*acl_by_type(inode, type));
+}
+EXPORT_SYMBOL(get_cached_acl_rcu);
+
+void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl)
+{
+	struct posix_acl **p = acl_by_type(inode, type);
+	struct posix_acl *old;
+	spin_lock(&inode->i_lock);
+	old = *p;
+	rcu_assign_pointer(*p, posix_acl_dup(acl));
+	spin_unlock(&inode->i_lock);
+	if (old != ACL_NOT_CACHED)
+		posix_acl_release(old);
+}
+EXPORT_SYMBOL(set_cached_acl);
+
+void forget_cached_acl(struct inode *inode, int type)
+{
+	struct posix_acl **p = acl_by_type(inode, type);
+	struct posix_acl *old;
+	spin_lock(&inode->i_lock);
+	old = *p;
+	*p = ACL_NOT_CACHED;
+	spin_unlock(&inode->i_lock);
+	if (old != ACL_NOT_CACHED)
+		posix_acl_release(old);
+}
+EXPORT_SYMBOL(forget_cached_acl);
+
+void forget_all_cached_acls(struct inode *inode)
+{
+	struct posix_acl *old_access, *old_default;
+	spin_lock(&inode->i_lock);
+	old_access = inode->i_acl;
+	old_default = inode->i_default_acl;
+	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
+	spin_unlock(&inode->i_lock);
+	if (old_access != ACL_NOT_CACHED)
+		posix_acl_release(old_access);
+	if (old_default != ACL_NOT_CACHED)
+		posix_acl_release(old_default);
+}
+EXPORT_SYMBOL(forget_all_cached_acls);
 
 /*
  * Init a fresh posix_acl
@@ -37,6 +106,7 @@ posix_acl_init(struct posix_acl *acl, in
 	atomic_set(&acl->a_refcount, 1);
 	acl->a_count = count;
 }
+EXPORT_SYMBOL(posix_acl_init);
 
 /*
  * Allocate a new ACL with the specified number of entries.
@@ -51,6 +121,7 @@ posix_acl_alloc(int count, gfp_t flags)
 		posix_acl_init(acl, count);
 	return acl;
 }
+EXPORT_SYMBOL(posix_acl_alloc);
 
 /*
  * Clone an ACL.
@@ -146,6 +217,7 @@ posix_acl_valid(const struct posix_acl *
 		return 0;
 	return -EINVAL;
 }
+EXPORT_SYMBOL(posix_acl_valid);
 
 /*
  * Returns 0 if the acl can be exactly represented in the traditional
@@ -186,6 +258,7 @@ posix_acl_equiv_mode(const struct posix_
                 *mode_p = (*mode_p & ~S_IRWXUGO) | mode;
         return not_equiv;
 }
+EXPORT_SYMBOL(posix_acl_equiv_mode);
 
 /*
  * Create an ACL representing the file mode permission bits of an inode.
@@ -207,6 +280,7 @@ posix_acl_from_mode(umode_t mode, gfp_t
 	acl->a_entries[2].e_perm = (mode & S_IRWXO);
 	return acl;
 }
+EXPORT_SYMBOL(posix_acl_from_mode);
 
 /*
  * Return 0 if current is granted want access to the inode
diff -puN include/linux/posix_acl.h~posix_acl-uninlining include/linux/posix_acl.h
--- a/include/linux/posix_acl.h~posix_acl-uninlining
+++ a/include/linux/posix_acl.h
@@ -94,78 +94,12 @@ extern int posix_acl_chmod(struct posix_
 extern struct posix_acl *get_posix_acl(struct inode *, int);
 extern int set_posix_acl(struct inode *, int, struct posix_acl *);
 
-#ifdef CONFIG_FS_POSIX_ACL
-static inline struct posix_acl **acl_by_type(struct inode *inode, int type)
-{
-	switch (type) {
-	case ACL_TYPE_ACCESS:
-		return &inode->i_acl;
-	case ACL_TYPE_DEFAULT:
-		return &inode->i_default_acl;
-	default:
-		BUG();
-	}
-}
-
-static inline struct posix_acl *get_cached_acl(struct inode *inode, int type)
-{
-	struct posix_acl **p = acl_by_type(inode, type);
-	struct posix_acl *acl = ACCESS_ONCE(*p);
-	if (acl) {
-		spin_lock(&inode->i_lock);
-		acl = *p;
-		if (acl != ACL_NOT_CACHED)
-			acl = posix_acl_dup(acl);
-		spin_unlock(&inode->i_lock);
-	}
-	return acl;
-}
-
-static inline struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
-{
-	return rcu_dereference(*acl_by_type(inode, type));
-}
-
-static inline void set_cached_acl(struct inode *inode,
-				  int type,
-				  struct posix_acl *acl)
-{
-	struct posix_acl **p = acl_by_type(inode, type);
-	struct posix_acl *old;
-	spin_lock(&inode->i_lock);
-	old = *p;
-	rcu_assign_pointer(*p, posix_acl_dup(acl));
-	spin_unlock(&inode->i_lock);
-	if (old != ACL_NOT_CACHED)
-		posix_acl_release(old);
-}
-
-static inline void forget_cached_acl(struct inode *inode, int type)
-{
-	struct posix_acl **p = acl_by_type(inode, type);
-	struct posix_acl *old;
-	spin_lock(&inode->i_lock);
-	old = *p;
-	*p = ACL_NOT_CACHED;
-	spin_unlock(&inode->i_lock);
-	if (old != ACL_NOT_CACHED)
-		posix_acl_release(old);
-}
-
-static inline void forget_all_cached_acls(struct inode *inode)
-{
-	struct posix_acl *old_access, *old_default;
-	spin_lock(&inode->i_lock);
-	old_access = inode->i_acl;
-	old_default = inode->i_default_acl;
-	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
-	spin_unlock(&inode->i_lock);
-	if (old_access != ACL_NOT_CACHED)
-		posix_acl_release(old_access);
-	if (old_default != ACL_NOT_CACHED)
-		posix_acl_release(old_default);
-}
-#endif
+struct posix_acl **acl_by_type(struct inode *inode, int type);
+struct posix_acl *get_cached_acl(struct inode *inode, int type);
+struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type);
+void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl);
+void forget_cached_acl(struct inode *inode, int type);
+void forget_all_cached_acls(struct inode *inode);
 
 static inline void cache_no_acl(struct inode *inode)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
mm.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

