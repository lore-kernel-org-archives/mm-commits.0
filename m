From: akpm@linux-foundation.org
Subject: [merged]
 mm-filemap-generic_file_read_iter-check-for-zero-reads-unconditionally.patch removed from -mm tree
Date: Sat, 26 Mar 2016 20:31:33 -0700
Message-ID: <56f75415.7eMNg4KfYge44X6c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcC0Dbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:31:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicstange@gmail.com, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: generic_file_read_iter(): check for zero reads unconditionally
has been removed from the -mm tree.  Its filename was
     mm-filemap-generic_file_read_iter-check-for-zero-reads-unconditionally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicolai Stange <nicstange@gmail.com>
Subject: mm/filemap: generic_file_read_iter(): check for zero reads unconditionally

If
- generic_file_read_iter() gets called with a zero read length,
- the read offset is at a page boundary,
- IOCB_DIRECT is not set
- and the page in question hasn't made it into the page cache yet,
then do_generic_file_read() will trigger a readahead with a req_size hint
of zero.

Since roundup_pow_of_two(0) is undefined, UBSAN reports

  UBSAN: Undefined behaviour in include/linux/log2.h:63:13
  shift exponent 64 is too large for 64-bit type 'long unsigned int'
  CPU: 3 PID: 1017 Comm: sa1 Tainted: G L 4.5.0-next-20160318+ #14
  [...]
  Call Trace:
   [...]
   [<ffffffff813ef61a>] ondemand_readahead+0x3aa/0x3d0
   [<ffffffff813ef61a>] ? ondemand_readahead+0x3aa/0x3d0
   [<ffffffff813c73bd>] ? find_get_entry+0x2d/0x210
   [<ffffffff813ef9c3>] page_cache_sync_readahead+0x63/0xa0
   [<ffffffff813cc04d>] do_generic_file_read+0x80d/0xf90
   [<ffffffff813cc955>] generic_file_read_iter+0x185/0x420
   [...]
   [<ffffffff81510b06>] __vfs_read+0x256/0x3d0
   [...]

when get_init_ra_size() gets called from ondemand_readahead().

The net effect is that the initial readahead size is arch dependent for
requested read lengths of zero: for example, since

  1UL << (sizeof(unsigned long) * 8)

evaluates to 1 on x86 while its result is 0 on ARMv7, the initial readahead
size becomes 4 on the former and 0 on the latter.

What's more, whether or not the file access timestamp is updated for zero
length reads is decided differently for the two cases of IOCB_DIRECT
being set or cleared: in the first case, generic_file_read_iter()
explicitly skips updating that timestamp while in the latter case, it is
always updated through the call to do_generic_file_read().

According to POSIX, zero length reads "do not modify the last data access
timestamp" and thus, the IOCB_DIRECT behaviour is POSIXly correct.

Let generic_file_read_iter() unconditionally check the requested read
length at its entry and return immediately with success if it is zero.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-filemap-generic_file_read_iter-check-for-zero-reads-unconditionally mm/filemap.c
--- a/mm/filemap.c~mm-filemap-generic_file_read_iter-check-for-zero-reads-unconditionally
+++ a/mm/filemap.c
@@ -1840,15 +1840,16 @@ generic_file_read_iter(struct kiocb *ioc
 	ssize_t retval = 0;
 	loff_t *ppos = &iocb->ki_pos;
 	loff_t pos = *ppos;
+	size_t count = iov_iter_count(iter);
+
+	if (!count)
+		goto out; /* skip atime */
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		struct address_space *mapping = file->f_mapping;
 		struct inode *inode = mapping->host;
-		size_t count = iov_iter_count(iter);
 		loff_t size;
 
-		if (!count)
-			goto out; /* skip atime */
 		size = i_size_read(inode);
 		retval = filemap_write_and_wait_range(mapping, pos,
 					pos + count - 1);
_

Patches currently in -mm which might be from nicstange@gmail.com are


