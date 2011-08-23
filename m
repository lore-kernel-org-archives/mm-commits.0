From: akpm@linux-foundation.org
Subject: + drivers-base-inodec-let-vmstat_text-be-optional.patch added to -mm tree
Date: Tue, 23 Aug 2011 14:39:51 -0700
Message-ID: <201108232139.p7NLdpeA008408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730Ab1HWVj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 17:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, amwang@redhat.com, greg@kroah.com


The patch titled
     drivers/base/inode.c: let vmstat_text be optional
has been added to the -mm tree.  Its filename is
     drivers-base-inodec-let-vmstat_text-be-optional.patch

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
Subject: drivers/base/inode.c: let vmstat_text be optional
From: Randy Dunlap <rdunlap@xenotime.net>

vmstat_text is only available when PROC_FS or SYSFS is enabled.  This
causes build errors in drivers/base/node.c when they are both disabled:

drivers/built-in.o: In function `node_read_vmstat':
node.c:(.text+0x10e28f): undefined reference to `vmstat_text'

Rather than litter drivers/base/node.c with #ifdef/#endif around the
affected lines of code, add macros for optional sysdev attributes so that
those lines of code will be ignored, without using #ifdef/#endif in the .c
file(s).  I.e., the ifdeffery is done only in a header file with
sysdev_create_file_optional() and sysdev_remove_file_optional().

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    6 ++++--
 include/linux/sysdev.h |   14 ++++++++++++++
 include/linux/vmstat.h |    2 ++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff -puN drivers/base/node.c~drivers-base-inodec-let-vmstat_text-be-optional drivers/base/node.c
--- a/drivers/base/node.c~drivers-base-inodec-let-vmstat_text-be-optional
+++ a/drivers/base/node.c
@@ -176,6 +176,7 @@ static ssize_t node_read_numastat(struct
 }
 static SYSDEV_ATTR(numastat, S_IRUGO, node_read_numastat, NULL);
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
 static ssize_t node_read_vmstat(struct sys_device *dev,
 				struct sysdev_attribute *attr, char *buf)
 {
@@ -190,6 +191,7 @@ static ssize_t node_read_vmstat(struct s
 	return n;
 }
 static SYSDEV_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
+#endif
 
 static ssize_t node_read_distance(struct sys_device * dev,
 			struct sysdev_attribute *attr, char * buf)
@@ -274,7 +276,7 @@ int register_node(struct node *node, int
 		sysdev_create_file(&node->sysdev, &attr_meminfo);
 		sysdev_create_file(&node->sysdev, &attr_numastat);
 		sysdev_create_file(&node->sysdev, &attr_distance);
-		sysdev_create_file(&node->sysdev, &attr_vmstat);
+		sysdev_create_file_optional(&node->sysdev, &attr_vmstat);
 
 		scan_unevictable_register_node(node);
 
@@ -299,7 +301,7 @@ void unregister_node(struct node *node)
 	sysdev_remove_file(&node->sysdev, &attr_meminfo);
 	sysdev_remove_file(&node->sysdev, &attr_numastat);
 	sysdev_remove_file(&node->sysdev, &attr_distance);
-	sysdev_remove_file(&node->sysdev, &attr_vmstat);
+	sysdev_remove_file_optional(&node->sysdev, &attr_vmstat);
 
 	scan_unevictable_unregister_node(node);
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
diff -puN include/linux/sysdev.h~drivers-base-inodec-let-vmstat_text-be-optional include/linux/sysdev.h
--- a/include/linux/sysdev.h~drivers-base-inodec-let-vmstat_text-be-optional
+++ a/include/linux/sysdev.h
@@ -114,6 +114,20 @@ struct sysdev_attribute { 
 extern int sysdev_create_file(struct sys_device *, struct sysdev_attribute *);
 extern void sysdev_remove_file(struct sys_device *, struct sysdev_attribute *);
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
+#define sysdev_create_file_optional(sysdev, sysdevattr)	\
+	return sysdev_create_file(sysdev, sysdevattr);
+
+#define sysdev_remove_file_optional(sysdev, sysdevattr)	\
+		sysdev_remove_file(sysdev, sysdevattr);
+#else
+#define sysdev_create_file_optional(sysdev, sysdevattr)	\
+		(0)
+
+#define sysdev_remove_file_optional(sysdev, sysdevattr)	\
+		do {} while (0)
+#endif
+
 /* Create/remove NULL terminated attribute list */
 static inline int
 sysdev_create_files(struct sys_device *d, struct sysdev_attribute **a)
diff -puN include/linux/vmstat.h~drivers-base-inodec-let-vmstat_text-be-optional include/linux/vmstat.h
--- a/include/linux/vmstat.h~drivers-base-inodec-let-vmstat_text-be-optional
+++ a/include/linux/vmstat.h
@@ -258,6 +258,8 @@ static inline void refresh_zone_stat_thr
 
 #endif		/* CONFIG_SMP */
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
 extern const char * const vmstat_text[];
+#endif
 
 #endif /* _LINUX_VMSTAT_H */
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drm-fix-kconfig-unmet-dependency-warning.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
drivers-base-inodec-let-vmstat_text-be-optional.patch
drivers-base-inodec-let-vmstat_text-be-optional-fix.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

