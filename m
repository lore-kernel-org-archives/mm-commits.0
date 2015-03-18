From: akpm@linux-foundation.org
Subject: + hugetlbfs-document-min_size-mount-option.patch added to -mm
 tree
Date: Wed, 18 Mar 2015 14:44:37 -0700
Message-ID: <5509f1c5.R++jrBw523oDNRm1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965050AbbCRVoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Mar 2015 17:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, andi@firstfloor.org, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, iamjoonsoo.kim@lge.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: document min_size mount option
has been added to the -mm tree.  Its filename is
     hugetlbfs-document-min_size-mount-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-document-min_size-mount-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-document-min_size-mount-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: document min_size mount option

Update documentation for the hugetlbfs min_size mount option.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~hugetlbfs-document-min_size-mount-option Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlbfs-document-min_size-mount-option
+++ a/Documentation/vm/hugetlbpage.txt
@@ -267,8 +267,8 @@ call, then it is required that system ad
 type hugetlbfs:
 
   mount -t hugetlbfs \
-	-o uid=<value>,gid=<value>,mode=<value>,size=<value>,nr_inodes=<value> \
-	none /mnt/huge
+	-o uid=<value>,gid=<value>,mode=<value>,size=<value>,min_size=<value>, \
+	nr_inodes=<value> none /mnt/huge
 
 This command mounts a (pseudo) filesystem of type hugetlbfs on the directory
 /mnt/huge.  Any files created on /mnt/huge uses huge pages.  The uid and gid
@@ -277,11 +277,18 @@ the uid and gid of the current process a
 mode of root of file system to value & 01777.  This value is given in octal.
 By default the value 0755 is picked. The size option sets the maximum value of
 memory (huge pages) allowed for that filesystem (/mnt/huge). The size is
-rounded down to HPAGE_SIZE.  The option nr_inodes sets the maximum number of
-inodes that /mnt/huge can use.  If the size or nr_inodes option is not
-provided on command line then no limits are set.  For size and nr_inodes
-options, you can use [G|g]/[M|m]/[K|k] to represent giga/mega/kilo. For
-example, size=2K has the same meaning as size=2048.
+rounded down to HPAGE_SIZE.  The min_size option sets the minimum value of
+memory (huge pages) allowed for the filesystem.  Like the size option,
+min_size is rounded down to HPAGE_SIZE.  At mount time, the number of huge
+pages specified by min_size are reserved for use by the filesystem.  If
+there are not enough free huge pages available, the mount will fail.  As
+huge pages are allocated to the filesystem and freed, the reserve count
+is adjusted so that the sum of allocated and reserved huge pages is always
+at least min_size.  The option nr_inodes sets the maximum number of
+inodes that /mnt/huge can use.  If the size, min_size or nr_inodes option
+is not provided on command line then no limits are set.  For size, min_size
+and nr_inodes options, you can use [G|g]/[M|m]/[K|k] to represent
+giga/mega/kilo. For example, size=2K has the same meaning as size=2048.
 
 While read system calls are supported on files that reside on hugetlb
 file systems, write system calls are not.
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option.patch

