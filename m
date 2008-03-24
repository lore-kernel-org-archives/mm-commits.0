From: akpm@linux-foundation.org
Subject: + infiniband-use-shorter-list_splice_init-for-brevity.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:31:44 -0700
Message-ID: <200803242231.m2OMVi2c028667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbYCXWcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:32:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     infiniband: use shorter list_splice_init() for brevity
has been added to the -mm tree.  Its filename is
     infiniband-use-shorter-list_splice_init-for-brevity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-ieee1394.patch
lapb-use-the-shorter-list_head-form-for-brevity.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch
git-nfsd.patch
git-sparc64.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
infiniband-use-shorter-list_splice_init-for-brevity.patch

