From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-lockdep-annotate-root-inode-properly.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:22 -0700
Message-ID: <20120427193522.D0090A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61181 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761022Ab2D0TfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:25 -0400
Received: by wibhj13 with SMTP id hj13so56949wib.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, davej@redhat.com, jwboyer@redhat.com, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: lockdep annotate root inode properly
has been removed from the -mm tree.  Its filename was
     hugetlbfs-lockdep-annotate-root-inode-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlbfs: lockdep annotate root inode properly

This fixes the below reported false lockdep warning.  e096d0c7e2e4
("lockdep: Add helper function for dir vs file i_mutex annotation") added
a similar annotation for every other inode in hugetlbfs but missed the
root inode because it was allocated by a separate function.

For HugeTLB fs we allow taking i_mutex in mmap.  HugeTLB fs doesn't
support file write and its file read callback is modified in a05b0855fd
("hugetlbfs: avoid taking i_mutex from hugetlbfs_read()") to not take
i_mutex.  Hence for HugeTLB fs with regular files we really don't take
i_mutex with mmap_sem held.

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.4.0-rc1+ #322 Not tainted
 -------------------------------------------------------
 bash/1572 is trying to acquire lock:
  (&mm->mmap_sem){++++++}, at: [<ffffffff810f1618>] might_fault+0x40/0x90

 but task is already holding lock:
  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff81125f88>] vfs_readdir+0x56/0xa8

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&sb->s_type->i_mutex_key#12){+.+.+.}:
        [<ffffffff810a09e5>] lock_acquire+0xd5/0xfa
        [<ffffffff816a2f5e>] __mutex_lock_common+0x48/0x350
        [<ffffffff816a3325>] mutex_lock_nested+0x2a/0x31
        [<ffffffff811fb8e1>] hugetlbfs_file_mmap+0x7d/0x104
        [<ffffffff810f859a>] mmap_region+0x272/0x47d
        [<ffffffff810f8a39>] do_mmap_pgoff+0x294/0x2ee
        [<ffffffff810f8b65>] sys_mmap_pgoff+0xd2/0x10e
        [<ffffffff8103d19e>] sys_mmap+0x1d/0x1f
        [<ffffffff816a5922>] system_call_fastpath+0x16/0x1b

 -> #0 (&mm->mmap_sem){++++++}:
        [<ffffffff810a0256>] __lock_acquire+0xa81/0xd75
        [<ffffffff810a09e5>] lock_acquire+0xd5/0xfa
        [<ffffffff810f1645>] might_fault+0x6d/0x90
        [<ffffffff81125d62>] filldir+0x6a/0xc2
        [<ffffffff81133a83>] dcache_readdir+0x5c/0x222
        [<ffffffff81125fa8>] vfs_readdir+0x76/0xa8
        [<ffffffff811260b6>] sys_getdents+0x79/0xc9
        [<ffffffff816a5922>] system_call_fastpath+0x16/0x1b

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&sb->s_type->i_mutex_key#12);
                                lock(&mm->mmap_sem);
                                lock(&sb->s_type->i_mutex_key#12);
   lock(&mm->mmap_sem);

  *** DEADLOCK ***

 1 lock held by bash/1572:
  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff81125f88>] vfs_readdir+0x56/0xa8

 stack backtrace:
 Pid: 1572, comm: bash Not tainted 3.4.0-rc1+ #322
 Call Trace:
  [<ffffffff81699a3c>] print_circular_bug+0x1f8/0x209
  [<ffffffff810a0256>] __lock_acquire+0xa81/0xd75
  [<ffffffff810f38aa>] ? handle_pte_fault+0x5ff/0x614
  [<ffffffff8109e622>] ? mark_lock+0x2d/0x258
  [<ffffffff810f1618>] ? might_fault+0x40/0x90
  [<ffffffff810a09e5>] lock_acquire+0xd5/0xfa
  [<ffffffff810f1618>] ? might_fault+0x40/0x90
  [<ffffffff816a3249>] ? __mutex_lock_common+0x333/0x350
  [<ffffffff810f1645>] might_fault+0x6d/0x90
  [<ffffffff810f1618>] ? might_fault+0x40/0x90
  [<ffffffff81125d62>] filldir+0x6a/0xc2
  [<ffffffff81133a83>] dcache_readdir+0x5c/0x222
  [<ffffffff81125cf8>] ? sys_ioctl+0x74/0x74
  [<ffffffff81125cf8>] ? sys_ioctl+0x74/0x74
  [<ffffffff81125cf8>] ? sys_ioctl+0x74/0x74
  [<ffffffff81125fa8>] vfs_readdir+0x76/0xa8
  [<ffffffff811260b6>] sys_getdents+0x79/0xc9
  [<ffffffff816a5922>] system_call_fastpath+0x16/0x1b

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-lockdep-annotate-root-inode-properly fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-lockdep-annotate-root-inode-properly
+++ a/fs/hugetlbfs/inode.c
@@ -485,6 +485,7 @@ static struct inode *hugetlbfs_get_root(
 		inode->i_fop = &simple_dir_operations;
 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
 		inc_nlink(inode);
+		lockdep_annotate_inode_mutex_key(inode);
 	}
 	return inode;
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
lib-string_helpersc-make-arrays-static.patch

