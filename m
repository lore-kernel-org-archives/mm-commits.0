From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-define-system-call-hugetlb-size-encodings-in-single-file.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:40:43 -0700
Message-ID: <20170907184043.LYHVrJktJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755228AbdIGSko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, arnd@arndb.de, dbueso@suse.de, khandual@linux.vnet.ibm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, mtk.manpages@gmail.com, willy@infradead.org


The patch titled
     Subject: mm: hugetlb: define system call hugetlb size encodings in single file
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-define-system-call-hugetlb-size-encodings-in-single-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: hugetlb: define system call hugetlb size encodings in single file

Patch series "Consolidate system call hugetlb page size encodings".

These patches are the result of discussions in
https://lkml.org/lkml/2017/3/8/548.  The following changes are made in the
patch set:

1) Put all the log2 encoded huge page size definitions in a common
   header file.  The idea is have a set of definitions that can be use as
   the basis for system call specific definitions such as MAP_HUGE_* and
   SHM_HUGE_*.

2) Remove MAP_HUGE_* definitions in arch specific files.  All these
   definitions are the same.  Consolidate all definitions in the primary
   user header file (uapi/linux/mman.h).

3) Remove SHM_HUGE_* definitions intended for user space from kernel
   header file, and add to user (uapi/linux/shm.h) header file.  Add
   definitions for all known huge page size encodings as in mmap.



This patch (of 3):

If hugetlb pages are requested in mmap or shmget system calls, a huge page
size other than default can be requested.  This is accomplished by
encoding the log2 of the huge page size in the upper bits of the flag
argument.  asm-generic and arch specific headers all define the same
values for these encodings.

Put common definitions in a single header file.  The primary uapi header
files for mmap and shm will use these definitions as a basis for
definitions specific to those system calls.

Link: http://lkml.kernel.org/r/1501527386-10736-2-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/hugetlb_encode.h |   34 ++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN /dev/null include/uapi/asm-generic/hugetlb_encode.h
--- /dev/null
+++ a/include/uapi/asm-generic/hugetlb_encode.h
@@ -0,0 +1,34 @@
+#ifndef _ASM_GENERIC_HUGETLB_ENCODE_H_
+#define _ASM_GENERIC_HUGETLB_ENCODE_H_
+
+/*
+ * Several system calls take a flag to request "hugetlb" huge pages.
+ * Without further specification, these system calls will use the
+ * system's default huge page size.  If a system supports multiple
+ * huge page sizes, the desired huge page size can be specified in
+ * bits [26:31] of the flag arguments.  The value in these 6 bits
+ * will encode the log2 of the huge page size.
+ *
+ * The following definitions are associated with this huge page size
+ * encoding in flag arguments.  System call specific header files
+ * that use this encoding should include this file.  They can then
+ * provide definitions based on these with their own specific prefix.
+ * for example:
+ * #define MAP_HUGE_SHIFT HUGETLB_FLAG_ENCODE_SHIFT
+ */
+
+#define HUGETLB_FLAG_ENCODE_SHIFT	26
+#define HUGETLB_FLAG_ENCODE_MASK	0x3f
+
+#define HUGETLB_FLAG_ENCODE_64KB	(16 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_512KB	(19 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_1MB		(20 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_2MB		(21 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_8MB		(23 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_16MB	(24 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_256MB	(28 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_1GB		(30 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_2GB		(31 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_16GB	(34 << HUGETLB_FLAG_ENCODE_SHIFT)
+
+#endif /* _ASM_GENERIC_HUGETLB_ENCODE_H_ */
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


