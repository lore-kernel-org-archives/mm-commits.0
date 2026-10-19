Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFE259A1E3;
	Mon, 19 Oct 2026 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792420802; cv=none; b=UDGWjJezULEbbACyHkVCrRA5cgoB9yKt+dCMh/JTnYx34hJmHuqvL6J41eiN+pQ4kwSzqp6cbWa80V9JqD75hhQ4LVsmaLPZI6aIbxbc8iznMJpTRq0BmhgZdkLsy0KPaM1+VzHYQtiyNR8s+ntxzqOZg189du5yKO4BCuhLyC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792420802; c=relaxed/simple;
	bh=9V9W5zLdiWZ+/C/yEHrFZTaGkFxhmePgMpLSZU+Nx70=;
	h=Date:To:From:Subject:Message-Id; b=EyTB9D6koBrcWFT8D9QrNJ7R8EHyzUqDMm+NtOqb76KJ1FSIFquJzkuNcCq0FRUs9jkC2Fu3iqPmD3NqV0ZdQXb+HUsRvRT2kQigXUzoiy67xvHkhLloUSj3zaalW/sUsbmWqSbfZMt977PSR+VoLqM5U/22/onpMonW3gEGu/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hz1vRisR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hz1vRisR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EB71F000C4;
	Mon, 19 Oct 2026 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792420800;
	bh=mprBfcaXv9n1BViXbbOtwowuL9EJTeANwpE24qB0TAI=;
	h=Date:To:From:Subject;
	b=hz1vRisRJmjaCC4qGlRdPF2//whTH3n14tvOwS0K38AUot4it/aRxJMv5INFRsKmn
	 CGiX0n7OWR1n4XR/oO4kUvCmIrtH1ED6ggCZxjgkCC7tcyxggrSCybQwQlSeTAckvI
	 Z5W9qr0251xQvMN6brJbDf8R7siJefihM0KGc0ZY=
Date: Mon, 19 Oct 2026 07:39:59 -0700
To: mm-commits@vger.kernel.org,tao.ma@oracle.com,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-pin-refcount-trees-before-dropping-the-lookup-lock.patch added to mm-nonmm-unstable branch
Message-Id: <20261019144000.47EB71F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: Pin refcount trees before dropping the lookup lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-pin-refcount-trees-before-dropping-the-lookup-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-pin-refcount-trees-before-dropping-the-lookup-lock.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: Pin refcount trees before dropping the lookup lock
Date: Wed, 14 Oct 2026 11:47:15 +0800

A refcount tree returned to ocfs2_lock_refcount_tree() must stay alive
until that caller releases its operation reference. However,
ocfs2_get_refcount_tree() returns the cached pointer after dropping
osb_lock, and the caller only takes its kref afterwards. The registry
reference does not protect this gap from concurrent removal.

This can happen when another node frees a refcount root and reuses its
block with a different generation while this mount retains the old
cached tree. Two local operations on different inodes sharing the new
root, such as data CoW and an external xattr update, can then look up
the same stale tree. Their inode locks are independent, and both the
REFCOUNT DLM lock and rf_sem are acquired after the first operation
reference.

The following ordering is possible, with no other operation references:

  Data CoW                         Xattr update
  --------                         ------------
  Look up the old tree under
    osb_lock, then drop osb_lock
                                   Look up the same tree and take a kref
                                   Acquire the tree locks and read the
                                     new on-disk generation
                                   Erase the old tree under osb_lock
                                   Unlock and drop the operation kref
                                   Drop the registry kref, freeing tree
  Take a kref through the
    freed tree pointer

The final kref_get() accesses freed rf_getcnt storage, and subsequent
accesses in ocfs2_lock_refcount_tree() also use the freed allocation.

Take the operation reference in ocfs2_get_refcount_tree() before
releasing osb_lock, including when an insertion loses to another lookup.
Removal must acquire the same lock, so it cannot drop the registry
reference before the lookup has pinned the tree. Keep the existing
unlock and error path puts. The two callers that already hold the
refcount tree lock keep their borrowed lookup behavior and do not
acquire an extra reference.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in ocfs2_lock_refcount_tree+0x94a/0x9b0
    Read of size 4 at addr ffff888117212820 by task python3/497

