From: akpm@linux-foundation.org
Subject: - introduce-i_sync-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:47:29 -0700
Message-ID: <200710162247.l9GMlTEp021705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754702AbXJPWrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, joern@wohnheim.fh-wedel.de, mm-commits@vger.kernel.org


The patch titled
     make fs/inode.c:wake_up_inode() static
has been removed from the -mm tree.  Its filename was
     introduce-i_sync-fix.patch

This patch was dropped because it was folded into introduce-i_sync.patch

------------------------------------------------------
Subject: make fs/inode.c:wake_up_inode() static
From: Adrian Bunk <bunk@stusta.de>

wake_up_inode() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Joern Engel <joern@wohnheim.fh-wedel.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c                |   18 +++++++++---------
 include/linux/writeback.h |    1 -
 2 files changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/inode.c~introduce-i_sync-fix fs/inode.c
--- a/fs/inode.c~introduce-i_sync-fix
+++ a/fs/inode.c
@@ -99,6 +99,15 @@ struct inodes_stat_t inodes_stat;
 
 static struct kmem_cache * inode_cachep __read_mostly;
 
+static void wake_up_inode(struct inode *inode)
+{
+	/*
+	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 */
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_LOCK);
+}
+
 static struct inode *alloc_inode(struct super_block *sb)
 {
 	static const struct address_space_operations empty_aops;
@@ -1302,15 +1311,6 @@ static void __wait_on_freeing_inode(stru
 	spin_lock(&inode_lock);
 }
 
-void wake_up_inode(struct inode *inode)
-{
-	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
-	 */
-	smp_mb();
-	wake_up_bit(&inode->i_state, __I_LOCK);
-}
-
 /*
  * We rarely want to lock two inodes that do not have a parent/child
  * relationship (such as directory, child inode) simultaneously. The
diff -puN include/linux/writeback.h~introduce-i_sync-fix include/linux/writeback.h
--- a/include/linux/writeback.h~introduce-i_sync-fix
+++ a/include/linux/writeback.h
@@ -70,7 +70,6 @@ struct writeback_control {
  * fs/fs-writeback.c
  */	
 void writeback_inodes(struct writeback_control *wbc);
-void wake_up_inode(struct inode *inode);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
