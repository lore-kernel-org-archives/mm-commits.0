From: akpm@linux-foundation.org
Subject: [patch 100/127] vfs,mm: fix a dead loop in
 truncate_inode_pages_range()
Date: Fri, 07 Oct 2016 17:01:52 -0700
Message-ID: <57f83770.jBe2ennHqcxxhoPe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755575AbcJHABx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, fangwei1@huawei.com, david@fromorbit.com, hch@infradead.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk

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
@@ -1687,6 +1687,10 @@ static ssize_t do_generic_file_read(stru
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
