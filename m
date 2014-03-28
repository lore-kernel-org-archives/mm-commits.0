From: akpm@linux-foundation.org
Subject: + ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch added to -mm tree
Date: Fri, 28 Mar 2014 15:43:28 -0700
Message-ID: <5335fb10.9H+YUBWBcFCU4caX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaC1Wn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 18:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jet.chen@intel.com, fengguang.wu@intel.com, dushistov@mail.ru, fabf@skynet.be

Subject: + ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch added to -mm tree
To: fabf@skynet.be,dushistov@mail.ru,fengguang.wu@intel.com,jet.chen@intel.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 15:43:28 -0700


The patch titled
     Subject: ufs-sb-mutex-merge-mutex_destroy-fix-v2
has been added to the -mm tree.  Its filename is
     ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch

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
Subject: ufs-sb-mutex-merge-mutex_destroy-fix-v2

v2: failed_noreadwrite is only used with CONFIG_UFS_FS_WRITE
    -> add ifndef

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Tested-by: "Chen, Jet" <jet.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix-v2 fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix-v2
+++ a/fs/ufs/super.c
@@ -1257,7 +1257,9 @@ magic_found:
 failed:
 	mutex_destroy(&sbi->mutex);
 
+#ifndef CONFIG_UFS_FS_WRITE
 failed_noreadwrite:
+#endif
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
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
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

