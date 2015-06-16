From: akpm@linux-foundation.org
Subject: + tmpfs-truncate-prealloc-blocks-past-i_size.patch added to -mm
 tree
Date: Tue, 16 Jun 2015 13:14:07 -0700
Message-ID: <5580838f.hTbajlU80bIw0KwA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbbFPUOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 16:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbacik@fb.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: truncate prealloc blocks past i_size
has been added to the -mm tree.  Its filename is
     tmpfs-truncate-prealloc-blocks-past-i_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tmpfs-truncate-prealloc-blocks-past-i_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-truncate-prealloc-blocks-past-i_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tmpfs-truncate-prealloc-blocks-past-i_size.patch
linux-next.patch

