From: akpm@linux-foundation.org
Subject: + init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch
 added to -mm tree
Date: Wed, 07 Dec 2016 12:47:57 -0800
Message-ID: <5848757d.ZFXA0ORjGHCJCbfi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932808AbcLGUrf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2016 15:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, drzeus-list@drzeus.cx, hch@lst.de, js07.lee@samsung.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: init-reduce-rootwait-polling-interval-time-to-5ms-fix
has been added to the -mm tree.  Its filename is
     init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

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
Subject: init-reduce-rootwait-polling-interval-time-to-5ms-fix

remove used-once #define

Cc: Jungseung Lee <js07.lee@samsung.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN init/do_mounts.c~init-reduce-rootwait-polling-interval-time-to-5ms-fix init/do_mounts.c
--- a/init/do_mounts.c~init-reduce-rootwait-polling-interval-time-to-5ms-fix
+++ a/init/do_mounts.c
@@ -543,8 +543,6 @@ void __init mount_root(void)
 #endif
 }
 
-#define ROOTWAIT_MSEC 5
-
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
  */
@@ -590,7 +588,7 @@ void __init prepare_namespace(void)
 			saved_root_name);
 		while (driver_probe_done() != 0 ||
 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
-			msleep(ROOTWAIT_MSEC);
+			msleep(5);
 		async_synchronize_full();
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
drivers-clk-uniphier-clk-uniphierh-fix-build-with-old-gcc.patch
drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

