From: akpm@linux-foundation.org
Subject: [merged]
 dax-explain-how-read2-write2-addresses-are-validated.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:36:43 -0700
Message-ID: <20170907183643.Y_pzuDrvi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbdIGSgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:36:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, mawilcox@microsoft.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com


The patch titled
     Subject: dax: explain how read(2)/write(2) addresses are validated
has been removed from the -mm tree.  Its filename was
     dax-explain-how-read2-write2-addresses-are-validated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1004,6 +1004,11 @@ dax_iomap_actor(struct inode *inode, lof
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


