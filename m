From: akpm@linux-foundation.org
Subject: + affs-add-__init-to-init_inodecache.patch added to -mm tree
Date: Mon, 24 Feb 2014 16:23:29 -0800
Message-ID: <530be281.o2iy3qR8LAxoa4+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBYAXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 19:23:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + affs-add-__init-to-init_inodecache.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 16:23:29 -0800


The patch titled
     Subject: affs: add __init to init_inodecache ()
has been added to the -mm tree.  Its filename is
     affs-add-__init-to-init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/affs-add-__init-to-init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/affs-add-__init-to-init_inodecache.patch

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
Subject: affs: add __init to init_inodecache ()

init_inodecache is only called by __init init_affs_fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/affs/super.c~affs-add-__init-to-init_inodecache fs/affs/super.c
--- a/fs/affs/super.c~affs-add-__init-to-init_inodecache
+++ a/fs/affs/super.c
@@ -128,7 +128,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	affs_inode_cachep = kmem_cache_create("affs_inode_cache",
 					     sizeof(struct affs_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

