From: akpm@linux-foundation.org
Subject: [merged]
 hugetlbfs-document-min_size-mount-option-and-cleanup.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:52 -0700
Message-ID: <552fe8a8.t8nywZxPOUw56fO2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbbDPQqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, andi@firstfloor.org, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, iamjoonsoo.kim@lge.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: document min_size mount option and cleanup
has been removed from the -mm tree.  Its filename was
     hugetlbfs-document-min_size-mount-option-and-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: document min_size mount option and cleanup

Add min_size mount option to the hugetlbfs documentation.  Also, add the
missing pagesize option and mention that size can be specified as bytes or
a percentage of huge page pool.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   31 ++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~hugetlbfs-document-min_size-mount-option-and-cleanup Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlbfs-document-min_size-mount-option-and-cleanup
+++ a/Documentation/vm/hugetlbpage.txt
@@ -267,21 +267,34 @@ call, then it is required that system ad
 type hugetlbfs:
 
   mount -t hugetlbfs \
-	-o uid=<value>,gid=<value>,mode=<value>,size=<value>,nr_inodes=<value> \
-	none /mnt/huge
+	-o uid=<value>,gid=<value>,mode=<value>,pagesize=<value>,size=<value>,\
+	min_size=<value>,nr_inodes=<value> none /mnt/huge
 
 This command mounts a (pseudo) filesystem of type hugetlbfs on the directory
 /mnt/huge.  Any files created on /mnt/huge uses huge pages.  The uid and gid
 options sets the owner and group of the root of the file system.  By default
 the uid and gid of the current process are taken.  The mode option sets the
 mode of root of file system to value & 01777.  This value is given in octal.
-By default the value 0755 is picked. The size option sets the maximum value of
-memory (huge pages) allowed for that filesystem (/mnt/huge). The size is
-rounded down to HPAGE_SIZE.  The option nr_inodes sets the maximum number of
-inodes that /mnt/huge can use.  If the size or nr_inodes option is not
-provided on command line then no limits are set.  For size and nr_inodes
-options, you can use [G|g]/[M|m]/[K|k] to represent giga/mega/kilo. For
-example, size=2K has the same meaning as size=2048.
+By default the value 0755 is picked. If the paltform supports multiple huge
+page sizes, the pagesize option can be used to specify the huge page size and
+associated pool.  pagesize is specified in bytes.  If pagesize is not specified
+the paltform's default huge page size and associated pool will be used. The
+size option sets the maximum value of memory (huge pages) allowed for that
+filesystem (/mnt/huge).  The size option can be specified in bytes, or as a
+percentage of the specified huge page pool (nr_hugepages).  The size is
+rounded down to HPAGE_SIZE boundary.  The min_size option sets the minimum
+value of memory (huge pages) allowed for the filesystem.  min_size can be
+specified in the same way as size, either bytes or a percentage of the
+huge page pool.  At mount time, the number of huge pages specified by
+min_size are reserved for use by the filesystem.  If there are not enough
+free huge pages available, the mount will fail.  As huge pages are allocated
+to the filesystem and freed, the reserve count is adjusted so that the sum
+of allocated and reserved huge pages is always at least min_size.  The option
+nr_inodes sets the maximum number of inodes that /mnt/huge can use.  If the
+size, min_size or nr_inodes option is not provided on command line then
+no limits are set.  For pagesize, size, min_size and nr_inodes options, you
+can use [G|g]/[M|m]/[K|k] to represent giga/mega/kilo. For example, size=2K
+has the same meaning as size=2048.
 
 While read system calls are supported on files that reside on hugetlb
 file systems, write system calls are not.
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

origin.patch

