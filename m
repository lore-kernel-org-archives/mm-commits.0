From: akpm@linux-foundation.org
Subject: [merged]
 dax-replace-xip-documentation-with-dax-documentation.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:05:39 -0800
Message-ID: <54e39f13.2cnHBvjBZiK/dscP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbBQUFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: replace XIP documentation with DAX documentation
has been removed from the -mm tree.  Its filename was
     dax-replace-xip-documentation-with-dax-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: replace XIP documentation with DAX documentation

Based on the original XIP documentation, this documents the current state
of affairs, and includes instructions on how users can enable DAX if their
devices and kernel support it.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/00-INDEX |    5 -
 Documentation/filesystems/dax.txt  |   89 +++++++++++++++++++++++++++
 Documentation/filesystems/xip.txt  |   71 ---------------------
 3 files changed, 92 insertions(+), 73 deletions(-)

diff -puN Documentation/filesystems/00-INDEX~dax-replace-xip-documentation-with-dax-documentation Documentation/filesystems/00-INDEX
--- a/Documentation/filesystems/00-INDEX~dax-replace-xip-documentation-with-dax-documentation
+++ a/Documentation/filesystems/00-INDEX
@@ -34,6 +34,9 @@ configfs/
 	- directory containing configfs documentation and example code.
 cramfs.txt
 	- info on the cram filesystem for small storage (ROMs etc).
+dax.txt
+	- info on avoiding the page cache for files stored on CPU-addressable
+	  storage devices.
 debugfs.txt
 	- info on the debugfs filesystem.
 devpts.txt
@@ -154,5 +157,3 @@ xfs-self-describing-metadata.txt
 	- info on XFS Self Describing Metadata.
 xfs.txt
 	- info and mount options for the XFS filesystem.
