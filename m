From: akpm@linux-foundation.org
Subject: - hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:19 -0700
Message-ID: <200710190341.l9J3fJJr012810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934582AbXJSD4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ak@suse.de, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Hibernation: Arbitrary boot kernel support - generic code
has been removed from the -mm tree.  Its filename was
     hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Hibernation: Arbitrary boot kernel support - generic code
From: Rafael J. Wysocki <rjw@sisk.pl>

Add the bits needed for supporting arbitrary boot kernels to the common
hibernation code.

To support arbitrary boot kernels, make it possible to replace the 'struct
new_utsname' and the kernel version in the hibernation image header by some
architecture specific data that will be used to verify if the image is valid
and to restore the image.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/power.h    |   20 +++++++++++++-
 kernel/power/snapshot.c |   53 +++++++++++++++++++++++++-------------
 2 files changed, 54 insertions(+), 19 deletions(-)

diff -puN kernel/power/power.h~hibernation-arbitrary-boot-kernel-support-generic-code-rev-2 kernel/power/power.h
--- a/kernel/power/power.h~hibernation-arbitrary-boot-kernel-support-generic-code-rev-2
+++ a/kernel/power/power.h
@@ -11,14 +11,32 @@ struct swsusp_info {
 	unsigned long		size;
 } __attribute__((aligned(PAGE_SIZE)));
 
+#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_ARCH_HIBERNATION_HEADER
+/* Maximum size of architecture specific data in a hibernation header */
+#define MAX_ARCH_HEADER_SIZE	(sizeof(struct new_utsname) + 4)
 
+extern int arch_hibernation_header_save(void *addr, unsigned int max_size);
+extern int arch_hibernation_header_restore(void *addr);
+
+static inline int init_header_complete(struct swsusp_info *info)
+{
+	return arch_hibernation_header_save(info, MAX_ARCH_HEADER_SIZE);
+}
+
+static inline char *check_image_kernel(struct swsusp_info *info)
+{
+	return arch_hibernation_header_restore(info) ?
+			"architecture specific data" : NULL;
+}
+#endif /* CONFIG_ARCH_HIBERNATION_HEADER */
 
-#ifdef CONFIG_HIBERNATION
 /*
  * Keep some memory free so that I/O operations can succeed without paging
  * [Might this be more than 4 MB?]
  */
 #define PAGES_FOR_IO	((4096 * 1024) >> PAGE_SHIFT)
+
 /*
  * Keep 1 MB of memory free so that device drivers can allocate some pages in
  * their .suspend() routines without breaking the suspend to disk.
diff -puN kernel/power/snapshot.c~hibernation-arbitrary-boot-kernel-support-generic-code-rev-2 kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~hibernation-arbitrary-boot-kernel-support-generic-code-rev-2
+++ a/kernel/power/snapshot.c
@@ -1239,17 +1239,39 @@ asmlinkage int swsusp_save(void)
 	return 0;
 }
 
-static void init_header(struct swsusp_info *info)
+#ifndef CONFIG_ARCH_HIBERNATION_HEADER
+static int init_header_complete(struct swsusp_info *info)
 {
-	memset(info, 0, sizeof(struct swsusp_info));
+	memcpy(&info->uts, init_utsname(), sizeof(struct new_utsname));
 	info->version_code = LINUX_VERSION_CODE;
+	return 0;
+}
+
+static char *check_image_kernel(struct swsusp_info *info)
+{
+	if (info->version_code != LINUX_VERSION_CODE)
+		return "kernel version";
+	if (strcmp(info->uts.sysname,init_utsname()->sysname))
+		return "system type";
+	if (strcmp(info->uts.release,init_utsname()->release))
+		return "kernel release";
+	if (strcmp(info->uts.version,init_utsname()->version))
+		return "version";
+	if (strcmp(info->uts.machine,init_utsname()->machine))
+		return "machine";
+	return NULL;
+}
+#endif /* CONFIG_ARCH_HIBERNATION_HEADER */
+
+static int init_header(struct swsusp_info *info)
+{
+	memset(info, 0, sizeof(struct swsusp_info));
 	info->num_physpages = num_physpages;
-	memcpy(&info->uts, init_utsname(), sizeof(struct new_utsname));
-	info->cpus = num_online_cpus();
 	info->image_pages = nr_copy_pages;
 	info->pages = nr_copy_pages + nr_meta_pages + 1;
 	info->size = info->pages;
 	info->size <<= PAGE_SHIFT;
+	return init_header_complete(info);
 }
 
 /**
@@ -1303,7 +1325,11 @@ int snapshot_read_next(struct snapshot_h
 			return -ENOMEM;
 	}
 	if (!handle->offset) {
-		init_header((struct swsusp_info *)buffer);
+		int error;
+
+		error = init_header((struct swsusp_info *)buffer);
+		if (error)
+			return error;
 		handle->buffer = buffer;
 		memory_bm_position_reset(&orig_bm);
 		memory_bm_position_reset(&copy_bm);
@@ -1394,22 +1420,13 @@ duplicate_memory_bitmap(struct memory_bi
 	}
 }
 
-static inline int check_header(struct swsusp_info *info)
+static int check_header(struct swsusp_info *info)
 {
-	char *reason = NULL;
+	char *reason;
 
-	if (info->version_code != LINUX_VERSION_CODE)
-		reason = "kernel version";
-	if (info->num_physpages != num_physpages)
+	reason = check_image_kernel(info);
+	if (!reason && info->num_physpages != num_physpages)
 		reason = "memory size";
-	if (strcmp(info->uts.sysname,init_utsname()->sysname))
-		reason = "system type";
-	if (strcmp(info->uts.release,init_utsname()->release))
-		reason = "kernel release";
-	if (strcmp(info->uts.version,init_utsname()->version))
-		reason = "version";
-	if (strcmp(info->uts.machine,init_utsname()->machine))
-		reason = "machine";
 	if (reason) {
 		printk(KERN_ERR "swsusp: Resume mismatch: %s\n", reason);
 		return -EPERM;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
