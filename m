From: akpm@linux-foundation.org
Subject: + dax-explain-how-read2-write2-addresses-are-validated.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 15:05:20 -0700
Message-ID: <59961320.iDRzLwyoHrKjVjh8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdHQWFV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: explain how read(2)/write(2) addresses are validated
has been added to the -mm tree.  Its filename is
     dax-explain-how-read2-write2-addresses-are-validated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-explain-how-read2-write2-addresses-are-validated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-explain-how-read2-write2-addresses-are-validated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: explain how read(2)/write(2) addresses are validated

Add a comment explaining how the user addresses provided to read(2) and
write(2) are validated in the DAX I/O path.  We call dax_copy_from_iter()
or copy_to_iter() on these without calling access_ok() first in the DAX
code, and there was a concern that the user might be able to read/write to
arbitrary kernel addresses with this path.

Link: http://lkml.kernel.org/r/20170816173615.10098-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/dax.c~dax-explain-how-read2-write2-addresses-are-validated fs/dax.c
--- a/fs/dax.c~dax-explain-how-read2-write2-addresses-are-validated
+++ a/fs/dax.c
@@ -1001,6 +1001,11 @@ dax_iomap_actor(struct inode *inode, lof
 		if (map_len > end - pos)
 			map_len = end - pos;
 
+		/*
+		 * The userspace address for the memory copy has already been
+		 * validated via access_ok() in either vfs_read() or
+		 * vfs_write(), depending on which operation we are doing.
+		 */
 		if (iov_iter_rw(iter) == WRITE)
 			map_len = dax_copy_from_iter(dax_dev, pgoff, kaddr,
 					map_len, iter);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-add-vm_insert_mixed_mkwrite.patch
dax-relocate-some-dax-functions.patch
dax-use-common-4k-zero-page-for-dax-mmap-reads.patch
dax-remove-dax-code-from-page_cache_tree_insert.patch
dax-move-all-dax-radix-tree-defs-to-fs-daxc.patch
dax-explain-how-read2-write2-addresses-are-validated.patch