-xip.txt
-	- info on execute-in-place for file mappings.
diff -puN /dev/null Documentation/filesystems/dax.txt
--- /dev/null
+++ a/Documentation/filesystems/dax.txt
@@ -0,0 +1,89 @@
+Direct Access for files
+-----------------------
+
+Motivation
+----------
+
+The page cache is usually used to buffer reads and writes to files.
+It is also used to provide the pages which are mapped into userspace
+by a call to mmap.
+
+For block devices that are memory-like, the page cache pages would be
+unnecessary copies of the original storage.  The DAX code removes the
+extra copy by performing reads and writes directly to the storage device.
+For file mappings, the storage device is mapped directly into userspace.
+
+
+Usage
+-----
+
+If you have a block device which supports DAX, you can make a filesystem
+on it as usual.  When mounting it, use the -o dax option manually
+or add 'dax' to the options in /etc/fstab.
+
+
+Implementation Tips for Block Driver Writers
+--------------------------------------------
+
+To support DAX in your block driver, implement the 'direct_access'
+block device operation.  It is used to translate the sector number
+(expressed in units of 512-byte sectors) to a page frame number (pfn)
+that identifies the physical page for the memory.  It also returns a
+kernel virtual address that can be used to access the memory.
+
+The direct_access method takes a 'size' parameter that indicates the
+number of bytes being requested.  The function should return the number
+of bytes that can be contiguously accessed at that offset.  It may also
+return a negative errno if an error occurs.
+
+In order to support this method, the storage must be byte-accessible by
+the CPU at all times.  If your device uses paging techniques to expose
+a large amount of memory through a smaller window, then you cannot
+implement direct_access.  Equally, if your device can occasionally
+stall the CPU for an extended period, you should also not attempt to
+implement direct_access.
+
+These block devices may be used for inspiration:
+- axonram: Axon DDR2 device driver
+- brd: RAM backed block device driver
+- dcssblk: s390 dcss block device driver
+
+
+Implementation Tips for Filesystem Writers
+------------------------------------------
+
+Filesystem support consists of
+- adding support to mark inodes as being DAX by setting the S_DAX flag in
+  i_flags
+- implementing the direct_IO address space operation, and calling
+  dax_do_io() instead of blockdev_direct_IO() if S_DAX is set
+- implementing an mmap file operation for DAX files which sets the
+  VM_MIXEDMAP flag on the VMA, and setting the vm_ops to include handlers
+  for fault and page_mkwrite (which should probably call dax_fault() and
+  dax_mkwrite(), passing the appropriate get_block() callback)
+- calling dax_truncate_page() instead of block_truncate_page() for DAX files
+- ensuring that there is sufficient locking between reads, writes,
+  truncates and page faults
+
+The get_block() callback passed to the DAX functions may return
+uninitialised extents.  If it does, it must ensure that simultaneous
+calls to get_block() (for example by a page-fault racing with a read()
+or a write()) work correctly.
+
+These filesystems may be used for inspiration:
+- ext2: the second extended filesystem, see Documentation/filesystems/ext2.txt
+
+
+Shortcomings
+------------
+
+Even if the kernel or its modules are stored on a filesystem that supports
+DAX on a block device that supports DAX, they will still be copied into RAM.
+
+Calling get_user_pages() on a range of user memory that has been mmaped
+from a DAX file will fail as there are no 'struct page' to describe
+those pages.  This problem is being worked on.  That means that O_DIRECT
+reads/writes to those memory ranges from a non-DAX file will fail (note
+that O_DIRECT reads/writes _of a DAX file_ do work, it is the memory
+that is being accessed that is key here).  Other things that will not
+work include RDMA, sendfile() and splice().
diff -puN Documentation/filesystems/xip.txt~dax-replace-xip-documentation-with-dax-documentation /dev/null
--- a/Documentation/filesystems/xip.txt
+++ /dev/null
@@ -1,71 +0,0 @@
-Execute-in-place for file mappings
-----------------------------------
-
-Motivation
-----------
-File mappings are performed by mapping page cache pages to userspace. In
-addition, read&write type file operations also transfer data from/to the page
-cache.
-
-For memory backed storage devices that use the block device interface, the page
-cache pages are in fact copies of the original storage. Various approaches
-exist to work around the need for an extra copy. The ramdisk driver for example
-does read the data into the page cache, keeps a reference, and discards the
-original data behind later on.
-
-Execute-in-place solves this issue the other way around: instead of keeping
-data in the page cache, the need to have a page cache copy is eliminated
-completely. With execute-in-place, read&write type operations are performed
-directly from/to the memory backed storage device. For file mappings, the
-storage device itself is mapped directly into userspace.
-
-This implementation was initially written for shared memory segments between
-different virtual machines on s390 hardware to allow multiple machines to
-share the same binaries and libraries.
-
-Implementation
---------------
-Execute-in-place is implemented in three steps: block device operation,
-address space operation, and file operations.
-
-A block device operation named direct_access is used to translate the
-block device sector number to a page frame number (pfn) that identifies
-the physical page for the memory.  It also returns a kernel virtual
-address that can be used to access the memory.
-
-The direct_access method takes a 'size' parameter that indicates the
-number of bytes being requested.  The function should return the number
-of bytes that can be contiguously accessed at that offset.  It may also
-return a negative errno if an error occurs.
-
-The block device operation is optional, these block devices support it as of
-today:
-- dcssblk: s390 dcss block device driver
-
-An address space operation named get_xip_mem is used to retrieve references
-to a page frame number and a kernel address. To obtain these values a reference
-to an address_space is provided. This function assigns values to the kmem and
-pfn parameters. The third argument indicates whether the function should allocate
-blocks if needed.
-
-This address space operation is mutually exclusive with readpage&writepage that
-do page cache read/write operations.
-The following filesystems support it as of today:
-- ext2: the second extended filesystem, see Documentation/filesystems/ext2.txt
-
-A set of file operations that do utilize get_xip_page can be found in
-mm/filemap_xip.c . The following file operation implementations are provided:
-- aio_read/aio_write
-- readv/writev
-- sendfile
-
-The generic file operations do_sync_read/do_sync_write can be used to implement
-classic synchronous IO calls.
