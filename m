From: akpm@linux-foundation.org
Subject: [merged] tmpfs-truncate-prealloc-blocks-past-i_size.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:30 -0700
Message-ID: <5591ad02.T/dPe1dXiR295m8g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbbF2Uja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbacik@fb.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: truncate prealloc blocks past i_size
has been removed from the -mm tree.  Its filename was
     tmpfs-truncate-prealloc-blocks-past-i_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josef Bacik <jbacik@fb.com>
Subject: tmpfs: truncate prealloc blocks past i_size

One of the rocksdb people noticed that when you do something like this

fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, 10M)
pwrite(fd, buf, 5M, 0)
ftruncate(5M)

on tmpfs, the file would still take up 10M: which led to super fun issues
because we were getting ENOSPC before we thought we should be getting
ENOSPC.  This patch fixes the problem, and mirrors what all the other
fs'es do (and was agreed to be the correct behaviour at LSF).

I tested it locally to make sure it worked properly with the following

xfs_io -f -c "falloc -k 0 10M" -c "pwrite 0 5M" -c "truncate 5M" file

Without the patch we have "Blocks: 20480", with the patch we have the
correct value of "Blocks: 10240".

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-truncate-prealloc-blocks-past-i_size mm/shmem.c
--- a/mm/shmem.c~tmpfs-truncate-prealloc-blocks-past-i_size
+++ a/mm/shmem.c
@@ -569,7 +569,7 @@ static int shmem_setattr(struct dentry *
 			i_size_write(inode, newsize);
 			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 		}
-		if (newsize < oldsize) {
+		if (newsize <= oldsize) {
 			loff_t holebegin = round_up(newsize, PAGE_SIZE);
 			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
 			shmem_truncate_range(inode, newsize, (loff_t)-1);
_

Patches currently in -mm which might be from jbacik@fb.com are

origin.patch
linux-next.patch

