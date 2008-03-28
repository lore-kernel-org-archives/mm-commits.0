From: akpm@linux-foundation.org
Subject: - infiniband-use-shorter-list_splice_init-for-brevity.patch removed from -mm tree
Date: Fri, 28 Mar 2008 14:04:55 -0700
Message-ID: <200803282104.m2SL4t0b009857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754718AbYC1VKB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 17:10:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     infiniband: use shorter list_splice_init() for brevity
has been removed from the -mm tree.  Its filename was
     infiniband-use-shorter-list_splice_init-for-brevity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: infiniband: use shorter list_splice_init() for brevity
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/fmr_pool.c        |    3 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/infiniband/core/fmr_pool.c~infiniband-use-shorter-list_splice_init-for-brevity drivers/infiniband/core/fmr_pool.c
--- a/drivers/infiniband/core/fmr_pool.c~infiniband-use-shorter-list_splice_init-for-brevity
+++ a/drivers/infiniband/core/fmr_pool.c
@@ -158,8 +158,7 @@ static void ib_fmr_batch_release(struct 
 #endif
 	}
 
-	list_splice(&pool->dirty_list, &unmap_list);
-	INIT_LIST_HEAD(&pool->dirty_list);
+	list_splice_init(&pool->dirty_list, &unmap_list);
 	pool->dirty_len = 0;
 
 	spin_unlock_irq(&pool->pool_lock);
diff -puN drivers/infiniband/ulp/ipoib/ipoib_main.c~infiniband-use-shorter-list_splice_init-for-brevity drivers/infiniband/ulp/ipoib/ipoib_main.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c~infiniband-use-shorter-list_splice_init-for-brevity
+++ a/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -359,8 +359,7 @@ void ipoib_flush_paths(struct net_device
 	spin_lock_irq(&priv->tx_lock);
 	spin_lock(&priv->lock);
 
-	list_splice(&priv->path_list, &remove_list);
-	INIT_LIST_HEAD(&priv->path_list);
+	list_splice_init(&priv->path_list, &remove_list);
 
 	list_for_each_entry(path, &remove_list, list)
 		rb_erase(&path->rb_node, &priv->path_tree);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-powerpc.patch
git-ieee1394.patch
git-infiniband.patch
mmc-use-shorter-equivalent-set_current_state.patch
git-net.patch
lapb-use-the-shorter-list_head-form-for-brevity.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
mfd-use-shorter-set_current_state.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch

