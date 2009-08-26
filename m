From: akpm@linux-foundation.org
Subject: + hugetlb-add-map_hugetlb-example.patch added to -mm tree
Date: Wed, 26 Aug 2009 16:24:45 -0700
Message-ID: <200908262324.n7QNOkOp015022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882AbZHZXZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 19:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebmunson@us.ibm.com, agl@us.ibm.com, david@gibson.dropbear.id.au, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, rientjes@google.com


The patch titled
     hugetlb: add MAP_HUGETLB example
has been added to the -mm tree.  Its filename is
     hugetlb-add-map_hugetlb-example.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: add MAP_HUGETLB example
From: Eric B Munson <ebmunson@us.ibm.com>

Add an example of how to use the MAP_HUGETLB flag to the vm documentation
directory and a reference to the example in hugetlbpage.txt.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/00-INDEX        |    2 
 Documentation/vm/hugetlbpage.txt |   14 +++--
 Documentation/vm/map_hugetlb.c   |   77 +++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 6 deletions(-)

diff -puN Documentation/vm/00-INDEX~hugetlb-add-map_hugetlb-example Documentation/vm/00-INDEX
--- a/Documentation/vm/00-INDEX~hugetlb-add-map_hugetlb-example
+++ a/Documentation/vm/00-INDEX
@@ -22,3 +22,5 @@ slabinfo.c
 	- source code for a tool to get reports about slabs.
 slub.txt
 	- a short users guide for SLUB.
+map_hugetlb.c
+	- an example program that uses the MAP_HUGETLB mmap flag.
diff -puN Documentation/vm/hugetlbpage.txt~hugetlb-add-map_hugetlb-example Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlb-add-map_hugetlb-example
+++ a/Documentation/vm/hugetlbpage.txt
@@ -187,12 +187,14 @@ Regular chown, chgrp, and chmod commands
 used to change the file attributes on hugetlbfs.
 
 Also, it is important to note that no such mount command is required if the
-applications are going to use only shmat/shmget system calls.  Users who
-wish to use hugetlb page via shared memory segment should be a member of
-a supplementary group and system admin needs to configure that gid into
-/proc/sys/vm/hugetlb_shm_group.  It is possible for same or different
-applications to use any combination of mmaps and shm* calls, though the
-mount of filesystem will be required for using mmap calls.
+applications are going to use only shmat/shmget system calls or mmap with
+MAP_HUGETLB.  Users who wish to use hugetlb page via shared memory segment
+should be a member of a supplementary group and system admin needs to
+configure that gid into /proc/sys/vm/hugetlb_shm_group.  It is possible for
+same or different applications to use any combination of mmaps and shm*
+calls, though the mount of filesystem will be required for using mmap calls
+without MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see
+map_hugetlb.c.
 
 *******************************************************************
 
diff -puN /dev/null Documentation/vm/map_hugetlb.c
--- /dev/null
+++ a/Documentation/vm/map_hugetlb.c
@@ -0,0 +1,77 @@
+/*
+ * Example of using hugepage memory in a user application using the mmap
+ * system call with MAP_HUGETLB flag.  Before running this program make
+ * sure the administrator has allocated enough default sized huge pages
+ * to cover the 256 MB allocation.
+ *
+ * For ia64 architecture, Linux kernel reserves Region number 4 for hugepages.
+ * That means the addresses starting with 0x800000... will need to be
+ * specified.  Specifying a fixed address is not required on ppc64, i386
+ * or x86_64.
+ */
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+
+#define LENGTH (256UL*1024*1024)
+#define PROTECTION (PROT_READ | PROT_WRITE)
+
+#ifndef MAP_HUGETLB
+#define MAP_HUGETLB 0x40
+#endif
+
+/* Only ia64 requires this */
+#ifdef __ia64__
+#define ADDR (void *)(0x8000000000000000UL)
+#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED)
+#else
+#define ADDR (void *)(0x0UL)
+#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
+#endif
+
+void check_bytes(char *addr)
+{
+	printf("First hex is %x\n", *((unsigned int *)addr));
+}
+
+void write_bytes(char *addr)
+{
+	unsigned long i;
+
+	for (i = 0; i < LENGTH; i++)
+		*(addr + i) = (char)i;
+}
+
+void read_bytes(char *addr)
+{
+	unsigned long i;
+
+	check_bytes(addr);
+	for (i = 0; i < LENGTH; i++)
+		if (*(addr + i) != (char)i) {
+			printf("Mismatch at %lu\n", i);
+			break;
+		}
+}
+
+int main(void)
+{
+	void *addr;
+
+	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	printf("Returned address is %p\n", addr);
+	check_bytes(addr);
+	write_bytes(addr);
+	read_bytes(addr);
+
+	munmap(addr, LENGTH);
+
+	return 0;
+}
_

Patches currently in -mm which might be from ebmunson@us.ibm.com are

hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch

