From: akpm@linux-foundation.org
Subject: [merged] tmpfs-support-fallocate-preallocation.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:44 -0700
Message-ID: <20120531191544.7E141A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45678 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab2EaTPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:45 -0400
Received: by vcbfl13 with SMTP id fl13so134952vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, amwang@redhat.com, hch@infradead.org, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: support fallocate preallocation
has been removed from the -mm tree.  Its filename was
     tmpfs-support-fallocate-preallocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: support fallocate preallocation

The systemd plumbers expressed a wish that tmpfs support preallocation. 
Cong Wang wrote a patch, but several kernel guys expressed scepticism:
https://lkml.org/lkml/2011/11/18/137

Christoph Hellwig: What for exactly?  Please explain why preallocating on
tmpfs would make any sense.

Kay Sievers: To be able to safely use mmap(), regarding SIGBUS, on files
on the /dev/shm filesystem.  The glibc fallback loop for -ENOSYS [or
-EOPNOTSUPP] on fallocate is just ugly.

Hugh Dickins: If tmpfs is going to support
fallocate(FALLOC_FL_PUNCH_HOLE), it would seem perverse to permit the
deallocation but fail the allocation.  Christoph Hellwig: Agreed.

Now that we do have shmem_fallocate() for hole-punching, plumb in basic
support for preallocation mode too.  It's fairly straightforward (though
quite a few details needed attention), except for when it fails part way
through.  What a pity that fallocate(2) was not specified to return the
length allocated, permitting short fallocations!

As it is, when it fails part way through, we ought to free what has just
been allocated by this system call; but must be very sure not to free any
allocated earlier, or any allocated by racing accesses (not all excluded
by i_mutex).

But we cannot distinguish them: so in this patch simply leak allocations
on partial failure (they will be freed later if the file is removed).

An attractive alternative approach would have been for fallocate() not to
allocate pages at all, but note reservations by entries in the radix-tree.
 But that would give less assurance, and, critically, would be hard to fit
with mem cgroups (who owns the reservations?): allocating pages lets
fallocate() behave in just the same way as write().

Based-on-patch-by: Cong Wang <amwang@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Cong Wang <amwang@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-support-fallocate-preallocation mm/shmem.c
--- a/mm/shmem.c~tmpfs-support-fallocate-preallocation
+++ a/mm/shmem.c
@@ -1602,7 +1602,9 @@ static long shmem_fallocate(struct file 
 							 loff_t len)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	int error = -EOPNOTSUPP;
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	pgoff_t start, index, end;
+	int error;
 
 	mutex_lock(&inode->i_mutex);
 
@@ -1617,8 +1619,65 @@ static long shmem_fallocate(struct file 
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
 		error = 0;
+		goto out;
+	}
+
+	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
+	error = inode_newsize_ok(inode, offset + len);
+	if (error)
+		goto out;
+
+	start = offset >> PAGE_CACHE_SHIFT;
+	end = (offset + len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	/* Try to avoid a swapstorm if len is impossible to satisfy */
+	if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
+		error = -ENOSPC;
+		goto out;
+	}
+
+	for (index = start; index < end; index++) {
+		struct page *page;
+
+		/*
+		 * Good, the fallocate(2) manpage permits EINTR: we may have
+		 * been interrupted because we are using up too much memory.
+		 */
+		if (signal_pending(current))
+			error = -EINTR;
+		else
+			error = shmem_getpage(inode, index, &page, SGP_WRITE,
+									NULL);
+		if (error) {
+			/*
+			 * We really ought to free what we allocated so far,
+			 * but it would be wrong to free pages allocated
+			 * earlier, or already now in use: i_mutex does not
+			 * exclude all cases.  We do not know what to free.
+			 */
+			goto ctime;
+		}
+
+		if (!PageUptodate(page)) {
+			clear_highpage(page);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+		}
+		/*
+		 * set_page_dirty so that memory pressure will swap rather
+		 * than free the pages we are allocating (and SGP_CACHE pages
+		 * might still be clean: we now need to mark those dirty too).
+		 */
+		set_page_dirty(page);
+		unlock_page(page);
+		page_cache_release(page);
+		cond_resched();
 	}
 
+	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
+		i_size_write(inode, offset + len);
+ctime:
+	inode->i_ctime = CURRENT_TIME;
+out:
 	mutex_unlock(&inode->i_mutex);
 	return error;
 }
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

