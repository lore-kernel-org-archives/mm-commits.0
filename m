From: akpm@linux-foundation.org
Subject: + fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
 added to -mm tree
Date: Wed, 26 Feb 2014 15:33:20 -0800
Message-ID: <530e79c0.Rq+44BKp0jKf2RHw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaBZXdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:33:20 -0800


The patch titled
     Subject: fs/befs/linuxvfs.c: add __init to befs_init_inodecache()
has been added to the -mm tree.  Its filename is
     fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch

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
Subject: fs/befs/linuxvfs.c: add __init to befs_init_inodecache()

init_inodecache is only called by __init init_befs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache
+++ a/fs/befs/linuxvfs.c
@@ -39,7 +39,6 @@ static struct dentry *befs_lookup(struct
 static struct inode *befs_iget(struct super_block *, unsigned long);
 static struct inode *befs_alloc_inode(struct super_block *sb);
 static void befs_destroy_inode(struct inode *inode);
-static int befs_init_inodecache(void);
 static void befs_destroy_inodecache(void);
 static void *befs_follow_link(struct dentry *, struct nameidata *);
 static void *befs_fast_follow_link(struct dentry *, struct nameidata *);
@@ -445,7 +444,7 @@ static struct inode *befs_iget(struct su
  *
  * Taken from NFS implementation by Al Viro.
  */
-static int
+static int __init
 befs_init_inodecache(void)
 {
 	befs_inode_cachep = kmem_cache_create("befs_inode_cache",
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

