From: akpm@linux-foundation.org
Subject: + hugetlb-make-mm-and-fs-code-explicitly-non-modular.patch added
 to -mm tree
Date: Thu, 17 Dec 2015 14:52:38 -0800
Message-ID: <56733cb6.WFLOSOO25EAzldyZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934148AbbLQWwj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 17:52:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, nyc@holomorphy.com, rientjes@google.com, viro@zeniv.linux.org.uk, ying.huang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: make mm and fs code explicitly non-modular
has been added to the -mm tree.  Its filename is
     hugetlb-make-mm-and-fs-code-explicitly-non-modular.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-make-mm-and-fs-code-explicitly-non-modular.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-make-mm-and-fs-code-explicitly-non-modular.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: hugetlb: make mm and fs code explicitly non-modular

The Kconfig currently controlling compilation of this code is:

config HUGETLBFS
        bool "HugeTLB file system support"

...meaning that it currently is not being built as a module by anyone.

Lets remove the modular code that is essentially orphaned, so that when
reading the driver there is no doubt it is builtin-only.

Since module_init translates to device_initcall in the non-modular case,
the init ordering gets moved to earlier levels when we use the more
appropriate initcalls here.

Originally I had the fs part and the mm part as separate commits, just by
happenstance of the nature of how I detected these non-modular use cases. 
But that can possibly introduce regressions if the patch merge ordering
puts the fs part 1st -- as the 0-day testing reported a splat at mount
time.

Investigating with "initcall_debug" showed that the delta was
init_hugetlbfs_fs being called _before_ hugetlb_init instead of after.  So
both the fs change and the mm change are here together.

In addition, it worked before due to luck of link order, since they were
both in the same initcall category.  So we now have the fs part using
fs_initcall, and the mm part using subsys_initcall, which puts it one
bucket earlier.  It now passes the basic sanity test that failed in
earlier 0-day testing.

We delete the MODULE_LICENSE tag and capture that information at the top
of the file alongside author comments, etc.

We don't replace module.h with init.h since the file already has that. 
Also note that MODULE_ALIAS is a no-op for non-modular code.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Reported-by: kernel test robot <ying.huang@linux.intel.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   27 ++-------------------------
 mm/hugetlb.c         |   39 +--------------------------------------
 2 files changed, 3 insertions(+), 63 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-make-mm-and-fs-code-explicitly-non-modular fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-make-mm-and-fs-code-explicitly-non-modular
+++ a/fs/hugetlbfs/inode.c
@@ -4,11 +4,11 @@
  * Nadia Yvette Chambers, 2002
  *
  * Copyright (C) 2002 Linus Torvalds.
+ * License: GPL
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/module.h>
 #include <linux/thread_info.h>
 #include <asm/current.h>
 #include <linux/sched.h>		/* remove ASAP */
@@ -1201,7 +1201,6 @@ static struct file_system_type hugetlbfs
 	.mount		= hugetlbfs_mount,
 	.kill_sb	= kill_litter_super,
 };
-MODULE_ALIAS_FS("hugetlbfs");
 
 static struct vfsmount *hugetlbfs_vfsmount[HUGE_MAX_HSTATE];
 
@@ -1355,26 +1354,4 @@ static int __init init_hugetlbfs_fs(void
  out2:
 	return error;
 }
-
-static void __exit exit_hugetlbfs_fs(void)
-{
-	struct hstate *h;
-	int i;
-
-
-	/*
-	 * Make sure all delayed rcu free inodes are flushed before we
-	 * destroy cache.
-	 */
-	rcu_barrier();
-	kmem_cache_destroy(hugetlbfs_inode_cachep);
-	i = 0;
-	for_each_hstate(h)
-		kern_unmount(hugetlbfs_vfsmount[i++]);
-	unregister_filesystem(&hugetlbfs_fs_type);
-}
-
-module_init(init_hugetlbfs_fs)
-module_exit(exit_hugetlbfs_fs)
-
-MODULE_LICENSE("GPL");
+fs_initcall(init_hugetlbfs_fs)
diff -puN mm/hugetlb.c~hugetlb-make-mm-and-fs-code-explicitly-non-modular mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-make-mm-and-fs-code-explicitly-non-modular
+++ a/mm/hugetlb.c
@@ -4,7 +4,6 @@
  */
 #include <linux/list.h>
 #include <linux/init.h>
-#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/sysctl.h>
@@ -2549,25 +2548,6 @@ static void hugetlb_unregister_node(stru
 	nhs->hugepages_kobj = NULL;
 }
 
-/*
- * hugetlb module exit:  unregister hstate attributes from node devices
- * that have them.
- */
-static void hugetlb_unregister_all_nodes(void)
-{
-	int nid;
-
-	/*
-	 * disable node device registrations.
-	 */
-	register_hugetlbfs_with_node(NULL, NULL);
-
-	/*
-	 * remove hstate attributes from any nodes that have them.
-	 */
-	for (nid = 0; nid < nr_node_ids; nid++)
-		hugetlb_unregister_node(node_devices[nid]);
-}
 
 /*
  * Register hstate attributes for a single node device.
@@ -2632,27 +2612,10 @@ static struct hstate *kobj_to_node_hstat
 	return NULL;
 }
 
-static void hugetlb_unregister_all_nodes(void) { }
-
 static void hugetlb_register_all_nodes(void) { }
 
 #endif
 
-static void __exit hugetlb_exit(void)
-{
-	struct hstate *h;
-
-	hugetlb_unregister_all_nodes();
-
-	for_each_hstate(h) {
-		kobject_put(hstate_kobjs[hstate_index(h)]);
-	}
-
-	kobject_put(hugepages_kobj);
-	kfree(hugetlb_fault_mutex_table);
-}
-module_exit(hugetlb_exit);
