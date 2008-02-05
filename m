From: akpm@linux-foundation.org
Subject: - shmem_file_write-is-redundant.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:10 -0800
Message-ID: <200802052229.m15MTpXo012013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762685AbYBEWoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     shmem_file_write is redundant
has been removed from the -mm tree.  Its filename was
     shmem_file_write-is-redundant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem_file_write is redundant
From: Hugh Dickins <hugh@veritas.com>

With the old aops, writing to a tmpfs file had to use its own special method:
the generic method would pass in a fresh page to prepare_write when the right
page was there in swapcache - which was inefficient to handle, even once we'd
concocted the code to handle it.

With the new aops, the generic method uses shmem_write_end, which lets
shmem_getpage find the right page: so now abandon shmem_file_write in favour
of the generic method.  Yes, that does do several things that tmpfs hasn't
really needed (notably balance_dirty_pages_ratelimited, which ramfs also
calls); but more use of common code is preferable.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  109 +--------------------------------------------------
 1 file changed, 3 insertions(+), 106 deletions(-)

diff -puN mm/shmem.c~shmem_file_write-is-redundant mm/shmem.c
--- a/mm/shmem.c~shmem_file_write-is-redundant
+++ a/mm/shmem.c
@@ -1106,7 +1106,7 @@ static int shmem_getpage(struct inode *i
 	 * Normally, filepage is NULL on entry, and either found
 	 * uptodate immediately, or allocated and zeroed, or read
 	 * in under swappage, which is then assigned to filepage.
-	 * But shmem_readpage and shmem_write_begin pass in a locked
+	 * But shmem_readpage (required for splice) passes in a locked
 	 * filepage, which may be found not uptodate by other callers
 	 * too, and may need to be copied from the swappage read in.
 	 */
@@ -1476,110 +1476,6 @@ shmem_write_end(struct file *file, struc
 	return copied;
 }
 
-static ssize_t
-shmem_file_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
-{
-	struct inode	*inode = file->f_path.dentry->d_inode;
-	loff_t		pos;
-	unsigned long	written;
-	ssize_t		err;
-
-	if ((ssize_t) count < 0)
-		return -EINVAL;
-
-	if (!access_ok(VERIFY_READ, buf, count))
-		return -EFAULT;
-
-	mutex_lock(&inode->i_mutex);
-
-	pos = *ppos;
-	written = 0;
-
-	err = generic_write_checks(file, &pos, &count, 0);
-	if (err || !count)
-		goto out;
-
-	err = remove_suid(file->f_path.dentry);
-	if (err)
-		goto out;
-
-	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
-
-	do {
-		struct page *page = NULL;
-		unsigned long bytes, index, offset;
-		char *kaddr;
-		int left;
-
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = PAGE_CACHE_SIZE - offset;
-		if (bytes > count)
-			bytes = count;
-
-		/*
-		 * We don't hold page lock across copy from user -
-		 * what would it guard against? - so no deadlock here.
-		 * But it still may be a good idea to prefault below.
-		 */
-
-		err = shmem_getpage(inode, index, &page, SGP_WRITE, NULL);
-		if (err)
-			break;
-
-		unlock_page(page);
-		left = bytes;
-		if (PageHighMem(page)) {
-			volatile unsigned char dummy;
-			__get_user(dummy, buf);
-			__get_user(dummy, buf + bytes - 1);
-
-			kaddr = kmap_atomic(page, KM_USER0);
-			left = __copy_from_user_inatomic(kaddr + offset,
-							buf, bytes);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
-		if (left) {
-			kaddr = kmap(page);
-			left = __copy_from_user(kaddr + offset, buf, bytes);
-			kunmap(page);
-		}
-
-		written += bytes;
-		count -= bytes;
-		pos += bytes;
-		buf += bytes;
-		if (pos > inode->i_size)
-			i_size_write(inode, pos);
-
-		flush_dcache_page(page);
-		set_page_dirty(page);
-		mark_page_accessed(page);
-		page_cache_release(page);
-
-		if (left) {
-			pos -= left;
-			written -= left;
-			err = -EFAULT;
-			break;
-		}
-
-		/*
-		 * Our dirty pages are not counted in nr_dirty,
-		 * and we do not attempt to balance dirty pages.
-		 */
-
-		cond_resched();
-	} while (count);
-
-	*ppos = pos;
-	if (written)
-		err = written;
-out:
-	mutex_unlock(&inode->i_mutex);
-	return err;
-}
-
 static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_t *desc, read_actor_t actor)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -2354,7 +2250,8 @@ static const struct file_operations shme
 #ifdef CONFIG_TMPFS
 	.llseek		= generic_file_llseek,
 	.read		= shmem_file_read,
-	.write		= shmem_file_write,
+	.write		= do_sync_write,
+	.aio_write	= generic_file_aio_write,
 	.fsync		= simple_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
