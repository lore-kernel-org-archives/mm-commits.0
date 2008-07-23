From: akpm@linux-foundation.org
Subject: - hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:03:14 -0700
Message-ID: <200807232315.m6NNFpDZ017116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233AbYGWXQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     hugetlb: hang off of /sys/kernel/mm rather than /sys/kernel
has been removed from the -mm tree.  Its filename was
     hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch

This patch was dropped because it was folded into hugetlb-new-sysfs-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: hang off of /sys/kernel/mm rather than /sys/kernel
From: Nishanth Aravamudan <nacc@us.ibm.com>

To keep /sys/kernel uncluttered, use the newly created /sys/kernel/mm as
the parent for the hugepage-controlling directories/files. Update the
ABI file and redirect the user to the more complete vm/hugetlbpage.txt
for details on hugepage usage.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-hugepages    |   14 ------
 Documentation/ABI/testing/sysfs-kernel-mm-hugepages |   15 ++++++
 Documentation/vm/hugetlbpage.txt                    |   23 ++++++++++
 mm/hugetlb.c                                        |    2 
 4 files changed, 39 insertions(+), 15 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-kernel-hugepages~hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel /dev/null
--- a/Documentation/ABI/testing/sysfs-kernel-hugepages
+++ /dev/null
@@ -1,14 +0,0 @@
-What:		/sys/kernel/hugepages/
-Date:		June 2008
-Contact:	Nishanth Aravamudan <nacc@us.ibm.com>, hugetlb maintainers
-Description:
-		/sys/kernel/hugepages/ contains a number of subdirectories
-		of the form hugepages-<size>kb, where <size> is the page size
-		of the hugepages supported by the kernel/CPU combination.
-
-		Under these directories are a number of files:
-		nr_hugepages - minimum number of hugepages reserved
-		nr_overcommit_hugepages - maximum number that can be allocated
-		free_hugepages - number of hugepages free
-		surplus_hugepages -
-		resv_hugepages -
diff -puN /dev/null Documentation/ABI/testing/sysfs-kernel-mm-hugepages
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-hugepages
@@ -0,0 +1,15 @@
+What:		/sys/kernel/mm/hugepages/
+Date:		June 2008
+Contact:	Nishanth Aravamudan <nacc@us.ibm.com>, hugetlb maintainers
+Description:
+		/sys/kernel/mm/hugepages/ contains a number of subdirectories
+		of the form hugepages-<size>kB, where <size> is the page size
+		of the hugepages supported by the kernel/CPU combination.
+
+		Under these directories are a number of files:
+			nr_hugepages
+			nr_overcommit_hugepages
+			free_hugepages
+			surplus_hugepages
+			resv_hugepages
+		See Documentation/vm/hugetlbpage.txt for details.
diff -puN Documentation/vm/hugetlbpage.txt~hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel
+++ a/Documentation/vm/hugetlbpage.txt
@@ -95,6 +95,29 @@ this condition holds, however, no more s
 allowed on the system until one of the two sysctls are increased
 sufficiently, or the surplus huge pages go out of use and are freed.
 
+With support for multiple hugepage pools at run-time available, much of
+the hugepage userspace interface has been duplicated in sysfs. The above
+information applies to the default hugepage size (which will be
+controlled by the proc interfaces for backwards compatibility). The root
+hugepage control directory is
+
+	/sys/kernel/mm/hugepages
+
+For each hugepage size supported by the running kernel, a subdirectory
+will exist, of the form
+
+	hugepages-${size}kB
+
+Inside each of these directories, the same set of files will exist:
+
+	nr_hugepages
+	nr_overcommit_hugepages
+	free_hugepages
+	resv_hugepages
+	surplus_hugepages
+
+which function as described above for the default hugepage-sized case.
+
 If the user applications are going to request hugepages using mmap system
 call, then it is required that system administrator mount a file system of
 type hugetlbfs:
diff -puN mm/hugetlb.c~hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel
+++ a/mm/hugetlb.c
@@ -1168,7 +1168,7 @@ static void __init hugetlb_sysfs_init(vo
 	struct hstate *h;
 	int err;
 
-	hugepages_kobj = kobject_create_and_add("hugepages", kernel_kobj);
+	hugepages_kobj = kobject_create_and_add("hugepages", mm_kobj);
 	if (!hugepages_kobj)
 		return;
 
_

Patches currently in -mm which might be from nacc@us.ibm.com are

vma-page-offset-has-no-callees-drop-it.patch
mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch
mm-create-sys-kernel-mm.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch
hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch
hugetlb-abstract-numa-round-robin-selection.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
fs-check-for-statfs-overflow.patch

