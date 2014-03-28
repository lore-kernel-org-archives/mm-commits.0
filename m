From: akpm@linux-foundation.org
Subject: + ufs-sb-mutex-merge-mutex_destroy-fix.patch added to -mm tree
Date: Fri, 28 Mar 2014 14:03:03 -0700
Message-ID: <5335e387.2btColeZka2jZRjs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaC1VDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 17:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, dushistov@mail.ru, fabf@skynet.be

Subject: + ufs-sb-mutex-merge-mutex_destroy-fix.patch added to -mm tree
To: fabf@skynet.be,dushistov@mail.ru,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 14:03:03 -0700


The patch titled
     Subject: ufs: sb mutex merge + mutex_destroy: fix
has been added to the -mm tree.  Its filename is
     ufs-sb-mutex-merge-mutex_destroy-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ufs-sb-mutex-merge-mutex_destroy-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ufs-sb-mutex-merge-mutex_destroy-fix.patch

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
Subject: ufs: sb mutex merge + mutex_destroy: fix

mutex_destroy was also called when trying to mount volume in read/write
without write support enabled.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix
+++ a/fs/ufs/super.c
@@ -798,7 +798,7 @@ static int ufs_fill_super(struct super_b
 	if (!(sb->s_flags & MS_RDONLY)) {
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		goto failed;
+		goto failed_noreadwrite;
 	}
 #endif
 	mutex_init(&sbi->mutex);
@@ -1255,10 +1255,12 @@ magic_found:
 	return 0;
 
 failed:
+	mutex_destroy(&sbi->mutex);
+
+failed_noreadwrite:
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
-	mutex_destroy(&sbi->mutex);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-freevxfs-vxfs_lookupc-update-function-comment.patch
ntfs-logging-clean-up.patch
mm-memblockc-use-pfn_phys.patch
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
fs-reiserfs-superc-add-__init-to-init_inodecache.patch
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
ufs-sb-mutex-merge-mutex_destroy-fix.patch

