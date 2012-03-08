From: akpm@linux-foundation.org
Subject: + hugetlbfs-lockdep-annotate-root-inode-properly.patch added to -mm tree
Date: Thu, 08 Mar 2012 13:05:46 -0800
Message-ID: <20120308210547.13952A06C4@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:59459 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2CHVFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 16:05:48 -0500
Received: by qcsp5 with SMTP id p5so120309qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 13:05:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, davej@redhat.com, jwboyer@redhat.com, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com


The patch titled
     Subject: hugetlbfs: lockdep annotate root inode properly
has been added to the -mm tree.  Its filename is
     hugetlbfs-lockdep-annotate-root-inode-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlbfs: lockdep annotate root inode properly

Fix the below lockdep warning:

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.3.0-rc4+ #190 Not tainted
 -------------------------------------------------------
 shared/1568 is trying to acquire lock:
  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff811efa0f>] hugetlbfs_file_mmap+0x7d/0x108

 but task is already holding lock:
  (&mm->mmap_sem){++++++}, at: [<ffffffff810f5589>] sys_mmap_pgoff+0xd4/0x12f

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&mm->mmap_sem){++++++}:
        [<ffffffff8109fb8f>] lock_acquire+0xd5/0xfa
        [<ffffffff810ee439>] might_fault+0x6d/0x90
        [<ffffffff8111bc12>] filldir+0x6a/0xc2
        [<ffffffff81129942>] dcache_readdir+0x5c/0x222
        [<ffffffff8111be58>] vfs_readdir+0x76/0xac
        [<ffffffff8111bf6a>] sys_getdents+0x79/0xc9
        [<ffffffff816940a2>] system_call_fastpath+0x16/0x1b

 -> #0 (&sb->s_type->i_mutex_key#12){+.+.+.}:
        [<ffffffff8109f40a>] __lock_acquire+0xa6c/0xd60
        [<ffffffff8109fb8f>] lock_acquire+0xd5/0xfa
        [<ffffffff816916be>] __mutex_lock_common+0x48/0x350
        [<ffffffff81691a85>] mutex_lock_nested+0x2a/0x31
        [<ffffffff811efa0f>] hugetlbfs_file_mmap+0x7d/0x108
        [<ffffffff810f4fd0>] mmap_region+0x26f/0x466
        [<ffffffff810f545b>] do_mmap_pgoff+0x294/0x2ee
        [<ffffffff810f55a9>] sys_mmap_pgoff+0xf4/0x12f
        [<ffffffff8103d1f2>] sys_mmap+0x1d/0x1f
        [<ffffffff816940a2>] system_call_fastpath+0x16/0x1b

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&mm->mmap_sem);
                                lock(&sb->s_type->i_mutex_key#12);
                                lock(&mm->mmap_sem);
   lock(&sb->s_type->i_mutex_key#12);

  *** DEADLOCK ***

 1 lock held by shared/1568:
  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810f5589>] sys_mmap_pgoff+0xd4/0x12f

 stack backtrace:
 Pid: 1568, comm: shared Not tainted 3.3.0-rc4+ #190
 Call Trace:
  [<ffffffff81688bf9>] print_circular_bug+0x1f8/0x209
  [<ffffffff8109f40a>] __lock_acquire+0xa6c/0xd60
  [<ffffffff8110e7b6>] ? files_lglock_local_lock_cpu+0x61/0x61
  [<ffffffff811efa0f>] ? hugetlbfs_file_mmap+0x7d/0x108
  [<ffffffff8109fb8f>] lock_acquire+0xd5/0xfa
  [<ffffffff811efa0f>] ? hugetlbfs_file_mmap+0x7d/0x108

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-lockdep-annotate-root-inode-properly fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-lockdep-annotate-root-inode-properly
+++ a/fs/hugetlbfs/inode.c
@@ -466,6 +466,7 @@ static struct inode *hugetlbfs_get_root(
 		inode->i_fop = &simple_dir_operations;
 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
 		inc_nlink(inode);
+		lockdep_annotate_inode_mutex_key(inode);
 	}
 	return inode;
 }
_
Subject: Subject: hugetlbfs: lockdep annotate root inode properly

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch

