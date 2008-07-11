From: akpm@linux-foundation.org
Subject: + mm-create-sys-kernel-mm.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:39:46 -0700
Message-ID: <200807111845.m6BIjRHU030959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372AbYGKSqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     mm: create /sys/kernel/mm
has been added to the -mm tree.  Its filename is
     mm-create-sys-kernel-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: create /sys/kernel/mm
From: Nishanth Aravamudan <nacc@us.ibm.com>

Add a kobject to create /sys/kernel/mm when sysfs is mounted.  The kobject
will exist regardless.  This will allow for the hugepage related sysfs
directories to exist under the mm "subsystem" directory.  Add an ABI file
appropriately.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm |    6 ++++++
 include/linux/kobject.h                   |    2 ++
 mm/mm_init.c                              |   15 +++++++++++++++
 3 files changed, 23 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-kernel-mm
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm
@@ -0,0 +1,6 @@
+What:		/sys/kernel/mm
+Date:		July 2008
+Contact:	Nishanth Aravamudan <nacc@us.ibm.com>, VM maintainers
+Description:
+		/sys/kernel/mm/ should contain any and all VM
+		related information in /sys/kernel/.
diff -puN include/linux/kobject.h~mm-create-sys-kernel-mm include/linux/kobject.h
--- a/include/linux/kobject.h~mm-create-sys-kernel-mm
+++ a/include/linux/kobject.h
@@ -186,6 +186,8 @@ extern struct kobject *kset_find_obj(str
 
 /* The global /sys/kernel/ kobject for people to chain off of */
 extern struct kobject *kernel_kobj;
+/* The global /sys/kernel/mm/ kobject for people to chain off of */
+extern struct kobject *mm_kobj;
 /* The global /sys/hypervisor/ kobject for people to chain off of */
 extern struct kobject *hypervisor_kobj;
 /* The global /sys/power/ kobject for people to chain off of */
diff -puN mm/mm_init.c~mm-create-sys-kernel-mm mm/mm_init.c
--- a/mm/mm_init.c~mm-create-sys-kernel-mm
+++ a/mm/mm_init.c
@@ -7,6 +7,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/kobject.h>
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
@@ -134,3 +135,17 @@ static __init int set_mminit_loglevel(ch
 }
 early_param("mminit_loglevel", set_mminit_loglevel);
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
+
+struct kobject *mm_kobj;
+EXPORT_SYMBOL_GPL(mm_kobj);
+
+static int __init mm_sysfs_init(void)
+{
+	mm_kobj = kobject_create_and_add("mm", kernel_kobj);
+	if (!mm_kobj)
+		return -ENOMEM;
+
+	return 0;
+}
+
+__initcall(mm_sysfs_init);
_

Patches currently in -mm which might be from nacc@us.ibm.com are

vma-page-offset-has-no-callees-drop-it.patch
mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch
mm-create-sys-kernel-mm.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch
hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch
hugetlb-abstract-numa-round-robin-selection.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
fs-check-for-statfs-overflow.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch

