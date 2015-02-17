From: akpm@linux-foundation.org
Subject: [merged]
 dax-does-not-work-correctly-with-virtual-aliasing-caches.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:06:11 -0800
Message-ID: <54e39f33.XYeQ3TS6RIhvavY7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbbBQUGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, ralf@linux-mips.org, rdunlap@infradead.org, rmk@arm.linux.org.uk, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: does not work correctly with virtual aliasing caches
has been removed from the -mm tree.  Its filename was
     dax-does-not-work-correctly-with-virtual-aliasing-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: dax: does not work correctly with virtual aliasing caches

The DAX code accesses the underlying storage through the kernel's linear
mapping, which may not be cache-coherent with user mappings on ARM, MIPS
or SPARC.  Temporarily disable the DAX code until this problem is
resolved.

The original XIP code also had this problem, but it was never noticed.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/dax.txt |    3 +++
 fs/Kconfig                        |    1 +
 2 files changed, 4 insertions(+)

diff -puN Documentation/filesystems/dax.txt~dax-does-not-work-correctly-with-virtual-aliasing-caches Documentation/filesystems/dax.txt
--- a/Documentation/filesystems/dax.txt~dax-does-not-work-correctly-with-virtual-aliasing-caches
+++ a/Documentation/filesystems/dax.txt
@@ -82,6 +82,9 @@ Shortcomings
 Even if the kernel or its modules are stored on a filesystem that supports
 DAX on a block device that supports DAX, they will still be copied into RAM.
 
+The DAX code does not work correctly on architectures which have virtually
+mapped caches such as ARM, MIPS and SPARC.
+
 Calling get_user_pages() on a range of user memory that has been mmaped
 from a DAX file will fail as there are no 'struct page' to describe
 those pages.  This problem is being worked on.  That means that O_DIRECT
diff -puN fs/Kconfig~dax-does-not-work-correctly-with-virtual-aliasing-caches fs/Kconfig
--- a/fs/Kconfig~dax-does-not-work-correctly-with-virtual-aliasing-caches
+++ a/fs/Kconfig
@@ -36,6 +36,7 @@ source "fs/nilfs2/Kconfig"
 config FS_DAX
 	bool "Direct Access (DAX) support"
 	depends on MMU
+	depends on !(ARM || MIPS || SPARC)
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

