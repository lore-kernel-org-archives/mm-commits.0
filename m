From: akpm@linux-foundation.org
Subject: + posix_acl-uninlining.patch added to -mm tree
Date: Thu, 10 Oct 2013 11:19:05 -0700
Message-ID: <5256ef99.QnDP8espm+GgGTI+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3JJSTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 14:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, bhalevy@primarydata.com, bhalevy@panasas.com, bfields@fieldses.org, agruen@suse.de, Trond.Myklebust@netapp.com, akpm@linux-foundation.org

Subject: + posix_acl-uninlining.patch added to -mm tree
To: akpm@linux-foundation.org,Trond.Myklebust@netapp.com,agruen@suse.de,bfields@fieldses.org,bhalevy@panasas.com,bhalevy@primarydata.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 11:19:05 -0700


The patch titled
     Subject: posix_acl: uninlining
has been added to the -mm tree.  Its filename is
     posix_acl-uninlining.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/posix_acl-uninlining.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/posix_acl-uninlining.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

