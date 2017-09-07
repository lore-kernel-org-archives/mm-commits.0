From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 07 Sep 2017 11:36:05 -0700
Message-ID: <20170907183605._lHQp20sU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754064AbdIGSgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/cgroup/cgroup.c~linux-next-git-rejects kernel/cgroup/cgroup.c
--- a/kernel/cgroup/cgroup.c~linux-next-git-rejects
+++ a/kernel/cgroup/cgroup.c
@@ -4230,7 +4230,6 @@ static void *cgroup_procs_start(struct s
 static int cgroup_procs_show(struct seq_file *s, void *v)
 {
 	seq_printf(s, "%d\n", task_pid_vnr(v));
-<<<<<<< HEAD
 	return 0;
 }
 
@@ -4271,48 +4270,6 @@ static int cgroup_procs_write_permission
 	return 0;
 }
 
-=======
-	return 0;
-}
-
-static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
-					 struct cgroup *dst_cgrp,
-					 struct super_block *sb)
-{
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
-	struct cgroup *com_cgrp = src_cgrp;
-	struct inode *inode;
-	int ret;
-
-	lockdep_assert_held(&cgroup_mutex);
-
-	/* find the common ancestor */
-	while (!cgroup_is_descendant(dst_cgrp, com_cgrp))
-		com_cgrp = cgroup_parent(com_cgrp);
-
-	/* %current should be authorized to migrate to the common ancestor */
-	inode = kernfs_get_inode(sb, com_cgrp->procs_file.kn);
-	if (!inode)
-		return -ENOMEM;
-
-	ret = inode_permission(inode, MAY_WRITE);
-	iput(inode);
-	if (ret)
-		return ret;
-
-	/*
-	 * If namespaces are delegation boundaries, %current must be able
-	 * to see both source and destination cgroups from its namespace.
-	 */
-	if ((cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE) &&
-	    (!cgroup_is_descendant(src_cgrp, ns->root_cset->dfl_cgrp) ||
-	     !cgroup_is_descendant(dst_cgrp, ns->root_cset->dfl_cgrp)))
-		return -ENOENT;
-
-	return 0;
-}
-
->>>>>>> linux-next/akpm-base
 static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix.patch
mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
zram-mm-vs-block.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

