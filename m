From: akpm@linux-foundation.org
Subject: - mm-create-sys-kernel-mm.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:53 -0700
Message-ID: <200807242322.m6ONMr2u010603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756425AbYGXX2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: create /sys/kernel/mm
has been removed from the -mm tree.  Its filename was
     mm-create-sys-kernel-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: create /sys/kernel/mm
From: Nishanth Aravamudan <nacc@us.ibm.com>

Add a kobject to create /sys/kernel/mm when sysfs is mounted.  The kobject
will exist regardless.  This will allow for the hugepage related sysfs
directories to exist under the mm "subsystem" directory.  Add an ABI file
appropriately.

[kosaki.motohiro@jp.fujitsu.com: fix build]
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm |    6 ++++++
 include/linux/kobject.h                   |    2 ++
 mm/mm_init.c                              |   16 ++++++++++++++++
 3 files changed, 24 insertions(+)

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
@@ -7,6 +7,8 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
@@ -134,3 +136,17 @@ static __init int set_mminit_loglevel(ch
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

origin.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch

