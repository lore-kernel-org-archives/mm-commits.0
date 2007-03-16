From: akpm@linux-foundation.org
Subject: + revoke-add-documentation.patch added to -mm tree
Date: Thu, 15 Mar 2007 17:15:59 -0800
Message-ID: <200703160115.l2G1Fxdv031761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47948 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbXCPBQY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 21:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, ak@suse.de, alan@redhat.com, hch@lst.de, mtk-manpages@gmx.net


The patch titled
     revoke: add documentation
has been added to the -mm tree.  Its filename is
     revoke-add-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: add documentation
From: Pekka Enberg <penberg@cs.helsinki.fi>

This documents revoke file operation in Documentation/filesystems/vfs.txt.

Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/filesystems/vfs.txt~revoke-add-documentation Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~revoke-add-documentation
+++ a/Documentation/filesystems/vfs.txt
@@ -732,6 +732,7 @@ struct file_operations {
 int);
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned  
 int);
+	int (*revoke)(struct file *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -805,6 +806,10 @@ otherwise noted.
   splice_read: called by the VFS to splice data from file to a pipe. This
 	       method is used by the splice(2) system call
 
+  revoke: called by revokeat(2) and frevoke(2) system calls to revoke access
+	  to an open file. This method must ensure that all currently blocked
+	  writes are flushed and reads will fail.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
