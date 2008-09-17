From: akpm@linux-foundation.org
Subject: + sysfs-fix-deadlock.patch added to -mm tree
Date: Wed, 17 Sep 2008 13:37:43 -0700
Message-ID: <200809172037.m8HKbh0a029378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbYIQUij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 16:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, a.p.zijlstra@chello.nl, greg@kroah.com, mingo@elte.hu


The patch titled
     sysfs: fix deadlock
has been added to the -mm tree.  Its filename is
     sysfs-fix-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: fix deadlock
From: Nick Piggin <npiggin@suse.de>

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27-rc6-tip #1
-------------------------------------------------------
X/4873 is trying to acquire lock:
 (&bb->mutex){--..}, at: [<c020ba20>] mmap+0x40/0xa0

but task is already holding lock:
 (&mm->mmap_sem){----}, at: [<c0125a1e>] sys_mmap2+0x8e/0xc0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){----}:
       [<c017dc96>] validate_chain+0xa96/0xf50
       [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
       [<c017f299>] lock_acquire+0x89/0xc0
       [<c01aa8fb>] might_fault+0x6b/0x90
       [<c040b618>] copy_to_user+0x38/0x60
       [<c020bcfb>] read+0xfb/0x170
       [<c01c09a5>] vfs_read+0x95/0x110
       [<c01c1443>] sys_pread64+0x63/0x80
       [<c012146f>] sysenter_do_call+0x12/0x43
       [<ffffffff>] 0xffffffff

-> #0 (&bb->mutex){--..}:
       [<c017d8b7>] validate_chain+0x6b7/0xf50
       [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
       [<c017f299>] lock_acquire+0x89/0xc0
       [<c0d6f2ab>] __mutex_lock_common+0xab/0x3c0
       [<c0d6f698>] mutex_lock_nested+0x38/0x50
       [<c020ba20>] mmap+0x40/0xa0
       [<c01b111e>] mmap_region+0x14e/0x450
       [<c01b170f>] do_mmap_pgoff+0x2ef/0x310
       [<c0125a3d>] sys_mmap2+0xad/0xc0
       [<c012146f>] sysenter_do_call+0x12/0x43
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by X/4873:
 #0:  (&mm->mmap_sem){----}, at: [<c0125a1e>] sys_mmap2+0x8e/0xc0

stack backtrace:
Pid: 4873, comm: X Not tainted 2.6.27-rc6-tip #1
 [<c017cd09>] print_circular_bug_tail+0x79/0xc0
 [<c017d8b7>] validate_chain+0x6b7/0xf50
 [<c017a5b5>] ? trace_hardirqs_off_caller+0x15/0xb0
 [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
 [<c017f299>] lock_acquire+0x89/0xc0
 [<c020ba20>] ? mmap+0x40/0xa0
 [<c0d6f2ab>] __mutex_lock_common+0xab/0x3c0
 [<c020ba20>] ? mmap+0x40/0xa0
 [<c0d6f698>] mutex_lock_nested+0x38/0x50
 [<c020ba20>] ? mmap+0x40/0xa0
 [<c020ba20>] mmap+0x40/0xa0
 [<c01b111e>] mmap_region+0x14e/0x450
 [<c01afb88>] ? arch_get_unmapped_area_topdown+0xf8/0x160
 [<c01b170f>] do_mmap_pgoff+0x2ef/0x310
 [<c0125a3d>] sys_mmap2+0xad/0xc0
 [<c012146f>] sysenter_do_call+0x12/0x43
 [<c0120000>] ? __switch_to+0x130/0x220
 =======================
evbug.c: Event. Dev: input3, Type: 20, Code: 0, Value: 500
warning: `sudo' uses deprecated v2 capabilities in a way that may be insecure.


bin.c takes bb->mutex under mmap_sem when it is mmapped, and then does its
copy_*_user under bb->mutex too.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff -puN fs/sysfs/bin.c~sysfs-fix-deadlock fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~sysfs-fix-deadlock
+++ a/fs/sysfs/bin.c
@@ -61,6 +61,7 @@ read(struct file *file, char __user *use
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
+	char *temp;
 
 	if (size) {
 		if (offs > size)
@@ -69,23 +70,33 @@ read(struct file *file, char __user *use
 			count = size - offs;
 	}
 
+	temp = kmalloc(count, GFP_KERNEL);
+	if (!temp)
+		return -ENOMEM;
+
 	mutex_lock(&bb->mutex);
 
 	count = fill_read(dentry, bb->buffer, offs, count);
-	if (count < 0)
-		goto out_unlock;
+	if (count < 0) {
+		mutex_unlock(&bb->mutex);
+		goto out_free;
+	}
 
-	if (copy_to_user(userbuf, bb->buffer, count)) {
+	memcpy(temp, bb->buffer, count);
+
+	mutex_unlock(&bb->mutex);
+
+	if (copy_to_user(userbuf, temp, count)) {
 		count = -EFAULT;
-		goto out_unlock;
+		goto out_free;
 	}
 
 	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
 
 	*off = offs + count;
 
- out_unlock:
-	mutex_unlock(&bb->mutex);
+ out_free:
+	kfree(temp);
 	return count;
 }
 
@@ -118,6 +129,7 @@ static ssize_t write(struct file *file, 
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
+	char *temp;
 
 	if (size) {
 		if (offs > size)
@@ -126,19 +138,27 @@ static ssize_t write(struct file *file, 
 			count = size - offs;
 	}
 
-	mutex_lock(&bb->mutex);
+	temp = kmalloc(count, GFP_KERNEL);
+	if (!temp)
+		return -ENOMEM;
 
-	if (copy_from_user(bb->buffer, userbuf, count)) {
+	if (copy_from_user(temp, userbuf, count)) {
 		count = -EFAULT;
-		goto out_unlock;
+		goto out_free;
 	}
 
+	mutex_lock(&bb->mutex);
+
+	memcpy(bb->buffer, temp, count);
+
 	count = flush_write(dentry, bb->buffer, offs, count);
+	mutex_unlock(&bb->mutex);
+
 	if (count > 0)
 		*off = offs + count;
 
- out_unlock:
-	mutex_unlock(&bb->mutex);
+out_free:
+	kfree(temp);
 	return count;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
sysfs-fix-deadlock.patch
inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem.patch
mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex.patch
mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex-checkpatch-fixes.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