[Kernel and hardware identification omitted.]

    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? ocfs2_lock_refcount_tree+0x94a/0x9b0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? ocfs2_lock_refcount_tree+0x94a/0x9b0
     kasan_report+0xe0/0x110
     ? ocfs2_lock_refcount_tree+0x94a/0x9b0
     ocfs2_lock_refcount_tree+0x94a/0x9b0
     ? __pfx_ocfs2_lock_refcount_tree+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? ocfs2_refcount_cow+0x3b6/0xd90
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kmalloc_cache_noprof+0x28d/0x610
     ? ocfs2_refcount_cow+0x3b6/0xd90
     ocfs2_refcount_cow+0x410/0xd90
     ? __pfx_ocfs2_refcount_cow+0x10/0x10
     ? __pfx___might_resched+0x10/0x10
     ? down_write+0x11a/0x1f0
     ? __pfx_down_write+0x10/0x10
     ? ocfs2_inode_unlock+0x1a9/0x260
     ? __pfx_ocfs2_inode_unlock+0x10/0x10
     ? ocfs2_file_write_iter+0x1413/0x1d30
     ocfs2_file_write_iter+0x157b/0x1d30
     ? __pfx_ocfs2_file_write_iter+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? __x64_sys_pwrite64+0x1b7/0x220
     ? __pfx___might_resched+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? security_file_permission+0x26/0x80
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_is_held_type+0x8f/0x100
     vfs_write+0x639/0x1010
     ? __pfx_ocfs2_file_write_iter+0x10/0x10
     ? lock_vma_under_rcu+0x154/0x4a0
     ? __pfx_vfs_write+0x10/0x10
     ? lock_release+0x121/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     __x64_sys_pwrite64+0x1b7/0x220
     ? __pfx___x64_sys_pwrite64+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on_prepare+0x11d/0x150
     ? srso_alias_return_thunk+0x5/0xfbef5
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

[Register dump omitted.]

     </TASK>

    Allocated by task 491:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     ocfs2_allocate_refcount_tree+0x49/0x1a0
     ocfs2_create_refcount_tree+0x5d7/0x1630
     ocfs2_attach_refcount_tree+0x57d/0x1100
     __ocfs2_reflink.isra.0+0x1c4/0x1940
     ocfs2_reflink+0x501/0x9b0
     ocfs2_reflink_ioctl+0x6b2/0x920
     ocfs2_ioctl+0x538/0x640
     __x64_sys_ioctl+0x163/0x1d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 498:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     ocfs2_lock_refcount_tree+0x672/0x9b0
     ocfs2_xattr_set+0x72c/0x2530
     ocfs2_xattr_user_set+0xaf/0xf0
     __vfs_setxattr+0x143/0x1b0
     __vfs_setxattr_noperm+0x112/0x5b0
     __vfs_setxattr_locked+0xfe/0x2b0
     vfs_setxattr+0x13c/0x370
     do_setxattr+0x128/0x170
     filename_setxattr+0x147/0x190
     path_setxattrat+0x1ac/0x260
     __x64_sys_setxattr+0xcb/0x140
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff888117212800
     which belongs to the cache kmalloc-1k of size 1024
    The buggy address is located 32 bytes inside of
     freed 1024-byte region [ffff888117212800, ffff888117212c00)

[Page and memory dumps omitted.]

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0037-v4-9f1a261dfbc341721689@gmail.com
Fixes: 374a263e790c ("ocfs2: Add refcount tree lock mechanism.")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Tao Ma <tao.ma@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/refcounttree.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-pin-refcount-trees-before-dropping-the-lookup-lock
+++ a/fs/ocfs2/refcounttree.c
@@ -375,8 +375,10 @@ ocfs2_allocate_refcount_tree(struct ocfs
 	return new;
 }
 
+/* Callers without the refcount tree lock must request a reference. */
 static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
-				   struct ocfs2_refcount_tree **ret_tree)
+				   struct ocfs2_refcount_tree **ret_tree,
+				   bool get_ref)
 {
 	int ret = 0;
 	struct ocfs2_refcount_tree *tree, *new = NULL;
@@ -433,6 +435,8 @@ static int ocfs2_get_refcount_tree(struc
 	new = NULL;
 
 out:
+	if (get_ref)
+		ocfs2_refcount_tree_get(tree);
 	*ret_tree = tree;
 
 	osb->osb_ref_tree_lru = tree;
@@ -506,14 +510,12 @@ int ocfs2_lock_refcount_tree(struct ocfs
 	struct ocfs2_refcount_block *rb;
 
 again:
-	ret = ocfs2_get_refcount_tree(osb, ref_blkno, &tree);
+	ret = ocfs2_get_refcount_tree(osb, ref_blkno, &tree, true);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
 	}
 
-	ocfs2_refcount_tree_get(tree);
-
 	ret = __ocfs2_lock_refcount_tree(osb, tree, rw);
 	if (ret) {
 		mlog_errno(ret);
@@ -2355,7 +2357,8 @@ int ocfs2_decrease_refcount(struct inode
 		goto out;
 	}
 
-	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb), ref_blkno, &tree);
+	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb), ref_blkno,
+				      &tree, false);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2590,7 +2593,7 @@ int ocfs2_prepare_refcount_change_for_de
 	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
-				      refcount_loc, &tree);
+				      refcount_loc, &tree, false);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing.patch
ocfs2-initialize-status-waiters-before-publishing-them.patch
ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch
ocfs2-dlm-hold-a-lock-reference-across-grant-ast-enqueue.patch
ocfs2-cancel-quota-sync-work-before-freeing-quota-info.patch
ocfs2-pin-refcount-trees-before-dropping-the-lookup-lock.patch

