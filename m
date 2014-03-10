From: akpm@linux-foundation.org
Subject: + coda-add-__init-to-init_inodecache.patch added to -mm tree
Date: Mon, 10 Mar 2014 13:56:20 -0700
Message-ID: <531e26f4.M4ZFrJt3zVBeeuT8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbaCJU4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + coda-add-__init-to-init_inodecache.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:56:20 -0700


The patch titled
     Subject: fs/coda/inode.c: add __init to init_inodecache()
has been added to the -mm tree.  Its filename is
     coda-add-__init-to-init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coda-add-__init-to-init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coda-add-__init-to-init_inodecache.patch

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
Subject: fs/coda/inode.c: add __init to init_inodecache()

init_inodecache is only called by __init init_coda

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/coda_int.h |    2 +-
 fs/coda/inode.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/coda/coda_int.h~coda-add-__init-to-init_inodecache fs/coda/coda_int.h
--- a/fs/coda/coda_int.h~coda-add-__init-to-init_inodecache
+++ a/fs/coda/coda_int.h
@@ -10,7 +10,7 @@ extern int coda_hard;
 extern int coda_fake_statfs;
 
 void coda_destroy_inodecache(void);
-int coda_init_inodecache(void);
+int __init coda_init_inodecache(void);
 int coda_fsync(struct file *coda_file, loff_t start, loff_t end, int datasync);
 void coda_sysctl_init(void);
 void coda_sysctl_clean(void);
diff -puN fs/coda/inode.c~coda-add-__init-to-init_inodecache fs/coda/inode.c
--- a/fs/coda/inode.c~coda-add-__init-to-init_inodecache
+++ a/fs/coda/inode.c
@@ -73,7 +73,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-int coda_init_inodecache(void)
+int __init coda_init_inodecache(void)
 {
 	coda_inode_cachep = kmem_cache_create("coda_inode_cache",
 				sizeof(struct coda_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
coda-add-__init-to-init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
fs-bfs-inodec-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

