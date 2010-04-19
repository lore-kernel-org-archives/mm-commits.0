From: akpm@linux-foundation.org
Subject: + memcg-move-charge-of-file-pages-fix-2.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:51:25 -0700
Message-ID: <201004192251.o3JMpPvc014398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab0DSWwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, randy.dunlap@oracle.com


The patch titled
     memcg-move-charge-of-file-pages-fix-2
has been added to the -mm tree.  Its filename is
     memcg-move-charge-of-file-pages-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-move-charge-of-file-pages-fix-2
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

build fix for !CONFIG_SHMEM case.

  CC      mm/shmem.o
mm/shmem.c: In function 'mem_cgroup_get_shmem_target':
mm/shmem.c:2721: error: implicit declaration of function 'SHMEM_I'
mm/shmem.c:2721: warning: initialization makes pointer from integer without a cast
mm/shmem.c:2726: error: dereferencing pointer to incomplete type
mm/shmem.c:2727: error: implicit declaration of function 'shmem_swp_entry'
mm/shmem.c:2727: warning: assignment makes pointer from integer without a cast
mm/shmem.c:2734: error: implicit declaration of function 'shmem_swp_unmap'
mm/shmem.c:2735: error: dereferencing pointer to incomplete type
make[1]: *** [mm/shmem.o] Error 1

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   99 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 37 deletions(-)

diff -puN mm/shmem.c~memcg-move-charge-of-file-pages-fix-2 mm/shmem.c
--- a/mm/shmem.c~memcg-move-charge-of-file-pages-fix-2
+++ a/mm/shmem.c
@@ -2568,6 +2568,43 @@ out4:
 	return error;
 }
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+/**
+ * mem_cgroup_get_shmem_target - find a page or entry assigned to the shmem file
+ * @inode: the inode to be searched
+ * @pgoff: the offset to be searched
+ * @pagep: the pointer for the found page to be stored
+ * @ent: the pointer for the found swap entry to be stored
+ *
+ * If a page is found, refcount of it is incremented. Callers should handle
+ * these refcount.
+ */
+void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
+					struct page **pagep, swp_entry_t *ent)
+{
+	swp_entry_t entry = { .val = 0 }, *ptr;
+	struct page *page = NULL;
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	if ((pgoff << PAGE_CACHE_SHIFT) >= i_size_read(inode))
+		goto out;
+
+	spin_lock(&info->lock);
+	ptr = shmem_swp_entry(info, pgoff, NULL);
+	if (ptr && ptr->val) {
+		entry.val = ptr->val;
+		page = find_get_page(&swapper_space, entry.val);
+	} else
+		page = find_get_page(inode->i_mapping, pgoff);
+	if (ptr)
+		shmem_swp_unmap(ptr);
+	spin_unlock(&info->lock);
+out:
+	*pagep = page;
+	*ent = entry;
+}
+#endif
+
 #else /* !CONFIG_SHMEM */
 
 /*
@@ -2607,6 +2644,31 @@ int shmem_lock(struct file *file, int lo
 	return 0;
 }
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+/**
+ * mem_cgroup_get_shmem_target - find a page or entry assigned to the shmem file
+ * @inode: the inode to be searched
+ * @pgoff: the offset to be searched
+ * @pagep: the pointer for the found page to be stored
+ * @ent: the pointer for the found swap entry to be stored
+ *
+ * If a page is found, refcount of it is incremented. Callers should handle
+ * these refcount.
+ */
+void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
+					struct page **pagep, swp_entry_t *ent)
+{
+	struct page *page = NULL;
+
+	if ((pgoff << PAGE_CACHE_SHIFT) >= i_size_read(inode))
+		goto out;
+	page = find_get_page(inode->i_mapping, pgoff);
+out:
+	*pagep = page;
+	*ent = (swp_entry_t){ .val = 0 };
+}
+#endif
+
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
 #define shmem_get_inode(sb, mode, dev, flags)	ramfs_get_inode(sb, mode, dev)
@@ -2701,40 +2763,3 @@ int shmem_zero_setup(struct vm_area_stru
 	vma->vm_ops = &shmem_vm_ops;
 	return 0;
 }
-
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-/**
- * mem_cgroup_get_shmem_target - find a page or entry assigned to the shmem file
- * @inode: the inode to be searched
- * @pgoff: the offset to be searched
- * @pagep: the pointer for the found page to be stored
- * @ent: the pointer for the found swap entry to be stored
- *
- * If a page is found, refcount of it is incremented. Callers should handle
- * these refcount.
- */
-void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
-					struct page **pagep, swp_entry_t *ent)
-{
-	swp_entry_t entry = { .val = 0 }, *ptr;
-	struct page *page = NULL;
-	struct shmem_inode_info *info = SHMEM_I(inode);
-
-	if ((pgoff << PAGE_CACHE_SHIFT) >= i_size_read(inode))
-		goto out;
-
-	spin_lock(&info->lock);
-	ptr = shmem_swp_entry(info, pgoff, NULL);
-	if (ptr && ptr->val) {
-		entry.val = ptr->val;
-		page = find_get_page(&swapper_space, entry.val);
-	} else
-		page = find_get_page(inode->i_mapping, pgoff);
-	if (ptr)
-		shmem_swp_unmap(ptr);
-	spin_unlock(&info->lock);
-out:
-	*pagep = page;
-	*ent = entry;
-}
-#endif
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-prepare-migration.patch
memcg-fix-prepare-migration-fix.patch
linux-next.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-clean-up-move-charge.patch
memcg-move-charge-of-file-pages.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch

