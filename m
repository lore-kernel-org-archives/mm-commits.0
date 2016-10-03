From: akpm@linux-foundation.org
Subject: + vfsmm-fix-a-dead-loop-in-truncate_inode_pages_range.patch added to -mm tree
Date: Mon, 03 Oct 2016 14:40:01 -0700
Message-ID: <57f2d031.DzXwU8jIEcPnH0Zs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36895 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbcJCVkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2016 17:40:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fangwei1@huawei.com, david@fromorbit.com, hch@infradead.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs,mm: fix a dead loop in truncate_inode_pages_range()
has been added to the -mm tree.  Its filename is
     vfsmm-fix-a-dead-loop-in-truncate_inode_pages_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfsmm-fix-a-dead-loop-in-truncate_inode_pages_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfsmm-fix-a-dead-loop-in-truncate_inode_pages_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Fang <fangwei1@huawei.com>
Subject: vfs,mm: fix a dead loop in truncate_inode_pages_range()

We triggered a deadloop in truncate_inode_pages_range() on 32 bits
architecture with the test case bellow:

	...
	fd = open();
	write(fd, buf, 4096);
	preadv64(fd, &iovec, 1, 0xffffffff000);
	ftruncate(fd, 0);
	...

Then ftruncate() will not return forever.

The filesystem used in this case is ubifs, but it can be triggered on many
other filesystems.

When preadv64() is called with offset=0xffffffff000, a page with
index=0xffffffff will be added to the radix tree of ->mapping.  Then this
page can be found in ->mapping with pagevec_lookup().  After that,
truncate_inode_pages_range(), which is called in ftruncate(), will fall
into an infinite loop:

* find a page with index=0xffffffff, since index>=end, this page
  won't be truncated

* index++, and index become 0

* the page with index=0xffffffff will be found again

The data type of index is unsigned long, so index won't overflow to 0 on
64 bits architecture in this case, and the dead loop won't happen.

Since truncate_inode_pages_range() is executed with holding lock of
inode->i_rwsem, any operation related with this lock will be blocked, and
a hung task will happen, e.g.:

INFO: task truncate_test:3364 blocked for more than 120 seconds.
...
[<c03c2c44>] call_rwsem_down_write_failed+0x17/0x30
[<c00b93bc>] generic_file_write_iter+0x32/0x1c0
[<c01b7078>] ubifs_write_iter+0xcc/0x170
[<c00fae48>] __vfs_write+0xc4/0x120
[<c00fb784>] vfs_write+0xb2/0x1b0
[<c00fbbe4>] SyS_write+0x46/0xa0

The page with index=0xffffffff added to ->mapping is useless.  Fix this by
checking the read position before allocating pages.

Link: http://lkml.kernel.org/r/1475151010-40166-1-git-send-email-fangwei1@huawei.com
Signed-off-by: Wei Fang <fangwei1@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/filemap.c~vfsmm-fix-a-dead-loop-in-truncate_inode_pages_range mm/filemap.c
--- a/mm/filemap.c~vfsmm-fix-a-dead-loop-in-truncate_inode_pages_range
+++ a/mm/filemap.c
@@ -1674,6 +1674,10 @@ static ssize_t do_generic_file_read(stru
 	unsigned int prev_offset;
 	int error = 0;
 
+	if (unlikely(*ppos >= inode->i_sb->s_maxbytes))
+		return -EINVAL;
+	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
+
 	index = *ppos >> PAGE_SHIFT;
 	prev_index = ra->prev_pos >> PAGE_SHIFT;
 	prev_offset = ra->prev_pos & (PAGE_SIZE-1);
_

Patches currently in -mm which might be from fangwei1@huawei.com are

vfsmm-fix-a-dead-loop-in-truncate_inode_pages_range.patch

